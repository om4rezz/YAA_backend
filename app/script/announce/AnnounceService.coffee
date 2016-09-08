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
z.announce ?= {}

class z.announce.AnnounceService
  constructor: ->
    @logger = new z.util.Logger 'z.announce.AnnounceService', z.config.LOGGER.OPTIONS
    @url = "#{z.config.ANNOUNCE_URL}?order=created&active=true"
    @url += '&production=true' if z.util.Environment.frontend.is_production()
    return @

  fetch: (callback) ->
    $.get @url
    .done (data, textStatus, jqXHR) ->
      callback? data['result']
    .fail (jqXHR, textStatus, errorThrown) =>
      @logger.log @logger.levels.ERROR, 'Failed to fetch announcements', errorThrown
      callback?()
