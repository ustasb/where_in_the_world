class WorldMapView
  BACKGROUND_COLOR = '#2980B9'

  constructor: (container_id) ->
    @el = $('#' + container_id)

  createMap: ->
    @el.vectorMap
      map: 'world_mill_en'
      hoverColor: '3498DB'
      backgroundColor: BACKGROUND_COLOR

class LightBox

  constructor: (container_id) ->
    @el = $('#' + container_id)

    @resize()
    @initEvents()

  initEvents: ->
    $(window).resize => @resize()

  resize: ->
    $window = $(window)

    @el.css
      left: ($window.width() - @el.width()) / 2
      top: ($window.height() - @el.height()) / 2

  hide: -> @el.hide()
  show: -> @el.show()

$(document).ready ->
  world = new WorldMapView('world-map')
  world.createMap()

  #lightbox = new LightBox('lightBox')
  #lightbox.








