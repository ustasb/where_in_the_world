class WorldMapView

  constructor: (container_id) ->
    @el = $('#' + container_id)

    @initEvents()

  initEvents: ->
    $(window).resize => @createMap()

  createMap: ->
    map = @el.vectorMap
      map: 'world_mill_en'

    $window = $(window)
    map.setSize($window.width(), $window.height())

$(document).ready ->
  world = new WorldMapView('world-map')
  world.createMap()


