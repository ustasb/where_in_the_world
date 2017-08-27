ProgressBar = do ->
  $el = $('#progress-bar')

  show: -> $el.show()

  hide: -> $el.hide()

  reset: ->
    $el.css('width', 0)

  update: (percentComplete) ->
    $el.css('width', "#{percentComplete}%")
