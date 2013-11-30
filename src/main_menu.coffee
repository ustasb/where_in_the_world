MainMenu = do ->
  $el = $('#main-menu')
  $score = $el.children('#score')

  init: (opts) ->
    @onSelectMap = opts.onSelectMap
    @onSelectQuiz = opts.onSelectQuiz
    @onStartQuiz = opts.onStartQuiz

    @_createMenu()
    @_bindEvents()
    @hideScore()

  show: ->
    @lightbox.show()

  hide: ->
    @lightbox.hide()

  getSelectedMap: ->
    $el.find('#map-type .pure-button-active').first().data('map')

  getSelectedQuiz: ->
    $el.find('#quiz-type .pure-button-active').first().data('quiz')

  showScore: (numCorrect, questionCount, elapsedTime) ->
    $score.show().text(
      "#{numCorrect} out of #{questionCount} correct in #{@_formatTimeStr(elapsedTime)}"
    )

  hideScore: (numCorrect) ->
    $score.hide()

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
    @lightbox = new LightBox('main-menu')

  _bindEvents: ->
    $el.find('#start-quiz').click => @onStartQuiz()

    $el.find('.pure-control-group .pure-button').click (e) ->
      $target = $(e.target)
      $current = $target.siblings('.pure-button-active')

      unless $target.hasClass('pure-button-active')
        $current.removeClass('pure-button-active')
        $current = $target.addClass('pure-button-active')
        $current.trigger('menu_button_click')

    $el.find('#map-type').on 'menu_button_click', =>
      @onSelectMap( @getSelectedMap() )
