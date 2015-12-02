class Themer
  constructor: (@$form) ->
    @$colorPickers = @$form.find('.color-pickers input')
    @$fontPickers = @$form.find('.font-pickers select')
    @$imagePickers = @$form.find('.image-pickers input')
    @$preview = $('iframe#preview')

  colorChanged: (event) =>
    @updatePreview()

  fontChanged: (event) =>
    $select = $(event.target)
    $select.css('font-family', $select.val())
    @updatePreview()

  imageChanged: (event) =>
    #use filereader to get base64
    @updatePreview()

  updatePreview: ->
    $head = @$preview.contents().find('head').first()
    $ajax = $.get '/theme/preview', @$form.serialize(), (data) ->
      $head.find('style#preview').remove()
      $head.append("<style id=\"preview\">#{data}</style>")

  init: ->
    @$colorPickers.on 'changeColor.colorpicker', @colorChanged
    @$fontPickers.change @fontChanged
    @$imagePickers.change @imageChanged

$ ->
  $form = $('#themer-form')
  if $form.length >= 1
    themer = new Themer($form)
    themer.init()
