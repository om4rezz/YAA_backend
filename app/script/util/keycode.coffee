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

window.z = window.z or {}
z.util = z.util or {}

z.util.KEYCODE =
  ARROW_DOWN: 40
  ARROW_LEFT: 37
  ARROW_RIGHT: 39
  ARROW_UP: 38
  BACKSPACE: 46
  DELETE: 8
  ESC: 27
  ENTER: 13
  V: 86

z.util.KEYCODE.is_arrow_key = (keyCode) ->
  return keyCode in [z.util.KEYCODE.ARROW_DOWN, z.util.KEYCODE.ARROW_LEFT, z.util.KEYCODE.ARROW_RIGHT, z.util.KEYCODE.ARROW_UP]
