QuizBox = do ->
  $el = $('#quiz-box')

  init: ->
    $el.children('.skip-question').click -> QuizBox.onSkipQuestion()
    $el.children('.main-menu').click -> QuizBox.onMenuClick()

  askQuestion: (question) ->
    $el.children('h3').text(question)

  show: -> $el.show()

  hide: -> $el.hide()

  onMenuClick: -> throw new Error('Must be overwritten!')

  onSkipQuestion: -> throw new Error('Must be overwritten!')
