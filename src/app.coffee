class window.App
  MAP_CONTAINER_ID = 'map-container'
  CORRECT_REGION_COLOR = '#2ECC71'
  INCORRECT_REGION_COLOR = '#E74C3C'

  constructor: ->
    ProgressBar.hide()

    QuizBox.init()
    QuizBox.hide()
    QuizBox.onMenuClick = =>
      @_endQuiz()
      @_renderMap( @menu.getSelectedMap() )

    @menu = new Menu
      onSelectMap: $.proxy(@_renderMap, @)
      onStartQuiz: $.proxy(@_startQuiz, @)

    @_renderMap( @menu.getSelectedMap() )

  _renderMap: (mapName) ->
    @map.destroy() if @map
    @map = new Map(MAP_CONTAINER_ID, mapName)
    @map.render()

  _startQuiz: ->
    @menu.hide()
    @menu.hideScore()
    @map.clearSelectedRegions()

    @_startLocationQuiz()
    QuizBox.show()
    ProgressBar.show()

  _startLocationQuiz: ->
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
          @_endQuiz()

  _endQuiz: ->
    QuizBox.hide()

    ProgressBar.reset()
    ProgressBar.hide()

    @menu.show()
