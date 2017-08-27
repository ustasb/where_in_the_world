class LightBox
  $backdrop = $('<div class="light-box-bg"></div>')

  @showBackdrop: ->
    $(document.body).append($backdrop)

  @hideBackdrop: ->
    $backdrop.remove()

  constructor: (containerID) ->
    @el = $('#' + containerID)

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
    $(window).resize => @_centerInWindow()

  _centerInWindow: ->
    $window = $(window)

    verticalOffset = 50  # Looks better a bit higher up...

    @el.css
      left: ($window.width() - @el.width()) / 2
      top: ($window.height() - @el.height()) / 2 - verticalOffset

