class window.App
  MAP_CONTAINER_ID = 'map-container'
  CORRECT_REGION_COLOR = '#2ECC71'
  INCORRECT_REGION_COLOR = '#E74C3C'

  constructor: ->
    QuizBox.init()
    QuizBox.onMenuClick = => @_showMainMenuView()

    MainMenu.init
      onSelectMap: (mapName) => @_renderMap(mapName)
      onStartQuiz: => @_startQuiz()

    @_showMainMenuView()
    @_renderMap( MainMenu.getSelectedMap() )

  _showMainMenuView: ->
    ProgressBar.hide()
    QuizBox.hide()
    MainMenu.show()

  _showQuizView: ->
    MainMenu.hide()
    QuizBox.show()
    ProgressBar.show()

  _startQuiz: ->
    @map.clearSelectedRegions()
    ProgressBar.reset()
    MainMenu.hideScore()

    @_initLocationQuiz()
    @_showQuizView()

    @quizStartTime = (new Date).getTime()

  _endQuiz: (numCorrect, questionCount) ->
    elapsedTime = (new Date).getTime() - @quizStartTime

    @_showMainMenuView()
    MainMenu.showScore(numCorrect, questionCount, elapsedTime)

  _renderMap: (mapName) ->
    @map.destroy() if @map
    @map = new Map(MAP_CONTAINER_ID, mapName)
    @map.render()

  _initLocationQuiz: ->
    quiz = new LocationQuiz( @map.getRegions() )
    QuizBox.askQuestion( quiz.getQuestion() )
    QuizBox.onSkipQuestion = -> QuizBox.askQuestion( quiz.getQuestion() )

    @map.bindEvents
      regionLabelShow: (e, label, code) =>
        @map.isRegionSelected(code)

      regionClick: (e, regionCode) =>
        clickedRegion = @map.regionForCode(regionCode)
        askedRegion = quiz.currentRegion

        if quiz.answerQuestion(clickedRegion)
          @map.selectRegion(regionCode, CORRECT_REGION_COLOR)
        else
          @map.selectRegion(@map.codeForRegion(askedRegion), INCORRECT_REGION_COLOR)

        ProgressBar.update( quiz.percentComplete() )

        if nextQuestion = quiz.getQuestion()
          QuizBox.askQuestion(nextQuestion)
        else
          status = quiz.status()
          @_endQuiz(status.numCorrect, status.questionCount)
