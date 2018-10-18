angular.module('introController', [])
.controller('introCtrl', [
    '$rootScope'
    '$scope',
    '$state',
    'hgMiscTools'
    ($rootScope, $scope, $state, hgMiscTools) ->

      $scope.evtClickTourstartApp = ->
        $state.go 'app'
        $rootScope.settings.showIntro = false

])