class Menu
  constructor: (opts) ->
    @onSelectMap = opts.onSelectMap
    @onStartQuiz = opts.onStartQuiz

    @_createMenu()
    @hideScore()
    @_bindEvents()

  show: ->
    @lightbox.show()

  hide: ->
    @lightbox.hide()

  getSelectedMap: ->
    $('#map-type').find(':selected').val()

  showScore: (numCorrect) ->
    $('#score').show().children('span').text(numCorrect)

  hideScore: (numCorrect) ->
    $('#score').hide()

  _createMenu: ->
    @lightbox = new LightBox('menu')

  _bindEvents: ->
    $('#start-quiz').click( $.proxy(@onStartQuiz, @) )

    $('#map-type').change =>
      @onSelectMap( @getSelectedMap() )

