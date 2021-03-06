#
# YAA
# Copyright (C) 2016 YAA Swiss GmbH
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see http://www.gnu.org/licenses/.
#

window.z ?= {}
z.service ?= {}

IGNORED_BACKEND_ERRORS = [
  z.service.BackendClientError::STATUS_CODE.BAD_GATEWAY
  z.service.BackendClientError::STATUS_CODE.BAD_REQUEST
  z.service.BackendClientError::STATUS_CODE.CONFLICT
  z.service.BackendClientError::STATUS_CODE.CONNECTIVITY_PROBLEM
  z.service.BackendClientError::STATUS_CODE.INTERNAL_SERVER_ERROR
  z.service.BackendClientError::STATUS_CODE.NOT_FOUND
  z.service.BackendClientError::STATUS_CODE.PRECONDITION_FAILED
  z.service.BackendClientError::STATUS_CODE.REQUEST_TIMEOUT
  z.service.BackendClientError::STATUS_CODE.REQUEST_TOO_LARGE
  z.service.BackendClientError::STATUS_CODE.TOO_MANY_REQUESTS
]

# Client for all backend REST API calls.
class z.service.Client
  ###
  Construct a new client.

  @param settings [Object] Settings for different backend environments
  @option settings [String] environment
  @option settings [String] rest_url
  @option settings [String] web_socket_url
  @option settings [String] parameter
  ###
  constructor: (settings) ->
    @logger = new z.util.Logger 'z.service.Client', z.config.LOGGER.OPTIONS

    z.util.Environment.backend.current = settings.environment
    @rest_url = settings.rest_url
    @web_socket_url = settings.web_socket_url

    @request_queue = []
    @is_requesting_access_token = ko.observable false
    @is_requesting_access_token.subscribe (is_requesting) =>
      @execute_request_queue() if @access_token isnt '' and @request_queue.length > 0 and not is_requesting

    @access_token = ''
    @access_token_type = ''

    @number_of_requests = ko.observable 0
    @number_of_requests.subscribe (new_value) ->
      amplify.publish z.event.WebApp.TELEMETRY.BACKEND_REQUESTS, new_value

    # http://stackoverflow.com/a/18996758/451634
    pre_filters = $.Callbacks()
    pre_filters.before_each_request = (options, originalOptions, jqXHR) =>
      jqXHR.YAA =
        original_request_options: originalOptions
        request_id: @number_of_requests()
        requested: new Date()

    $.ajaxPrefilter pre_filters.before_each_request

  ###
  Create a request URL.
  @param url [String] API endpoint to be prefixed with REST API environment
  @return [String] REST API endpoint
  ###
  create_url: (url) ->
    return "#{@rest_url}#{url}"

  ###
  Request backend status.
  @return [$.Promise] jquery ajax promise
  ###
  status: =>
    $.ajax
      type: 'HEAD'
      timeout: 500
      url: @create_url '/self'

  ###
  Delay a function call until backend connectivity is guaranteed.
  @return [Promise] Promise that is resolved when connectivity is verified
  ###
  execute_on_connectivity: =>
    return new Promise (resolve) =>
      check_status = =>
        @logger.log @logger.levels.INFO, 'Checking connectivity status'
        @status()
        .done =>
          @logger.log @logger.levels.INFO, 'Connectivity verified.'
          resolve()
        .fail (jqXHR) =>
          if jqXHR.readyState is 4
            @logger.log @logger.levels.INFO, "Connectivity verified by server error: #{jqXHR.statusText}"
            resolve()
          else
            window.setTimeout check_status, 2000

      check_status()

  # Execute queued requests.
  execute_request_queue: =>
    @logger.log @logger.levels.INFO, "Executing '#{@request_queue.length}' queued requests"
    for request in @request_queue
      [config, request_resolve, request_reject] = @request_queue.shift()
      @send_request config
      .then (response) =>
        @logger.log @logger.levels.INFO, "Queued '#{config.type}' request to '#{config.url}' executed", response
        request_resolve response
      .catch (error) =>
        @logger.log @logger.levels.INFO,
          "Failed to execute queued '#{config.type}' request to '#{config.url}'", error
        request_reject error

  ###
  Send jQuery AJAX request.
  @see http://api.jquery.com/jquery.ajax/#jQuery-ajax-settings
  @param config [jQuery.ajax SettingsObject]
  ###
  send_request: (config) ->
    return new Promise (resolve, reject) =>
      if @is_requesting_access_token()
        @logger.log @logger.levels.INFO, 'Request queued while access token is refreshed', config
        @request_queue.push [config, resolve, reject]
      else
        headers = config.headers or {}
        headers['Authorization'] = "#{@access_token_type} #{@access_token}" if @access_token

        xhrFields = {}
        xhrFields['withCredentials'] = true if config.withCredentials

        @number_of_requests @number_of_requests() + 1

        if _.isArray config.callback
          $.ajax
            contentType: config.contentType
            data: config.data
            headers: headers
            processData: config.processData
            timeout: config.timeout
            type: config.type
            url: config.url
            xhrFields: xhrFields
          .always (data_or_jqXHR, textStatus, jqXHR_or_data) =>
            if textStatus not in ['error', 'timeout']
              if jqXHR_or_data.YAA
                jqXHR_or_data.YAA.original_request_options.api_endpoint = config.api_endpoint
                jqXHR_or_data.YAA.responded = new Date()
              resolve [data_or_jqXHR, jqXHR_or_data]
            else
              switch data_or_jqXHR.status
                when z.service.BackendClientError::STATUS_CODE.CONNECTIVITY_PROBLEM
                  @logger.log @logger.levels.WARN, 'Request failed due to connectivity problem.', config
                  @request_queue.push [config, resolve, reject]
                  @execute_on_connectivity().then => @execute_request_queue()
                when z.service.BackendClientError::STATUS_CODE.UNAUTHORIZED
                  @logger.log @logger.levels.WARN, 'Request failed as access token is invalid.', config
                  @request_queue.push [config, resolve, reject]
                  amplify.publish z.event.WebApp.CONNECTION.ACCESS_TOKEN.RENEW
                else
                  reject data_or_jqXHR.responseJSON or new z.service.BackendClientError data_or_jqXHR.status
        else
          $.ajax
            contentType: config.contentType
            data: config.data
            headers: headers
            processData: config.processData
            timeout: config.timeout
            type: config.type
            url: config.url
          .done (data, textStatus, jqXHR) =>
            @logger.log @logger.levels.OFF, "Server Response ##{jqXHR.YAA.request_id} from '#{config.url}':", data
            config.callback? data
            resolve data
          .fail (jqXHR, textStatus, errorThrown) =>
            switch jqXHR.status
              when z.service.BackendClientError::STATUS_CODE.CONNECTIVITY_PROBLEM
                @logger.log @logger.levels.WARN, 'Request failed due to connectivity problem.'
                @request_queue.push [config, resolve, reject]
                @execute_on_connectivity().then => @execute_request_queue()
                return
              when z.service.BackendClientError::STATUS_CODE.UNAUTHORIZED
                @request_queue.push [config, resolve, reject]
                @logger.log @logger.levels.WARN, 'Request failed as access token is invalid.'
                amplify.publish z.event.WebApp.CONNECTION.ACCESS_TOKEN.RENEW
                return
              when z.service.BackendClientError::STATUS_CODE.FORBIDDEN
                switch jqXHR.responseJSON?.label
                  when z.service.BackendClientError::LABEL.INVALID_CREDENTIALS
                    Raygun.send new Error 'Server request failed: Invalid credentials'
                  when z.service.BackendClientError::LABEL.TOO_MANY_CLIENTS, z.service.BackendClientError::LABEL.TOO_MANY_MEMBERS
                    @logger.log @logger.levels.WARN, "Server request failed: '#{jqXHR.responseJSON.label}'"
                  else
                    Raygun.send new Error 'Server request failed'
              else
                if jqXHR.status not in IGNORED_BACKEND_ERRORS
                  Raygun.send new Error "Server request failed: #{jqXHR.status}"

            if _.isFunction config.callback
              config.callback null, jqXHR.responseJSON or new z.service.BackendClientError errorThrown
            else
              if navigator.onLine
                reject jqXHR.responseJSON or new z.service.BackendClientError jqXHR.status
              else
                error_data =
                  code: z.service.BackendClientError::STATUS_CODE.CONNECTIVITY_PROBLEM
                  label: z.service.BackendClientError::LABEL.CONNECTIVITY_PROBLEM
                  message: 'Problem with the network connectivity'
                reject new z.service.BackendClientError error_data

  ###
  Send AJAX request with compressed JSON body.

  @param config [Object]
  @option config [Function] callback
  @option config [JSON] data
  @option config [String] type
  @option config [String] url
  ###
  send_json: (config) ->
    @send_request
      api_endpoint: config.api_endpoint
      callback: config.callback
      contentType: 'application/json; charset=utf-8'
      data: pako.gzip JSON.stringify config.data if config.data
      headers:
        'Content-Encoding': 'gzip'
      processData: false
      type: config.type
      url: config.url
