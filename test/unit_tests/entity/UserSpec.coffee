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

# grunt test_init && grunt test_run:entity/User

describe 'z.entity.User', ->
  describe 'First Name', ->
    it 'can generate first name', ->
      user_et = new z.entity.User()
      user_et.name 'John Doe'
      expect(user_et.first_name()).toBe 'John'

  describe 'Last Name', ->
    it 'can generate last name', ->
      user_et = new z.entity.User()
      user_et.name 'John Doe'
      expect(user_et.last_name()).toBe 'Doe'

    it 'can generate last name', ->
      user_et = new z.entity.User()
      user_et.name 'John D. Doe'
      expect(user_et.last_name()).toBe 'Doe'

    it 'can ignore last name if user has only one name', ->
      user_et = new z.entity.User()
      user_et.name 'John'
      expect(user_et.last_name()).toBeUndefined()

  describe 'Initials', ->
    it 'returns correct initials for user with first name and last name', ->
      user_et = new z.entity.User()
      user_et.name 'John Doe'
      expect(user_et.initials()).toBe 'JD'

    it 'returns correct initials for user with just a first name', ->
      user_et = new z.entity.User()
      user_et.name 'John'
      expect(user_et.initials()).toBe 'JO'

    it 'returns correct initials for user with middle name', ->
      user_et = new z.entity.User()
      user_et.name 'John Peter Doe'
      expect(user_et.initials()).toBe 'JD'

    it 'returns correct initials for user with one character as name', ->
      user_et = new z.entity.User()
      user_et.name 'J'
      expect(user_et.initials()).toBe 'J'

    it 'returns correct initials for user with an emoji as name', ->
      user_et = new z.entity.User()
      user_et.name '🐒'
      expect(user_et.initials()).toBe '🐒'

  describe 'add_client', ->
    it 'accepts clients which are no duplicates', ->

      first_client = new z.client.Client()
      first_client.id = '5021d77752286cac'

      second_client = new z.client.Client()
      second_client.id = '575b7a890cdb7635'

      user_et = new z.entity.User()
      user_et.add_client first_client
      user_et.add_client second_client
      user_et.add_client second_client

      expect(user_et.devices().length).toBe 2

  describe 'accent_theme', ->
    it 'can change the accent theme', ->
      user_et = new z.entity.User()

      user_et.accent_id z.config.ACCENT_ID.BLUE
      expect(user_et.accent_theme()).toBe user_et.THEME.BLUE

      user_et.accent_id z.config.ACCENT_ID.GREEN
      expect(user_et.accent_theme()).toBe user_et.THEME.GREEN

      user_et.accent_id z.config.ACCENT_ID.ORANGE
      expect(user_et.accent_theme()).toBe user_et.THEME.ORANGE

      user_et.accent_id z.config.ACCENT_ID.PINK
      expect(user_et.accent_theme()).toBe user_et.THEME.PINK

      user_et.accent_id z.config.ACCENT_ID.PURPLE
      expect(user_et.accent_theme()).toBe user_et.THEME.PURPLE

      user_et.accent_id z.config.ACCENT_ID.RED
      expect(user_et.accent_theme()).toBe user_et.THEME.RED

      user_et.accent_id z.config.ACCENT_ID.YELLOW
      expect(user_et.accent_theme()).toBe user_et.THEME.YELLOW

      user_et.accent_id undefined
      expect(user_et.accent_theme()).toBe user_et.THEME.BLUE

  describe 'accent_color', ->
    it 'can change the accent color', ->
      user_et = new z.entity.User()

      user_et.accent_id z.config.ACCENT_ID.BLUE
      expect(user_et.accent_color()).toBe user_et.ACCENT_COLOR.BLUE

      user_et.accent_id z.config.ACCENT_ID.GREEN
      expect(user_et.accent_color()).toBe user_et.ACCENT_COLOR.GREEN

      user_et.accent_id z.config.ACCENT_ID.ORANGE
      expect(user_et.accent_color()).toBe user_et.ACCENT_COLOR.ORANGE

      user_et.accent_id z.config.ACCENT_ID.PINK
      expect(user_et.accent_color()).toBe user_et.ACCENT_COLOR.PINK

      user_et.accent_id z.config.ACCENT_ID.PURPLE
      expect(user_et.accent_color()).toBe user_et.ACCENT_COLOR.PURPLE

      user_et.accent_id z.config.ACCENT_ID.RED
      expect(user_et.accent_color()).toBe user_et.ACCENT_COLOR.RED

      user_et.accent_id z.config.ACCENT_ID.YELLOW
      expect(user_et.accent_color()).toBe user_et.ACCENT_COLOR.YELLOW

      user_et.accent_id undefined
      expect(user_et.accent_color()).toBe user_et.ACCENT_COLOR.BLUE

  describe 'picture_preview_url', ->
    it 'can generate a picture preview url', ->
      user_et = new z.entity.User()
      user_et.id = entities.user.john_doe.id

      urls =
        rest_url: 'http://localhost'
        websocket_url: 'wss://localhost'

      access_token = 'secret'
      client_service = new z.service.Client urls
      client_service.access_token = access_token

      window.YAA = auth: client: client_service

      picture_preview = ''
      expect(user_et.picture_preview_url()).toBe picture_preview

      picture_preview_url = "https://prod-nginz-https.YAA.com/assets/bf4bc4c1-b295-4c0f-af0b-9db335cc64be?access_token=#{client_service.access_token}&conv_id=#{user_et.id}"
      picture_preview = "url('#{picture_preview_url}')"
      user_et.picture_preview picture_preview
      expect(user_et.picture_preview_url()).toBe user_et.picture_preview()

      client_service.access_token = 'new-access-token'
      picture_preview_url = "https://prod-nginz-https.YAA.com/assets/bf4bc4c1-b295-4c0f-af0b-9db335cc64be?access_token=#{client_service.access_token}&conv_id=#{user_et.id}"
      picture_preview = "url('#{picture_preview_url}')"
      expect(user_et.picture_preview_url()).not.toBe user_et.picture_preview()
      expect(user_et.picture_preview_url()).toBe picture_preview

  describe 'picture_medium_url', ->
    it 'can generate a picture medium url', ->
      user_et = new z.entity.User()
      user_et.id = entities.user.john_doe.id

      urls =
        rest_url: 'http://localhost'
        websocket_url: 'wss://localhost'

      access_token = 'secret'
      client_service = new z.service.Client urls
      client_service.access_token = access_token

      window.YAA = auth: client: client_service

      picture_medium = ''
      expect(user_et.picture_medium_url()).toBe picture_medium

      picture_medium_url = "https://prod-nginz-https.YAA.com/assets/bf4bc4c1-b295-4c0f-af0b-9db335cc64be?access_token=#{client_service.access_token}&conv_id=#{user_et.id}"
      picture_medium = "url('#{picture_medium_url}')"
      user_et.picture_medium picture_medium
      expect(user_et.picture_medium_url()).toBe user_et.picture_medium()

      client_service.access_token = 'new-access-token'
      picture_medium_url = "https://prod-nginz-https.YAA.com/assets/bf4bc4c1-b295-4c0f-af0b-9db335cc64be?access_token=#{client_service.access_token }&conv_id=#{user_et.id}"
      picture_medium = "url('#{picture_medium_url}')"
      expect(user_et.picture_medium_url()).not.toBe user_et.picture_medium()
      expect(user_et.picture_medium_url()).toBe picture_medium

