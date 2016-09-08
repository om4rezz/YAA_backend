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

###############################################################################
# Setting up the Environment (EDGE)
###############################################################################
$ ->
  env = z.util.get_url_parameter z.auth.URLParameter.ENVIRONMENT
  if env? and env is 'prod'
    settings =
      environment: z.service.BackendEnvironment.PRODUCTION
      rest_url: 'https://prod-nginz-https.YAA.com'
      web_socket_url: 'wss://prod-nginz-ssl.YAA.com'
    settings.parameter = '?env=prod' if env?
  else if env? and env is 'staging'
    settings =
      environment: z.service.BackendEnvironment.STAGING
      rest_url: 'https://staging-nginz-https.zinfra.io'
      web_socket_url: 'wss://staging-nginz-ssl.zinfra.io'
    settings.parameter = '?env=staging' if env?
  else
    settings =
      environment: z.service.BackendEnvironment.EDGE
      rest_url: 'https://edge-nginz-https.zinfra.io'
      web_socket_url: 'wss://edge-nginz-ssl.zinfra.io'

  window.YAA =
    auth: new z.main.Auth settings
