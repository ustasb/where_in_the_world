QuizBox = do ->
  FLASH_MESSAGE_TIME = 1700
  ENTER_BUTTON_CODE = 13
  VERT_MARGIN = 10

  $el = $('#quiz-box')
  $input = $el.find('.quiz-input')
  $flashBox = $el.find('.flash-box')

  init: ->
    @isTop = true
    $el.css(top: VERT_MARGIN)

    @bindEvents()

  bindEvents: ->
    $el.children('.skip-question').click -> QuizBox.onSkipQuestion()
    $el.children('.main-menu').click -> QuizBox.onMenuClick()
    $el.children('.fa-arrow-down').click -> QuizBox.toggleVertPosition()
    $input.keypress (e) ->
      if e.which is ENTER_BUTTON_CODE
        QuizBox.onInputEnter($input)
        $input.val('')
        e.preventDefault()

  toggleVertPosition: ->
    offset = $(window).height() - ($el.outerHeight() + VERT_MARGIN)

    # Don't animate if the screen's too small.
    return if offset <= 0

    $el.children('.fa-arrow-down, .fa-arrow-up')
       .toggleClass('fa-arrow-up fa-arrow-down')

    if @isTop
      $el.animate
        top: offset
        'swing',
        -> $el.css(top: '', bottom: VERT_MARGIN)
    else
      $el.animate
        bottom: offset
        'swing',
        -> $el.css(bottom: '', top: VERT_MARGIN)

    @isTop = !@isTop

  askQuestion: (question) ->
    $el.children('h3').text(question)

  flashMessage: do ->
    timer = null

    (msg, msgType = 'error') ->
      clearTimeout(timer)

      color = switch msgType
        when 'error' then '#E74C3C' # red
        when 'warning' then '#F39C12' # orange
        else '#2C3E50' # dark blue

      if @isTop
        $flashBox.css(top: '', bottom: '-40px')
      else
        $flashBox.css(top: '-40px', bottom: '')

      $flashBox.css('color', color)
        .text(msg)
        .fadeIn ->
          timer = setTimeout (-> $flashBox.fadeOut()), FLASH_MESSAGE_TIME

  show: (showInput = false) ->
    $el.show()
    if showInput then $input.show().focus() else $input.hide()

  hide: -> $el.hide()

  onMenuClick: -> throw new Error('Must be overwritten!')

  onSkipQuestion: -> throw new Error('Must be overwritten!')

  onInputEnter: -> throw new Error('Must be overwritten!')
