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

# https://github.com/jsoverson/grunt-open

module.exports =
  dist:
    path: 'http://localhost:<%= config.server.port %>/auth/#login'
  aws:
    path: 'http://localhost:<%= config.aws.port %>/'
  ebs:
    path: '<%= grunt.config("aws.deploy.options.application_versions") %>'
