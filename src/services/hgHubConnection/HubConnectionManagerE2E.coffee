angular.module('HubConnectionServicesE2E', ['CredentialManagerFactory',
                                                  'HubProxyStaticFactory',
                                                  'ConnectionMockFactory',
                                                  'HubServiceAdapterFactoryMock',
                                                  'ServerAdapterMockFactory'])
.service 'HubConnectionManager', [
  '$rootScope',
  '$http',
  '$q',
  '$log',
  'CredentialManager',
  'HubProxyStatic',
  'ServerAdapterMock'
  'ConnectionMock',
  'HubServiceAdapterMock'
  ($rootScope, $http, $q, $log, CredentialManager, HubProxyStatic, ServerAdapterMock, ConnectionMock, HubServiceAdapterMock) ->
    x = new class HubConnectionManager
      __name__ = 'HubConnectionManagerE2E'

      STATE =
        NONE: 0
        OK: 1
        TESTING: 2
        BAD_AUTH: 3
        NO_CONNECTION: 4

      constructor: ->
        @STATE = _.extend(STATE, _.invert(STATE))
        @credentials = new CredentialManager()
        @serverAdapter = new ServerAdapterMock(@credentials)
        #TODO: check that this one is correct
        #@hubServiceAdapter = new HubServiceAdapterMock(@credentials)
        @connectionMock = new ConnectionMock(@credentials)
        @connectionMock.enable()

        @proxies = [
          @mockHubProxy = new HubProxyStatic(@connectionMock)
        ]
        @load()
        for p in @proxies
          p.load()

        $rootScope.connectionManager = @
        @activeHubProxy = @mockHubProxy

        @chooseBestProxy()


      getProxies: ->
        return @proxies

      getActiveHubProxy: ->
        $q.when @activeHubProxy

      load: ->
        null

      save: ->
        null

      reset: ->
        null

      setDefault: ->
        null

      chooseBestProxy: ->
        $q.when(@activeHubProxy)

      chooseBestProxy: ->
        $q.when(@mockHubProxy)

      setState: (state) ->
        if STATE.hasOwnProperty(state)
          @state = state
        else
          $log.warn __name__ + " trying to set an invalid state:", state

      getState: ->
        return parseInt(@state)

      getStateName: ->
        return @STATE[@state]

#      getHubDate: ->
#        hubDate = new Date()
#        return hubDate

      getHubDate: ->
        fakeDate = new Date()
        year = fakeDate.getFullYear()
        month = fakeDate.getMonth() + 1
        if month < 10
          month = '0' + month
        day = fakeDate.getDate()
        fullDate = year + '-' + month + '-' + day
        hubDate = new Date(fullDate + 'T09:00:00')
#        hubDate = new Date('2017-02-21T09:00:00')
        return hubDate

    return x
]
