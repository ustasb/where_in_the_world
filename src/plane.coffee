class Plane
  PLANE_IMGS = ['imgs/airplane_orange.svg', 'imgs/airplane_blue.svg']
  PLANE_SIZE = 20

  @getRandomPlaneImg: ->
    PLANE_IMGS[Math.floor(Math.random() * PLANE_IMGS.length)]

  constructor: (@map, start, @end, @speed) ->
    @pos = start

    @flightDist = Math.sqrt(
      Math.pow(end.lng - start.lng, 2) +
      Math.pow(end.lat - start.lat, 2)
    )

    @el = $("<img class='plane' src='#{Plane.getRandomPlaneImg()}' />")
    @map.el.append(@el)

  destroy: ->
    @el.remove()

  hasLanded: ->
    dx = @end.lng - @pos.lng
    dy = @end.lat - @pos.lat
    distLeft = Math.sqrt(Math.pow(dx, 2) + Math.pow(dy, 2))
    distLeft <= @speed

  update: ->
    dx = @end.lng - @pos.lng
    dy = @end.lat - @pos.lat
    @ang = Math.atan2(dy, dx)

    @pos.lng += Math.cos(@ang) * @speed
    @pos.lat += Math.sin(@ang) * @speed

    distLeft = Math.sqrt(Math.pow(dx, 2) + Math.pow(dy, 2))
    @amplitude = Math.sin((distLeft / @flightDist) * Math.PI)

  render: ->
    size = @amplitude * (PLANE_SIZE * 2)
    size = if size > PLANE_SIZE then PLANE_SIZE else size

    # Make the plane curve into its destination.

    curveHeight = @amplitude * 3
    curvedLng = @pos.lng - curveHeight * Math.sin(@ang)
    curvedLat = @pos.lat + curveHeight * Math.cos(@ang)

    pos = @map.latLngToPoint(curvedLat, curvedLng)
    facingAng = Math.atan2(curvedLat - @oldLat || @pos.lat, curvedLng - @oldLng || @pos.lng)

    @oldLng = curvedLng
    @oldLat = curvedLat

    if pos
      @el.show().css
        left: pos.x
        top: pos.y
        width: size
        height: size
        '-webkit-transform': "rotate(#{-facingAng}rad)"
    else
      @el.hide()
