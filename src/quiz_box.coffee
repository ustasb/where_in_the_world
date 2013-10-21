QuizBox = do ->
  $el = $('#quiz-box')

  init: ->
    $el.children('.skip-question').click -> QuizBox.onSkipQuestion()
    #$el.clildren('.menu').click ->

  askQuestion: (question) ->
    $el.children('h3').text(question)

  show: -> $el.show()

  hide: -> $el.hide()

  onSkipQuestion: -> throw new Error('Must be overwritten!')
