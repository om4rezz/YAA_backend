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

# grunt test_init && grunt test_run:links/LinkPreviewHelpers

describe 'contains_only_link', ->

  it 'should return true if text only contains url (naked domain)', ->
    text = 'YAA.com'
    expect(z.links.LinkPreviewHelpers.contains_only_link(text)).toBeTruthy()

  it 'should return true if text only contains url (http domain)', ->
    text = 'http://YAA.com'
    expect(z.links.LinkPreviewHelpers.contains_only_link(text)).toBeTruthy()

  it 'should return true if text only contains url (https domain)', ->
    text = 'https://YAA.com'
    expect(z.links.LinkPreviewHelpers.contains_only_link(text)).toBeTruthy()

  it 'should ignore leading and trailing whitespaces', ->
    expect(z.links.LinkPreviewHelpers.contains_only_link(' http://YAA.com')).toBeTruthy()
    expect(z.links.LinkPreviewHelpers.contains_only_link('http://YAA.com ')).toBeTruthy()

  it 'should return false for multiple domains', ->
    text = 'http://YAA.com http://YAA.com'
    expect(z.links.LinkPreviewHelpers.contains_only_link(text)).toBeFalsy()

  it 'should return false when text contains domain and other text', ->
    text = 'see this http://YAA.com'
    expect(z.links.LinkPreviewHelpers.contains_only_link(text)).toBeFalsy()

describe 'get_first_link_with_offset', ->

  it 'should return undefined for simple text', ->
    text = 'foo bar baz'
    expect(z.links.LinkPreviewHelpers.get_first_link_with_offset(text)).not.toBeDefined()

  it 'should return correct link and offset for single link without text)', ->
    text = 'YAA.com'
    expect(z.links.LinkPreviewHelpers.get_first_link_with_offset(text)).toEqual ['YAA.com', 0]

  it 'should return correct link and offset for single link with text in front)', ->
    text = 'Hey check YAA.com'
    expect(z.links.LinkPreviewHelpers.get_first_link_with_offset(text)).toEqual ['YAA.com', 10]

  it 'should return correct link and offset for single link surrounded by text )', ->
    text = 'Hey check YAA.com PLEASE!'
    expect(z.links.LinkPreviewHelpers.get_first_link_with_offset(text)).toEqual ['YAA.com', 10]

  it 'should return correct link and offset for single link surrounded by text )', ->
    text = 'YAA.com YAA.com YAA.com YAA.com YAA.com'
    expect(z.links.LinkPreviewHelpers.get_first_link_with_offset(text)).toEqual ['YAA.com', 0]
