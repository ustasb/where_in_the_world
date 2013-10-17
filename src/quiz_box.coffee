QuizBox = do ->
  $el = $('#quiz-box')

  init: ->
    $el.children('.skip-question').click -> QuizBox.onSkipQuestion()

  askQuestion: (question) ->
    $el.children('h3').text(question)

  show: -> $el.show()

  hide: -> $el.hide()

  onSkipQuestion: -> throw new Error('Must be overwritten!')
