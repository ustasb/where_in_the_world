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

  _showQuizView: (showInput) ->
    MainMenu.hide()
    QuizBox.show(showInput)
    ProgressBar.show()

  _startQuiz: ->
    @map.clearSelectedRegions()
    ProgressBar.reset()
    MainMenu.hideScore()

    switch MainMenu.getSelectedQuiz()
      when 'location'
        @_showQuizView()
        @_initLocationQuiz()
      when 'capital'
        @_showQuizView(true)
        @_initCapitalQuiz()

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

  _initCapitalQuiz: ->
    mapName = MainMenu.getSelectedMap()
    quiz = new CapitalQuiz(@map.getRegions(), mapName is 'us_mill_en')

    QuizBox.askQuestion( quiz.getQuestion() )
    QuizBox.onSkipQuestion = -> QuizBox.askQuestion( quiz.getQuestion() )
    QuizBox.onInputEnter = ($input) =>
      guess = $input.val()
      currentRegion = quiz.currentRegion
      regionCode = @map.codeForRegion(currentRegion)

      if quiz.answerQuestion(guess)
        #QuizBox.flashMessage('correct!')
        @map.selectRegion(regionCode, CORRECT_REGION_COLOR)
      else
        #QuizBox.flashMessage(quiz.dataForRegion(currentRegion).capital)
        @map.selectRegion(regionCode, INCORRECT_REGION_COLOR)

      ProgressBar.update(quiz.percentComplete())

      if nextQuestion = quiz.getQuestion()
        QuizBox.askQuestion(nextQuestion)
      else
        status = quiz.status()
        @_endQuiz(status.numCorrect, status.questionCount)

    @map.bindEvents
      regionLabelShow: (e, label, code) =>
        if @map.isRegionSelected(code)
          region = label.text()
          label.text("#{region} | #{quiz.dataForRegion(region).capital}")
