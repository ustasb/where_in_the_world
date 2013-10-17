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

    @el.css
      left: ($window.width() - @el.width()) / 2
      top: ($window.height() - @el.height()) / 2

