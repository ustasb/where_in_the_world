class CapitalQuiz
  constructor: (regions, usStates = false) ->
    @regions = regions
    @regionsCount = regions.length
    @regionData = REGION_DATA[if usStates then 'usStates' else 'countries']
    @currentRegion = null
    @numCorrect = 0

  getQuestion: ->
    if @regions.length is 0
      null
    else
      randomIndex = Math.floor (Math.random() * @regions.length)
      @currentRegion = @regions[ randomIndex ]
      "What is the capital of #{@regionData[@currentRegion.toLowerCase()].prettyName}?"

  answerQuestion: (answer) ->
    index = $.inArray(@currentRegion, @regions)
    @regions.splice(index, 1)

    correct = @_validateGuess(answer, @regionData[@currentRegion.toLowerCase()].capital)
    @numCorrect += 1 if correct
    @currentRegion = null
    correct

  percentComplete: ->
    (1 - @regions.length / @regionsCount) * 100

  status: ->
    questionsLeft: @regions.length
    questionCount: @regionsCount
    numCorrect: @numCorrect

  # Credit: https://raw.github.com/acmeism/RosettaCodeData/master/Task/Levenshtein-distance/CoffeeScript/levenshtein-distance.coffee
  levenshteinDist: (str1, str2) ->
    m = str1.length
    n = str2.length
    d = []

    return n  unless m
    return m  unless n

    d[i] = [i] for i in [0..m]
    d[0][j] = j for j in [1..n]

    for i in [1..m]
      for j in [1..n]
        if str1[i-1] is str2[j-1]
          d[i][j] = d[i-1][j-1]
        else
          d[i][j] = Math.min(
            d[i-1][j]
            d[i][j-1]
            d[i-1][j-1]
          ) + 1

    d[m][n]

  # Tolerates misspellings
  _validateGuess: (guess, answer) ->
    guess = guess.toLowerCase()
    answer = answer.toLowerCase()

    # You have to get the first letter right!
    if guess[0] is answer[0]
      guess is answer or
      @levenshteinDist(guess, answer) <= Math.floor(answer.length / 3)
    else
      false
