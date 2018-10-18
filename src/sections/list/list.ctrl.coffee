angular.module('listController', ['hgMiscToolsService', 'hgNodeToolsService', 'geniusZoneDirective', 'roomSubmenu'])
.controller 'listCtrl', [
  '$rootScope',
  '$scope',
  '$state'
  'provideAuthorizationRepository'
  'hgNodeTools'
  '$ionicLoading'
  ($rootScope, $scope, $state, provideAuthorizationRepository, hgNodeTools, $ionicLoading) ->
    
    if $rootScope.zones? then $ionicLoading.hide() else $ionicLoading.show()
    
    $rootScope.$watchCollection 'zones', (newVal, oldVal) ->
      if newVal != oldVal
        if $rootScope.zones? then $ionicLoading.hide() else $ionicLoading.show()
        
    $scope.logout = ->
      delete $rootScope.settings.token
      $state.go 'login'
    
    removeWatcher = $rootScope.$watchCollection 'zones', (newVal, oldVal) ->

    $scope.$on '$destroy', ->
      removeWatcher()
]

.filter 'hideZoneType', ($filter, hgMiscTools) ->
  (zone, hide) ->
    $filter('filter') zone, (z) ->
      type = hgMiscTools.mapZoneType(z.type)
      hide.indexOf(type) == -1
