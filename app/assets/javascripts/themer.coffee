class Themer
  constructor: (@$form) ->
    @$colorPickers = @$form.find('.color-pickers input')
    @$fontPickers = @$form.find('.font-pickers select')
    @$imagePickers = @$form.find('.image-pickers input')
    @$viewport = $('iframe.browser-viewport')
    @iframe = @$viewport.get(0)
    @$locationInput = $('.browser-location')

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
      $input.siblings('.image-preview').css('background-image', "url(#{data})")
      console.log(data)
      $b64Input = $input.siblings('.image-base64')
      $b64Input
        .attr('name', $b64Input.data('name'))
        .val(data)
      @updatePreview()

    reader.readAsDataURL(image)

  backClicked: (event) =>
    event.preventDefault()
    @iframe.contentWindow.history.back()

  forwardClicked: (event) =>
    event.preventDefault()
    @iframe.contentWindow.history.forward()

  locationGo: (event) =>
    event.preventDefault();
    @iframe.contentWindow.location.href = @$locationInput.val()

  previewLoaded: =>
    @$locationInput.val(@iframe.contentWindow.location.href)
    @updatePreview()

  updatePreview: ->
    console.log('applied')
    $head = @$viewport.contents().find('head').first()
    $ajax = $.post '/theme/preview.css', @$form.serialize(), (data) =>
      $head.find('style#preview').remove()
      $head.append("<style id=\"preview\">#{data}</style>")

  init: ->
    @$colorPickers.blur @colorChanged
    @$fontPickers.change @fontChanged
    @$imagePickers.change @imageChanged
    @$viewport.load @previewLoaded
    $('.browser-back').click @backClicked
    $('.browser-forward').click @forwardClicked
    $('.browser-form').submit @locationGo

$ ->
  $form = $('#themer-form')
  if $form.length >= 1
    themer = new Themer($form)
    themer.init()
