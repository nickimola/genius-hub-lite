angular.module('loginController', ['hgMiscToolsService'])
.controller('loginCtrl', [
  '$rootScope'
  '$scope',
  '$state',
  'hgMiscTools'
  ($rootScope, $scope, $state, hgMiscTools) ->
    $scope.status = {
      text: ""
      failed: false
      spinner: false
    }

    $scope.needTokenHelp = false
    
    $scope.tokenHelp = ->
      console.log "toggle token help"
      $scope.needTokenHelp = !$scope.needTokenHelp

    $scope.login = () ->
      $scope.status = {
        text: "Logging into hub..."
        failed: false
        spinner: true
      }
      userToken = angular.element('#genius-token').val()
      if userToken
        hgMiscTools.getZones(userToken.trim())
        .then (res) ->
          if res.status == 200
            $rootScope.settings.token = userToken.trim()
            delete $rootScope.settings.provisionalToken
            $rootScope.zones = res.data
            $scope.status = {
              text: "Logged in OK"
              failed: false
              spinner: true
            }
            if $rootScope.settings.showIntro and $rootScope.settings.showIntro == true then $state.go 'intro' else $state.go 'app'
          else
            console.error error
            text = 'Unable to login at this time, please try again later.'
            $scope.status = {
              text
              failed: true
              spinner: false
            }
        .catch (error) ->
          console.error error
          text = 'Unable to login at this time, please try again later.'

          $scope.status = {
            text
            failed: true
            spinner: false
          }
        
        
])

