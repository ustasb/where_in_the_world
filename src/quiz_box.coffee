QuizBox = do ->
  VERT_MARGIN = 10
  $el = $('#quiz-box')

  init: ->
    @isTop = true
    $el.css(top: VERT_MARGIN)

    @bindEvents()

  bindEvents: ->
    $el.children('.skip-question').click -> QuizBox.onSkipQuestion()
    $el.children('.main-menu').click -> QuizBox.onMenuClick()
    $el.children('.fa-arrow-down').click -> QuizBox.toggleVertPosition()

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

  show: -> $el.show()

  hide: -> $el.hide()

  onMenuClick: -> throw new Error('Must be overwritten!')

  onSkipQuestion: -> throw new Error('Must be overwritten!')
