class Map
  BACKGROUND_COLOR = '#2980B9'

  @loadMap: do ->
    loaded = {}

    (mapName, callback) ->
      if loaded[mapName]
        callback()
      else
        $.get "vendor/jvectormap/maps/#{mapName}.js", (loadScript) ->
          eval( loadScript )
          loaded[mapName] = true
          callback()

  constructor: (containerID, mapName) ->
    @el = $('#' + containerID)
    @mapName = mapName

  render: ->
    Map.loadMap @mapName, => @_createMap()

  isRegionSelected: (regionCode) ->
    selected = @map.getSelectedRegions()
    $.inArray(regionCode, selected) isnt -1

  selectRegion: (regionCode, color) ->
    @map.regions[regionCode].element.style.selected.fill = color
    @map.setSelectedRegions(regionCode)

  codeForRegion: (regionName) ->
    for regionCode, data of @map.regions
      return regionCode if data.config.name == regionName

  regionForCode: (regionCode) ->
    @map.getRegionName(regionCode)

  getRegions: ->
    (data.config.name for regionCode, data of @map.regions)

  bindEvents: (events) ->
    for event, callback of events
      @el.bind("#{event}.jvectormap", callback)

  _createMap: ->
    @el.empty()

    @el.vectorMap
      map: @mapName,
      backgroundColor: BACKGROUND_COLOR

    @map = @el.vectorMap('get', 'mapObject')

class LightBox
  backdrop = $('<div class="light-box-bg"></div>')

  @showBackdrop: do ->
    added = false
    ->
      if added
        backdrop.show()
      else
        $(document.body).append(backdrop)
        added = true

  @hideBackdrop: ->
    backdrop.hide()

  constructor: (containerID) ->
    @el = $('#' + containerID)

    @_centerInWindow()
    @show()
    @_bindEvents()

  hide: ->
    LightBox.hideBackdrop()
    @el.hide()

  show: ->
    LightBox.showBackdrop()
    @el.show()

  _bindEvents: ->
    $(window).resize => @_centerInWindow()

  _centerInWindow: ->
    $window = $(window)

    @el.css
      left: ($window.width() - @el.width()) / 2
      top: ($window.height() - @el.height()) / 2

class Menu
  constructor: (opts) ->
    @onSelectMap = opts.onSelectMap
    @onStartQuiz = opts.onStartQuiz

    @_createMenu()
    @_bindEvents()

  show: ->
    @lightbox.show()

  hide: ->
    @lightbox.hide()

  getSelectedMap: ->
    $('#map-type').find(':selected').val()

  _createMenu: ->
    @lightbox = new LightBox('menu')

  _bindEvents: ->
    $('#start-quiz').click( $.proxy(@onStartQuiz, @) )

    $('#map-type').change =>
      @onSelectMap( @getSelectedMap() )

class QuestionBox
  instance = null

  constructor: (opts) ->
    return instance if instance?

    @el = $('#' + opts.containerID)

    @onSkipQuestion = opts.onSkipQuestion
    @onSubmitAnswer = opts.onSubmitAnswer

    @_bindEvents()

    instance = @

  prompt: (question, showInput = false) ->
    @el.children('h3').text(question)

    input = @el.children('.answer')
    if showInput then input.show() else input.hide()

  _bindEvents: ->
    @el.children('.skip-question').click( @onSkipQuestion )
    @el.children('.submit-answer').click( @onSubmitAnswer )

class LocationQuiz
  constructor: (regions) ->
    @regions = regions
    @regionsCount = regions.length
    @currentRegion = null
    @numCorrect = 0

  newQuestion: ->
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
    correct

  status: ->
    questionsLeft: @regions.length
    questionCount: @regionsCount
    numCorrect: @numCorrect

class App
  MAP_CONTAINER_ID = 'map-container'

  CORRECT_REGION_COLOR = '#2ECC71'
  INCORRECT_REGION_COLOR = '#E74C3C'

  constructor: ->
    @menu = new Menu
      onSelectMap: $.proxy(@_renderMap, @)
      onStartQuiz: $.proxy(@_startQuiz, @)

    @_renderMap( @menu.getSelectedMap() )

  _renderMap: (mapName) ->
    @map = new Map(MAP_CONTAINER_ID, mapName)
    @map.render()

  _startQuiz: (quizType) ->
    @menu.hide()

    quiz = new LocationQuiz( @map.getRegions() )

    questionBox = new QuestionBox
      containerID: 'question-box'
      onSkipQuestion: ->
        questionBox.prompt( quiz.newQuestion() )

    @map.bindEvents
      regionLabelShow: (e, label, code) =>
        false unless @map.isRegionSelected(code)

      regionClick: (e, regionCode) =>
        region = @map.regionForCode(regionCode)

        if quiz.answerQuestion(region)
          @map.selectRegion(regionCode, CORRECT_REGION_COLOR)
        else
          @map.selectRegion( @map.codeForRegion(quiz.currentRegion) , INCORRECT_REGION_COLOR)

        questionBox.prompt( quiz.newQuestion() )

    questionBox.prompt( quiz.newQuestion() )

$(document).ready -> new App
