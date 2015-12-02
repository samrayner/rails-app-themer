$ ->
  $pickers = $('input.pick-color')

  $pickers.each ->
    $input = $(this)
    $input.parent().find(".swatch").click =>
      $input.focus()

  $pickers.colorpicker().on 'changeColor.colorpicker', (event) ->
    $input = $(this)
    hex = event.color.toHex()
    $input.val(hex)
    $swatch = $input.parent().find(".swatch")
    if $swatch.length >= 1
      $swatch.css('background-color', hex)
