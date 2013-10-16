class Map
  BACKGROUND_COLOR = '#2980B9'
  SELECTED_REGION_COLOR = '#2ECC71'

  @loadMap: do ->
    loaded = {}

    (mapName, callback) ->
      if loaded[mapName]
        callback()
      else
        $.get "vendor/jvectormap/maps/#{mapName}.js", (loadScript) ->
          eval( loadScript )
          loaded[mapName] = true
          callback()

  constructor: (container_id, mapName) ->
    @el = $('#' + container_id)
    @mapName = mapName

  render: ->
    Map.loadMap @mapName, => @_createMap()

  selectRegion: (regionCode) ->
    @map.setSelectedRegions(regionCode)

  bindEvents: (events) ->
    for event, callback of events
      @el.bind("#{event}.jvectormap", callback)

  _createMap: (opts) ->
    @el.empty()

    @el.vectorMap
      map: @mapName,
      backgroundColor: BACKGROUND_COLOR
      regionStyle:
        selected:
          fill: SELECTED_REGION_COLOR

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

    @_centerInWindow()
    @show()
    @_bindEvents()

  hide: ->
    LightBox.hideBackdrop()
    @el.hide()

  show: ->
    LightBox.showBackdrop()
    @el.show()

  _bindEvents: ->
    $(window).resize => @centerInWindow()

  _centerInWindow: ->
    $window = $(window)

    @el.css
      left: ($window.width() - @el.width()) / 2
      top: ($window.height() - @el.height()) / 2

class Menu
  constructor: (opts) ->
    @onSelectMap = opts.onSelectMap
    @onStartQuiz = opts.onStartQuiz

    @_createMenu()
    @_bindEvents()

  show: ->
    @lightbox.show()

  hide: ->
    @lightbox.hide()

  getSelectedMap: ->
    $('#map-type').find(':selected').val()

  _createMenu: ->
    @lightbox = new LightBox('menu')

  _bindEvents: ->
    $('#start-quiz').click(@onStartQuiz)

    $('#map-type').change =>
      @onSelectMap( @getSelectedMap() )

class LocationQuiz
  constructor: (map) ->
    @map = map
    @_bindEvents()

  _bindEvents: ->
    @map.bindEvents
      regionClick: $.proxy @_onRegionClick, @

  _onRegionClick: (e, regionCode) ->
    @map.selectRegion(regionCode)

class App
  MAP_CONTAINER_ID = 'map-container'

  constructor: ->
    menu = new Menu(
      onSelectMap: @renderMap
      onStartQuiz: =>
        menu.hide()
        new LocationQuiz(@map)
    )

    @renderMap( menu.getSelectedMap() )

  renderMap: (mapName) ->
    @map = new Map(MAP_CONTAINER_ID, mapName)
    @map.render()

$(document).ready -> new App
