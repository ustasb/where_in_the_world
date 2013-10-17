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

