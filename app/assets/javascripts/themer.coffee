class Themer
  constructor: ->
    @colorPickers = $('.color-pickers input')
    @fontPickers = $('.font-pickers select')

  colorChanged: (event) ->
    @updatePreview()

  fontChanged: (event) ->
    $select = $(this)
    $select.css('font-family', $select.val())
    @updatePreview()

  updatePreview: ->
    #update

  init: ->
    @colorPickers.blur @colorChanged
    @fontPickers.change @fontChanged

$ ->
  if $('body.themer').length >= 1
    themer = new Themer()
    themer.init()
