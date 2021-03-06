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
z.connect ?= {}

class z.connect.ConnectError
  constructor: (type) ->
    @name = @constructor.name
    @stack = (new Error()).stack
    @type = type or z.connect.ConnectError::TYPE.UNKNOWN

    @message = switch @type
      when z.connect.ConnectError::TYPE.GOOGLE_CLIENT
        'Google Auth Client for JavaScript not loaded'
      when z.connect.ConnectError::TYPE.GOOGLE_DOWNLOAD
        'Failed to download contacts from Google'
      when z.connect.ConnectError::TYPE.NO_CONTACTS
        'No contacts found for matching'
      when z.connect.ConnectError::TYPE.UPLOAD
        'Address book upload failed'
      else


  @:: = new Error()
  @::constructor = @
  @::TYPE =
    GOOGLE_CLIENT: 'z.connect.ConnectError::TYPE.GOOGLE_CLIENT'
    GOOGLE_DOWNLOAD: 'z.connect.ConnectError::TYPE.GOOGLE_DOWNLOAD'
    NO_CONTACTS: 'z.connect.ConnectError::TYPE.NO_CONTACTS'
    UPLOAD: 'z.connect.ConnectError::TYPE.UPLOAD'
