
angular.module('geniusChromeExtension', [
  'ionic'
  'ngStorage'
  'hgAppPersistence'
  'loginController'
  'introController'
  'listController'
  'hgMiscToolsService'
  'hgAppPersistence'
]).run(($rootScope, $state,  $ionicLoading, provideZoneRepository, provideAuthorizationRepository, hgMiscTools) ->

  setLocalStorageSettings = ->
    initialSettings = {
      'showIntro': true,
      'overrideFor': 1,
      'dark': false,
      'apiVersion': 1
    }

    if !hgMiscTools.getLocalStorageSettings() then hgMiscTools.setLocalStorageSettings(initialSettings)
    $rootScope.settings = JSON.parse(hgMiscTools.getLocalStorageSettings())

  setLocalStorageSettings()

  $rootScope.$on '$stateChangeStart', (event, toState, toParams) ->
    if !$rootScope.settings.token
      if toState.data.requireLogin
        $state.go 'login'

  if $rootScope.settings.token?
    hgMiscTools.getZones($rootScope.settings.token).then (res) ->
      $rootScope.zones = res.data
  else
    $state.go 'login'

  $rootScope.$watchCollection 'settings', (newVal, oldVal) ->
    if newVal != oldVal
      hgMiscTools.setLocalStorageSettings($rootScope.settings)

  $rootScope.saveOverrideTime = (time) ->
    $rootScope.settings.overrideFor = time

  $rootScope.generatePercentage = (input) ->
    min = 1
    max = 23
    percentage = ((input - min) * 100) / (max - min)
    return percentage.toFixed(2)

  $rootScope.mapRanges = (input) ->
    in_min = 1
    in_max = 23
    out_min = 23
    out_max = 0
    return (input - in_min) * (out_max - (-out_min)) / (in_max - in_min) + (-out_min)

  $rootScope.swapTheme = () ->
    $rootScope.settings.dark = !$rootScope.settings.dark

  $rootScope.overrideFor = {
    time: if $rootScope.settings.overrideFor then $rootScope.settings.overrideFor else 1
  }

).config [
  '$httpProvider',
  '$stateProvider',
  '$urlRouterProvider',
  '$ionicConfigProvider',
  '$compileProvider',
  ($httpProvider,$stateProvider, $urlRouterProvider, $ionicConfigProvider, $compileProvider) ->

    $compileProvider.imgSrcSanitizationWhitelist(/^\s*(https?|ftp|mailto|chrome-extension):/)
    
    $ionicConfigProvider.views.forwardCache(false)
    $ionicConfigProvider.navBar.alignTitle('left')
    $ionicConfigProvider.scrolling.jsScrolling(true)
  
    $stateProvider
    .state('login', {
      cache: false
      url: '/login'
      data: {
        requireLogin: false
      }
      views: {
        '@': { templateUrl: './sections/login/login.tpl.html', controller: 'loginCtrl' }
      }
    }).state('intro', {
      cache: false
      url: '/intro'
      data: {
        requireLogin: true
      }
      views: {
        '@': { templateUrl: './sections/intro/intro.tpl.html', controller: 'introCtrl' }
      }
    }).state('app', {
      cache: false
      url: '/app'
      data: {
        requireLogin: true
      }
      views: {
        '@': { templateUrl: './sections/list/list.tpl.html', controller: 'listCtrl' }
      }
    })
    

    $urlRouterProvider.otherwise 'app'
]
