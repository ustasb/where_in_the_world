window.requestAnimationFrame = window.requestAnimationFrame ||
                               window.mozRequestAnimationFrame ||
                               window.webkitRequestAnimationFrame ||
                               window.msRequestAnimationFrame

class FlightControl
  MIN_FLIGHT_DIST = 10

  constructor: (@map, @maxPlaneCount, @planeSpeed) ->
    @planes = []
    @halted = false

  destroyAll: ->
    @halted = true
    plane.destroy() for plane in @planes by 1

  spawnFlights: ->
    @halted = false

    animate = =>
      unless @halted
        @_spawnPlanes()
        @_animatePlanes()
        requestAnimationFrame -> animate()

    animate()

  _createFlight: ->
    dist = 0
    start = @map.getRandomLatLng()

    until dist >= MIN_FLIGHT_DIST
      end = @map.getRandomLatLng()
      dist = Math.sqrt(
        Math.pow(end.lng - start.lng, 2) +
        Math.pow(end.lat - start.lat, 2)
      )

    start: start, end: end

  _spawnPlanes: ->
    until @planes.length >= @maxPlaneCount
      flight = @_createFlight()
      @planes.push(new Plane(@map, flight.start, flight.end, @planeSpeed))

  _animatePlanes: ->
    i = @planes.length

    while i--
      plane = @planes[i]

      if plane.hasLanded()
        plane.destroy()
        @planes.splice(i, 1)
      else
        plane.update()
        plane.render()
