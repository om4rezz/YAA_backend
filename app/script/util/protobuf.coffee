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

z.util.protobuf =

  load_protos: (file) ->
    return new Promise (resolve, reject) ->
      dcodeIO.ProtoBuf.loadProtoFile file, (error, builder) ->
        if error
          reject new Error "Loading protocol buffer file failed: #{error.message}"
        else
          z.proto ?= {}
          _.extend z.proto, builder.build()
          resolve()
