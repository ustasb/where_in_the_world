class Map
  BACKGROUND_COLOR = '#2980B9'
  HIGHLIGHT_SIZE = 170
  MAX_PLANE_COUNT = 10
  PLANE_SPEED = 1.5

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

    @_updatePlaneSpeed = $.proxy (-> @planeSpeed = @_getPlaneSpeed()), @
    $(window).resize(@_updatePlaneSpeed)

  render: ->
    Map.loadMap @mapName, =>
      @_createMap()

      @_updatePlaneSpeed()
      @flightControl = new FlightControl(@, MAX_PLANE_COUNT)
      @flightControl.spawnFlights()

  destroy: ->
    @el.empty()
    @flightControl.haltFlights()
    @flightControl.destroyAll()
    $(window).unbind('resize', @_updatePlaneSpeed)

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
    maxAttemptsPerRegion = 5
    latLng = null

    loop
      bBox = @_getRegion().element.node.getBoundingClientRect()

      for i in [0...maxAttemptsPerRegion] by 1
        point =
          x: bBox.left + Math.random() * bBox.width
          y: bBox.top + Math.random() * bBox.height

        latLng = @map.pointToLatLng(point.x, point.y)
        return latLng if latLng

  highlightRegion: (regionCode) ->
    bBox = @map.regions[regionCode].element.node.getBoundingClientRect()
    $highlight = $('<div class="highlight"><i class="fa fa-circle-o"></i></div>')
    centerLeft = bBox.left + (bBox.width / 2)
    centerTop = bBox.top + (bBox.height / 2)

    $highlight.css
      'font-size': "#{HIGHLIGHT_SIZE}px"
      left: centerLeft - (HIGHLIGHT_SIZE / 2)
      top: centerTop - (HIGHLIGHT_SIZE / 2)
      width: HIGHLIGHT_SIZE
      height: HIGHLIGHT_SIZE
    .appendTo(@el)
    .animate
      'font-size': 0
      left: centerLeft
      top: centerTop
      width: 0
      height: 0,
      opacity: 0
      700,
      -> $highlight.remove()

  # Returns a random region unless an index is specified.
  _getRegion: (index) ->
    @regionKeys ?= Object.keys(@map.regions)
    index ?= Math.floor(Math.random() * @regionKeys.length)
    @map.regions[ @regionKeys[index] ]

  _createMap: ->
    @el.vectorMap
      map: @mapName,
      backgroundColor: BACKGROUND_COLOR

    @map = @el.vectorMap('get', 'mapObject')

    window.m =  @map

  # Keeps the plane speed consistent between differently scaled maps.
  _getPlaneSpeed: ->
    # Container immediately surrounding the map.
    bBox = @_getRegion(1).element.node.getBoundingClientRect()

    # Diagonal distance in pixels.
    distPixels = Math.sqrt(Math.pow(bBox.width, 2) + Math.pow(bBox.height, 2))

    # Diagonal distance in latLng.
    topLeft = @map.pointToLatLng(bBox.left, bBox.top)
    bottomRight = @map.pointToLatLng(bBox.left + bBox.width, bBox.top + bBox.height)
    distLatLng = Math.sqrt(Math.pow(bottomRight.lng - topLeft.lng, 2) + Math.pow(bottomRight.lat - topLeft.lat, 2))

    PLANE_SPEED / (distPixels / distLatLng)
