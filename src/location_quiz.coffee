class LocationQuiz
  constructor: (regions) ->
    @regions = regions
    @regionsCount = regions.length
    @currentRegion = null
    @numCorrect = 0

  getQuestion: ->
    if @regions.length is 0
      null
    else
      randomIndex = Math.floor (Math.random() * @regions.length)
      @currentRegion = @regions[ randomIndex ]
      "Where is #{@currentRegion}?"

  answerQuestion: (answer) ->
    index = $.inArray(@currentRegion, @regions)
    @regions.splice(index, 1)

    correct = answer is @currentRegion
    @numCorrect += 1 if correct
    @currentRegion = null
    correct

  status: ->
    questionsLeft: @regions.length
    questionCount: @regionsCount
    numCorrect: @numCorrect

