class Map
  BACKGROUND_COLOR = '#2980B9'
  MAX_PLANE_COUNT = 20
  PLANE_SPEED = 1 / 10

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

  constructor: (containerID, mapName) ->
    @el = $('#' + containerID)
    @mapName = mapName

  render: ->
    Map.loadMap @mapName, =>
      @_createMap()
      @flightController = new FlightControl(@, MAX_PLANE_COUNT, PLANE_SPEED)
      @flightController.spawnFlights()

  destroy: ->
    @el.empty()
    @flightController.haltFlights()
    @flightController.destroyAll()

  clearSelectedRegions: ->
    @map.clearSelectedRegions()

  isRegionSelected: (regionCode) ->
    selected = @map.getSelectedRegions()
    $.inArray(regionCode, selected) isnt -1

  selectRegion: (regionCode, color) ->
    @map.regions[regionCode].element.style.selected.fill = color
    @map.setSelectedRegions(regionCode)

  codeForRegion: (regionName) ->
    for regionCode, data of @map.regions
      return regionCode if data.config.name == regionName

  regionForCode: (regionCode) ->
    @map.getRegionName(regionCode)

  getRegions: ->
    (data.config.name for regionCode, data of @map.regions)

  latLngToPoint: (lat, lng) ->
    @map.latLngToPoint(lat, lng)

  bindEvents: (events) ->
    @el.unbind()  # Remove any existing events

    for event, callback of events
      @el.bind("#{event}.jvectormap", callback)

  getRandomLatLng: ->
    @regionKeys ?= Object.keys(@map.regions)

    latLng = null
    randKey = @regionKeys[Math.floor(Math.random() * @regionKeys.length)]
    region = @map.regions[randKey]
    bBox = region.element.node.getBoundingClientRect()

    until latLng
      point =
        x: bBox.left + Math.random() * bBox.width
        y: bBox.top + Math.random() * bBox.height

      latLng = @map.pointToLatLng(point.x, point.y)

    latLng

  _createMap: ->
    @el.vectorMap
      map: @mapName,
      backgroundColor: BACKGROUND_COLOR

    @map = @el.vectorMap('get', 'mapObject')
