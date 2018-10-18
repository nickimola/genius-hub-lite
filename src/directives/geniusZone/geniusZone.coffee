angular.module('geniusZoneDirective', ['hgAppPersistence', 'hgMiscToolsService'])
.directive 'geniusZone', [
    '$rootScope'
    'provideZoneRepository',
    'hgMiscTools'
    ($rootScope, provideZoneRepository, hgMiscTools) ->
        linkFunction = (scope, element, attrs, parent) ->
            scope.tempToBoost = {
                temp: if scope.zone.temperature? then parseInt(scope.zone.temperature) else parseInt(scope.zone.setpoint)
            }

            scope.boostZone = (zone, tempToBoost) ->
                params = {
                    duration: if $rootScope.settings.overrideFor then (parseInt($rootScope.settings.overrideFor * 60 * 60)) else 3600
                    setpoint: parseInt(tempToBoost.temp)
                }
                hgMiscTools.overrideZone(zone.id, params)

            scope.sanitizeTempClass = (temp) ->
                return parseInt(temp)

            getMinMaxValues = () ->
                zoneType = hgMiscTools.mapZoneType(scope.zone.type)
                switch zoneType
                    when 1
                        minMaxValues = {
                            min: "4"
                            max: "28"
                        }
                        scope.zone['minMaxValues'] = minMaxValues
                    when 2
                        minMaxValues = {
                            min: "4"
                            max: "28"
                        }
                        scope.zone['minMaxValues'] = minMaxValues
                    when 3
                        minMaxValues = {
                            min: "4"
                            max: "28"
                        }
                        scope.zone['minMaxValues'] = minMaxValues
                    when 4
                        minMaxValues = {
                            min: "4"
                            max: "28"
                        }
                        scope.zone['minMaxValues'] = minMaxValues
                    when 5
                        minMaxValues = {
                            min: "30"
                            max: "80"
                        }
                        scope.zone['minMaxValues'] = minMaxValues
                    when 6
                        minMaxValues = {
                            min: "4"
                            max: "28"
                        }
                        scope.zone['minMaxValues'] = minMaxValues
                        
            
            getMinMaxValues()
                

        {
            restrict: 'E'
            replace: true,
            templateUrl: './directives/geniusZone/geniusZone.tpl.html'
            scope: {
                zone: '=dataset'
            }
            link: linkFunction
        }
]