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
z.util ?= {}
z.util.ArrayUtil ?= {}

###
Moves an element from one place to another by it's index.
This change happens in place which means that the array is modified immediately.

todo: nice idea, DSL with "move_element.from(...).to(...).in(...)"

@param from [Number] Source index of the element which should be moved
@param to [Number] Destination index of the element which should be moved
@param array [Array] Array where to move the array
@return [Array] Given array
###
z.util.ArrayUtil.move_element = (from, to, array) ->
  element = array[from]
  array.splice from, 1
  array.splice to, 0, element

###
Returns random element

@param array [Array] source
@return [Object] random element
###
z.util.ArrayUtil.random_element = (array) ->
  array[Math.floor(Math.random() * array.length)]

z.util.ArrayUtil.contains = (array, value) ->
  return array.indexOf(value) > -1

###
Interpolates an array of numbers using linear interpolation

@param array [Array] source
@param length [Number] new length
@return [Array] new array with interpolated values
###
z.util.ArrayUtil.interpolate = (array, length) ->
  new_array = []
  scale_factor = (array.length - 1) / (length - 1)

  new_array[0] = array[0]
  new_array[length - 1] = array[array.length - 1]

  for i in [1...length - 1]
    original_index = i * scale_factor
    before = Math.floor(original_index).toFixed()
    after = Math.ceil(original_index).toFixed()
    point = original_index - before
    new_array[i] = array[before] + (array[after] - array[before]) * point # linear interpolation

  return new_array
