class WorldMap
  BACKGROUND_COLOR = '#2980B9'
  SELECTED_REGION_COLOR = '#2ECC71'

  constructor: (container_id) ->
    @el = $('#' + container_id)

  createMap: ->
    @el.vectorMap
      map: 'world_mill_en'
      backgroundColor: BACKGROUND_COLOR
      regionStyle:
        selected:
          fill: SELECTED_REGION_COLOR
      onRegionClick: (e, regionCode) =>
        @map.setSelectedRegions(regionCode)

    @map = @el.vectorMap('get', 'mapObject')

class Quiz

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


  world = new WorldMap('world-map')
  world.createMap()

  lightBox = new LightBox('menu')
