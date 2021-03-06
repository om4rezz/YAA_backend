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

z.location = do ->
  GOOGLE_GEOCODING_BASE_URL = 'https://maps.googleapis.com/maps/api/geocode/json'
  API_KEY = 'AIzaSyCKxxKw5JBZ5zEFtoirtgnw8omvH7gWzfo'

  _parse_results = (results) ->
    res = {}
    result = results[0]

    res['address'] = result.formatted_address
    res['lat'] = result.geometry.location.lat
    res['lng'] = result.geometry.location.lng

    for component in result.address_components
      name = component.long_name or component.short_name
      for type in component.types
        res[type] = name
        if type is 'country'
          res['country_code'] = component.short_name or ''

    res['place'] = res.locality or res.natural_feature or res.administrative_area_level_3 or res.administrative_area_level_2 or res.administrative_area_level_1
    delete res.political?
    return res

  ###
  Reverse loop up for geo location

  @param lat [Number] latitude
  @param lng [Number] longitude
  @param callback [Function] Function to be called on return
  ###
  get_location = (lat, lng, callback) ->
    if not lat? or not lng?
      callback? 'You need to specify latitude and longitude in order to get the location'

    $.ajax
      url: "#{GOOGLE_GEOCODING_BASE_URL}?latlng=#{lat},#{lng}&key=#{API_KEY}"
    .done (response) ->
      if response.status is 'OK'
        callback? null, _parse_results response.results
      else
        callback? response.status
    .fail (jqXHR, textStatus, errorThrown) ->
      callback? errorThrown

  ###
  Return link to google maps

  @param lat [Number] latitude
  @param lng [Number] longitude
  @param name [String] location name
  @param zoom [String] map zoom level
  ###
  get_maps_url = (lat, lng, name, zoom) ->
    base_url = 'https://google.com/maps/'
    base_url += "place/#{name}/" if name?
    base_url += "@#{lat},#{lng}"
    base_url += ",#{zoom}z" if zoom?
    return base_url

  return {
    get_location: get_location
    get_maps_url: get_maps_url
  }
