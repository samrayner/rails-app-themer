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
    $input = $(event.target)
    image = event.target.files[0]
    reader = new FileReader

    reader.onload = (file) =>
      data = file.target.result
      $input.siblings('.image-preview').attr('src', data)
      $b64Input = $input.siblings('.image-base64')
      $b64Input
        .attr('name', $b64Input.data('name'))
        .val(data)
      @updatePreview()

    reader.readAsDataURL(image)

  updatePreview: ->
    $head = @$preview.contents().find('head').first()
    $ajax = $.post '/theme/preview.css', @$form.serialize(), (data) =>
      $head.find('style#preview').remove()
      $head.append("<style id=\"preview\">#{data}</style>")

  init: ->
    @$colorPickers.blur @colorChanged
    @$fontPickers.change @fontChanged
    @$imagePickers.change @imageChanged

$ ->
  $form = $('#themer-form')
  if $form.length >= 1
    themer = new Themer($form)
    themer.init()
