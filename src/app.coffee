class window.App
  MAP_CONTAINER_ID = 'map-container'
  CORRECT_REGION_COLOR = '#2ECC71'
  INCORRECT_REGION_COLOR = '#E74C3C'

  constructor: ->
    QuizBox.init()
    QuizBox.hide()

    @menu = new Menu
      onSelectMap: $.proxy(@_renderMap, @)
      onStartQuiz: $.proxy(@_startQuiz, @)

    @_renderMap( @menu.getSelectedMap() )

  _renderMap: (mapName) ->
    @map = new Map(MAP_CONTAINER_ID, mapName)
    @map.render()

  _startQuiz: ->
    @menu.hide()
    @menu.hideScore()
    @map.clearSelectedRegions()

    @_startLocationQuiz()
    QuizBox.show()

  _startLocationQuiz: ->
    quiz = new LocationQuiz( @map.getRegions() )
    QuizBox.askQuestion( quiz.getQuestion() )
    QuizBox.onSkipQuestion = -> QuizBox.askQuestion( quiz.getQuestion() )

    @map.bindEvents
      regionLabelShow: (e, label, code) =>
        false unless @map.isRegionSelected(code)

      regionClick: (e, regionCode) =>
        region = @map.regionForCode(regionCode)

        if quiz.answerQuestion(region)
          @map.selectRegion(regionCode, CORRECT_REGION_COLOR)
        else
          askedRegion = @map.codeForRegion(quiz.currentRegion)
          @map.selectRegion(askedRegion , INCORRECT_REGION_COLOR)

        nextQuestion = quiz.getQuestion()
        if nextQuestion?
          QuizBox.askQuestion(nextQuestion)
        else
          @_endQuiz( quiz.status() )

  _endQuiz: (quizStatus) ->
    QuizBox.hide()
    @menu.show()
    @menu.showScore(quizStatus.numCorrect)
