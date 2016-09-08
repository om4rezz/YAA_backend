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
z.event ?= {}

# Enum of diffent webapp events.
z.event.WebApp =
  ACTION:
    SHOW: 'YAA.webapp.action.show'
  ANALYTICS:
    EVENT: 'YAA.webapp.analytics.event'
    INIT: 'YAA.webapp.analytics.init'
    SESSION:
      CLOSE: 'YAA.webapp.analytics.session.close'
      START: 'YAA.webapp.analytics.session.start'
  AUDIO:
    PLAY: 'YAA.webapp.audio.play'
    PLAY_IN_LOOP: 'YAA.webapp.audio.play-in-loop'
    STOP: 'YAA.webapp.audio.stop'
  APP:
    UPDATE_INIT: 'YAA.webapp.app.update-init'
    HIDE: 'YAA.webapp.app.hide'
    FADE_IN: 'YAA.webapp.app.fade-in'
  ARCHIVE:
    SHOW: 'YAA.webapp.archive.show'
    CLOSE: 'YAA.webapp.archive.close'
  CALL:
    EVENT_FROM_BACKEND: 'YAA.webapp.call.event-from-backend'
    STATE:
      CHECK: 'YAA.webapp.call.state.check'
      DELETE: 'YAA.webapp.call.state.delete'
      IGNORE: 'YAA.webapp.call.state.ignore'
      JOIN: 'YAA.webapp.call.state.join'
      LEAVE: 'YAA.webapp.call.state.leave'
      REMOVE_PARTICIPANT: 'YAA.webapp.call.state.remove-participant'
      TOGGLE: 'YAA.webapp.call.state.toggle'
      TOGGLE_SCREEN: 'YAA.webapp.call.state.toggle-screen'
    MEDIA:
      MUTE_AUDIO: 'YAA.webapp.call.media.mute_audio'
      ADD_STREAM: 'YAA.webapp.call.media.add_stream'
    SIGNALING:
      DELETE_FLOW: 'YAA.webapp.call.signaling.delete-flow'
      POST_FLOWS: 'YAA.webapp.call.signaling.post-flows'
      SEND_ICE_CANDIDATE_INFO: 'YAA.webapp.call.signaling.send-ice-candidate-info'
      SEND_LOCAL_SDP_INFO: 'YAA.webapp.call.signaling.send-local-sdp-info'
  CLIENT:
    DELETE: 'YAA.webapp.client.delete'
  CONNECT:
    IMPORT_CONTACTS: 'YAA.webapp.connect.import-contacts'
  CONNECTION:
    ACCESS_TOKEN:
      RENEW: 'YAA.webapp.connection.access-token.renew'
      RENEWED: 'YAA.webapp.connection.access-token.renewed'
    ONLINE: 'YAA.webapp.connection.online'
  CONVERSATION:
    DEBUG: 'YAA.webapp.conversation.debug'
    EVENT_FROM_BACKEND: 'YAA.webapp.conversation.event-from-backend'
    LOADED_STATES: 'YAA.webapp.conversation.loaded-states'
    MAP_CONNECTION: 'YAA.webapp.conversation.map-connection'
    PEOPLE:
      HIDE: 'YAA.webapp.conversation.people.hide'
    SHOW: 'YAA.webapp.conversation.show'
    STORE: 'YAA.webapp.conversation.store'
    SWITCH: 'YAA.webapp.conversation.switch'
    DETAIL_VIEW:
      SHOW: 'YAA.webapp.conversation.detail-view.show'
    UNREAD: 'YAA.webapp.conversation.unread'
    ASSET:
      CANCEL: 'YAA.webapp.conversation.asset.cancel'
    MESSAGE:
      EDIT: 'YAA.webapp.conversation.message.edit'
    IMAGE:
      SEND: 'YAA.webapp.conversation.image.send'
  CONVERSATION_LIST:
    SHOW: 'YAA.webapp.conversation-list.show'
    ARCHIVE:
      HIDE: 'YAA.webapp.conversation-list.archive.hide'
  CONTEXT_MENU: 'YAA.webapp.context-menu'
  DEBUG:
    UPDATE_LAST_CALL_STATUS: 'YAA.webapp.debug.update-last-call-status'
  EXTENSIONS:
    SHOW: 'YAA.webapp.extionsions.show'
    GIPHY:
      SHOW: 'YAA.webapp.extionsions.giphy.show'
      SEND: 'YAA.webapp.extionsions.giphy.send'
  EVENT:
    INJECT: 'YAA.webapp.event.inject'
    NOTIFICATION_HANDLING_STATE: 'YAA.webapp.event.notification_handling'
  LIST:
    BLUR: 'YAA.webapp.list.blur'
    SCROLL: 'YAA.webapp.list.scroll'
    FULLSCREEN_ANIM_DISABLED: 'YAA.webapp.list.anim-disabled'
  LOADED: 'YAA.webapp.loaded'
  PEOPLE:
    HIDE: 'YAA.webapp.participant-et.hide'
    SHOW: 'YAA.webapp.participant-et.show'
    TOGGLE: 'YAA.webapp.participants.toggle'
  PENDING:
    SHOW: 'YAA.webapp.pending.show'
  LEFT:
    HIDE: 'YAA.webapp.left.hide'
    FADE_IN: 'YAA.webapp.left.fade-in'
  LOGOUT:
    ASK_TO_CLEAR_DATA: 'YAA.webapp.logout.ask-to-clear-data'
  WELCOME:
    SHOW: 'YAA.webapp.profile.welcome.show'
    UNSPLASH_LOADED: 'YAA.webapp.profile.welcome.unsplash-loaded'
  PROFILE:
    SHOW: 'YAA.webapp.profile.show'
    HIDE: 'YAA.webapp.profile.hide'
    FADE_IN: 'YAA.webapp.profile.fade-in'
    SETTINGS:
      SHOW: 'YAA.webapp.profile.settings.show'
    UPLOAD_PICTURE: 'YAA.webapp.profile.upload-picture'
  PROPERTIES:
    CHANGE:
      APP_BANNER: 'YAA.webapp.properties.change.app-banner'
      DEBUG: 'YAA.webapp.properties.change.debug'
    UPDATE:
      GOOGLE: 'YAA.webapp.properties.update.google'
      OSX_CONTACTS: 'YAA.webapp.properties.update.google'
      CALL_MUTE: 'YAA.webapp.properties.update.call-mute'
      SEND_DATA: 'YAA.webapp.properties.update.send-data'
      SOUND_ALERTS: 'YAA.webapp.properties.update.sound-alerts'
      HAS_CREATED_CONVERSATION: 'YAA.webapp.properties.update.has-created-conversation'
    UPDATED: 'YAA.webapp.properties.updated'
  SEARCH:
    HIDE: 'YAA.webapp.search.hide'
    ONBOARDING: 'YAA.webapp.search.onboarding'
    SHOW: 'YAA.webapp.people-picker.show'
    BADGE:
      HIDE: 'YAA.webapp.search.badge.hide'
      SHOW: 'YAA.webapp.search.badge.show'
  SIGN_OUT: 'YAA.webapp.logout'
  SYSTEM_NOTIFICATION:
    CLICK: 'YAA.webapp.system-notification.click'
    NOTIFY: 'YAA.webapp.system-notification.notify'
    REMOVE_READ: 'YAA.webapp.system.notification.remove_read'
    REQUEST_PERMISSION: 'YAA.webapp.system-notification.request_permission'
    SHOW: 'YAA.webapp.system-notification.show'
  TELEMETRY:
    BACKEND_REQUESTS: 'YAA.webapp.telemetry.backend_requests'
  USER:
    UNBLOCKED: 'YAA.webapp.user.unblocked'
    EVENT_FROM_BACKEND: 'YAA.webapp.user.event-from-backend'
  WARNING:
    SHOW: 'YAA.webapp.warning.show'
    DISMISS: 'YAA.webapp.warning.dismiss'
    MODAL: 'YAA.webapp.warning.modal'
  WINDOW:
    RESIZE:
      HEIGHT: 'YAA.webapp.window.resize.height'
      WIDTH: 'YAA.webapp.window.resize.width'
  SELF:
    CLIENT_ADD: 'YAA.webapp.self.client-add'
    CLIENT_REMOVE: 'YAA.webapp.self.client-remove'
  SHORTCUT:
    ADD_PEOPLE: 'YAA.webapp.shortcut.add-people'
    ARCHIVE: 'YAA.webapp.shortcut.archive'
    CALL_IGNORE: 'YAA.webapp.shortcut.call-ignore'
    CALL_MUTE: 'YAA.webapp.shortcut.call-mute'
    DEBUG: 'YAA.webapp.shortcut.debug'
    NEXT: 'YAA.webapp.shortcut.next'
    PEOPLE: 'YAA.webapp.shortcut.people'
    PICTURE: 'YAA.webapp.shortcut.picture'
    PING: 'YAA.webapp.shortcut.ping'
    PREV: 'YAA.webapp.shortcut.prev'
    SILENCE: 'YAA.webapp.shortcut.silence'
    START: 'YAA.webapp.shortcut.start'
  STORAGE:
    SAVE_ENTITY: 'YAA.webapp.storage.save-entity'
