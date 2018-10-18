togglePseudoPersistence = (pseudoPersistenceData, username) ->
  persistence.togglePseudoPersistence(pseudoPersistenceData[username].hubData, pseudoPersistenceData[username].chartData, pseudoPersistenceData[username].hubServiceData)

isDemoUsername = (pseudoPersistenceData, username) -> username in _.keys(pseudoPersistenceData)

appStatus = {}

angular.module('hgAppPersistence', [])
  .run ($rootScope, $q, $http) ->
    Q.nextTick = (promise) ->
  #      promise = $q.when(promise())
      promise.$eval = promise
      $rootScope.$evalAsync(promise)
#  .provider('hgAppPersistence', ['pseudoPersistenceData', (pseudoPersistenceData) ->
#    @initialise = ->
#      persistence.initialiseAllSynchronousCacheConnections()
#        .then -> persistence.toggleHubConnectionCache()
#        .then -> persistence.provideAuthorizationRepository().getUsername()
#        .then (username) -> if isDemoUsername(pseudoPersistenceData, username) then togglePseudoPersistence(pseudoPersistenceData, username)
#
#    @$get = angular.noop
#
#    return this
#  ])
  .factory 'initialisePersistence', ['pseudoPersistenceData', (pseudoPersistenceData) -> ->
    persistence.initialiseAllSynchronousCacheConnections()
      .then -> persistence.toggleHubConnectionCache()
      .then -> persistence.provideAuthorizationRepository().getUsername().catch -> undefined
      .then (username) -> if isDemoUsername(pseudoPersistenceData, username) then togglePseudoPersistence(pseudoPersistenceData, username)
  ]
  .factory 'provideAuthorizationRepository', [ -> persistence.provideAuthorizationRepository ]
  .factory 'provideChartRepository', [ -> persistence.provideChartRepository ]
  .factory 'provideDeviceRepository', [ -> persistence.provideDeviceRepository ]
  .factory 'provideFeedbackRepository', [ -> persistence.provideFeedbackRepository ]
  .factory 'provideHubReleaseRepository', [ -> persistence.provideHubReleaseRepository ]
  .factory 'provideCheckinRepository', [ -> persistence.provideCheckinRepository ]
  .factory 'provideSystemRepository', [ -> persistence.provideSystemRepository ]
  .factory 'provideZoneRepository', [ -> persistence.provideZoneRepository ]
  .factory 'provideUserDetailsRepository', [ -> persistence.provideUserDetailsRepository ]
  .factory 'provideDeviceSettingsRepository', [ ->
    ->
      _.mapValues persistence.provideDeviceSettingsRepository(), (fn, key) ->
        if key in ['save', 'load', 'merge', 'set']
          Q.promised(fn)
        else
          fn
  ]
  .factory 'provideUserSettingsRepository', [ ->
    ->
      _.mapValues persistence.provideUserSettingsRepository(), (fn, key) ->
        if key in ['save', 'load', 'merge', 'set']
          Q.promised(fn)
        else
          fn
  ]
  .factory 'provideHubPersistenceProvider', [ -> persistence.provideHubPersistenceProvider ]
  .factory 'getHubConnectionSettings', [ -> persistence.provideHubConnectionSettingsRepository().load]
  .factory 'statusHandler', [ -> persistence.provideStatusHandler() ]
  .factory 'credentialsConverter', [ -> persistence.provideCredentialsConverter() ]
  .factory 'addHubConnection', [ -> persistence.addHubConnection ]
  .factory 'disableHubConnection', [ -> persistence.disableHubConnection ]
  .factory 'enableHubConnection', [ -> persistence.enableHubConnection ]
  .factory 'persistenceErrors', [ -> persistence.errors]
  .factory 'getHubTime', ['statusHandler', (statusHandler) ->
    ->
      offset = statusHandler.getUTCOffset('HubAll')
      if offset?
        moment().add(offset - moment().utcOffset(), 'minutes').toDate()
      else
        moment().toDate()
  ]
  .factory 'togglePseudoPersistence', ['pseudoPersistenceData', '$rootScope', (pseudoPersistenceData, $rootScope) ->
    (username) ->
      $rootScope.isDemo = true
      togglePseudoPersistence(pseudoPersistenceData, username)
  ]
  .factory 'cancelPseudoPersistence', [ -> persistence.cancelPseudoPersistence ]
  .factory 'isDemoUsername', ['pseudoPersistenceData', '$rootScope', (pseudoPersistenceData, $rootScope) ->
    (username) ->
      $rootScope.isDemo = false
      isDemoUsername(pseudoPersistenceData, username)
  ]
  .factory 'isUnregisteredSystem', [
    'provideAuthorizationRepository'
    'credentialsConverter'
    (provideAuthorizationRepository, credentialsConverter) ->
      return -> provideAuthorizationRepository().getUsername().then credentialsConverter.isSystemID
  ]
  .factory 'appStatus', [
    '$rootScope'
    'provideHubPersistenceProvider'
    'Poller'
    'getHubTime'
    ($rootScope, provideHubPersistenceProvider, Poller, getHubTime) ->
      testServices = (parent, testFunction) ->
        for service, statusObject of parent
          if statusObject.constructor.name == 'Service' and testFunction(statusObject)
            return true

      currentPersistenceStatus = {
        error: null
        lastOnline: moment(getHubTime())
        hasHadConnection: false
      }

      updateAppStatus = ->
        e = persistence.errors
        if currentPersistence = provideHubPersistenceProvider().getCurrentPersistenceName()
          currentPersistenceStatus = _.clone($rootScope.services[currentPersistence])
          currentPersistenceStatus.hasHadConnection = true

        currentPersistenceStatus.timeSinceHubLastContact = moment.duration(moment(getHubTime()).diff(moment(currentPersistenceStatus.lastOnline)))

        appStatus.status = switch
          when currentPersistenceStatus.error == e.InternalServiceError or currentPersistenceStatus.error == e.ServiceError
            {
              level: 2
              message: "Unable to contact hub. #{currentPersistence.error.message}"
            }
          when testServices(
            _.pick($rootScope.services, currentPersistence),
            (statusObject) -> statusObject.error == e.Unauthorized
          )
            {
              level: 2
              message: (new e.Unauthorized).message
            }
          when $rootScope.services.Cache.error == e.CacheQuotaExceeded
            {
              level: 2
              message: $rootScope.services.Cache.error.message
            }
          when not currentPersistence? and currentPersistenceStatus.hasHadConnection and currentPersistenceStatus.timeSinceHubLastContact?.asSeconds() > 30
            {
              level: 2
              message: "Unable to contact hub. Last contact was #{currentPersistenceStatus.timeSinceHubLastContact.humanize()} ago."
            }
          when not currentPersistence? and currentPersistenceStatus.timeSinceHubLastContact?.asSeconds() > 30
            {
              level: 2
              message: "Unable to contact hub."
            }
          when not currentPersistence?
            {
              level: 1
              message: "Obtaining hub connection."
            }
          when currentPersistenceStatus.timeSinceHubLastContact?.asSeconds() > 60
            {
              level: 1
              message: "It has been #{currentPersistenceStatus.timeSinceHubLastContact.humanize()} since the hub was last contacted. As a result the data you see maybe stale."
            }
          when testServices(
            {'HubTunnel': $rootScope.services.HubTunnel},
            (statusObject) -> statusObject.error == e.DeviceHasNoInternet
          )
            {
              level: 1
              message: (new e.DeviceHasNoInternet).message
            }
          when testServices(
            $rootScope.services.CloudAll,
            (statusObject) -> statusObject.error == e.InternalServiceError
          )
            {
              level: 1
              message: (new e.InternalServiceError).message
            }
          else
            {
              level: 0
              message: "Everything is functioning normally"
            }

        appStatus.status.currentHubPersistence = currentPersistence

      unless appStatus.status?
        poller = new Poller(2000)
        poller.onTick(updateAppStatus)
        poller.enable()

        $rootScope.$watch('services', ((newVal, oldVal) -> if newVal != oldVal then poller.pollNow()), true)

      return appStatus
  ]