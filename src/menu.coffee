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
    $('#map-type .pure-button-active').first().data('map')

  showScore: (numCorrect) ->
    $('#score').show().children('span').text(numCorrect)

  hideScore: (numCorrect) ->
    $('#score').hide()

  _createMenu: ->
    @lightbox = new LightBox('menu')

  _bindEvents: ->
    $('#start-quiz').click( $.proxy(@onStartQuiz, @) )

    $('#map-type .pure-button').click do =>
      $active = $('#map-type .pure-button-active')
      (e) =>
        $active.removeClass('pure-button-active')
        $active = $(e.target).addClass('pure-button-active')
        @onSelectMap( @getSelectedMap() )
