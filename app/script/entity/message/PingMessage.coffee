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
z.entity ?= {}

class z.entity.PingMessage extends z.entity.Message
  constructor: ->
    super()
    @super_type = z.message.SuperType.PING
    @animated = ko.observable false

    @caption = ko.computed =>
      string = if @user().is_me then z.string.conversation_ping_you else z.string.conversation_ping
      return z.localization.Localizer.get_text string
    , @, deferEvaluation: true

    @animation = ko.computed ->
      return 'ping-animation ping-animation-soft'
    , @, deferEvaluation: true
