angular.module('roomSubmenu', [])
.directive 'hgRoomSubmenu', [
  () ->
    linkFunction = (scope, el, attr)->
      submenuitem = angular.element('.hg-submenu-item')

      if attr.icon?
        scope.icon = attr.icon
      else
        scope.icon = 'ion-more'

      angular.forEach submenuitem, (item) ->
        ngClick = item.attributes['ng-click']
        if ngClick and ngClick.value != ''
          angular.element(item).bind 'click', ->
            scope.showToggleMenu = false

      scope.showToggleMenu = false

      scope.changeIcon = ->
        scope.showToggleMenu = !scope.showToggleMenu

      scope.hideRoomSubmenu = ->
        scope.showToggleMenu = !scope.showToggleMenu

    {
    restrict: 'E'
    replace: false
    transclude: true
    templateUrl: './directives/hgRoomSubmenu/hgRoomSubmenu.tpl.html'
    link: linkFunction
    }
]
