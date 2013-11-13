class Menu
  constructor: (opts) ->
    @onSelectMap = opts.onSelectMap
    @onStartQuiz = opts.onStartQuiz

    @_createMenu()
    @hideScore()
    @_bindEvents()

  show: ->
    @lightbox.show()

  hide: ->
    @lightbox.hide()

  getSelectedMap: ->
    $('#map-type .pure-button-active').first().data('map')

  showScore: (numCorrect, questionCount, elapsedTime) ->
    $('#score').show().text(
      "#{numCorrect} out of #{questionCount} correct in #{@_formatTimeStr(elapsedTime)}"
    )

  hideScore: (numCorrect) ->
    $('#score').hide()

  _formatTimeStr: (milliseconds) ->
    seconds = (milliseconds / 1000).toFixed(2)  # round to 2 decimal places

    minutes = Math.floor(seconds / 60).toString()
    seconds = (seconds % 60).toFixed(2)

    secondsString = if seconds is '1.00' then '1 second' else "#{seconds} seconds"

    if minutes is '0'
      secondsString
    else
      minutesString = if minutes is '1' then '1 minute' else "#{minutes} minutes"
      "#{minutesString} and #{secondsString}"

  _createMenu: ->
    @lightbox = new LightBox('menu')

  _bindEvents: ->
    $('#start-quiz').click( $.proxy(@onStartQuiz, @) )

    $('#map-type .pure-button').click do =>
      $active = $('#map-type .pure-button-active')

      (e) =>
        $target = $(e.target)

        unless $target.hasClass('pure-button-active')
          $active.removeClass('pure-button-active')
          $active = $(e.target).addClass('pure-button-active')
          @onSelectMap( @getSelectedMap() )
