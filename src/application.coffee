class Map
  BACKGROUND_COLOR = '#2980B9'
  SELECTED_REGION_COLOR = '#2ECC71'

  constructor: (container_id, mapName) ->
    @el = $('#' + container_id)
    @mapName = mapName

  draw: ->
    @loadMap => @createMap()

  loadMap: (callback) ->
    $.get "vendor/jvectormap/maps/#{@mapName}.js", (data) ->
      eval(data)
      callback()

  createMap: ->
    @el.vectorMap
      map: @mapName,
      backgroundColor: BACKGROUND_COLOR
      regionStyle:
        selected:
          fill: SELECTED_REGION_COLOR
      onRegionClick: (e, regionCode) =>
        @map.setSelectedRegions(regionCode)

    @map = @el.vectorMap('get', 'mapObject')

class LightBox
  backdrop = $('<div class="light-box-bg"></div>')

  @showBackdrop: do ->
    added = false
    ->
      if added
        backdrop.show()
      else
        $(document.body).append(backdrop)
        added = true

  @hideBackdrop: ->
    backdrop.hide()

  constructor: (container_id) ->
    @el = $('#' + container_id)

    @centerInWindow()
    @show()
    @bindEvents()

  bindEvents: ->
    $(window).resize => @centerInWindow()

  centerInWindow: ->
    $window = $(window)

    @el.css
      left: ($window.width() - @el.width()) / 2
      top: ($window.height() - @el.height()) / 2

  hide: ->
    LightBox.hideBackdrop()
    @el.hide()

  show: ->
    LightBox.showBackdrop()
    @el.show()

$(document).ready ->
  world = new Map('world-map', 'world_mill_en')
  world.draw()

  lightBox = new LightBox('menu')
  lightBox.hide()
