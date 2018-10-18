angular.module('hgMiscToolsService', [])
.service 'hgMiscTools', [
  '$q'
  '$http'
  '$rootScope'
  ($q, $http, $rootScope) ->
    hgMiscTools = this
   
    getLocalStorageSettings = () ->
      return localStorage.getItem('geniusAppLite::Data')

    setLocalStorageSettings = (obj) ->
      localStorage.setItem('geniusAppLite::Data', JSON.stringify(obj))

    getZones = (token)->
      url = "https://my.geniushub.co.uk/v#{$rootScope.settings.apiVersion}/zones"
      return $http({
        method: 'GET'
        headers: {
          "Content-type": "application/json"
          "Authorization": token
        }
        url: url
      })

    overrideZone = (id, params) ->
      url = "https://my.geniushub.co.uk/v#{$rootScope.settings.apiVersion}/zones/#{id}/override"
      return $http({
        method: 'POST'
        headers: {
          "Content-type": "application/json"
          "Authorization": $rootScope.settings.token
        }
        data: params
        url: url
      })

    mapZoneType = (type) ->
      map = {
        "manager": 1
        "radiator": 2
        "on / off": 3
        "wet underfloor": 4
        "hot water temperature": 5
        "group": 6
      }

      return map[type]

    return hgMiscTools = {
      getLocalStorageSettings
      setLocalStorageSettings
      getZones
      overrideZone
      mapZoneType
    }




]
