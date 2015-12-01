$ ->
  $('input.pick-color').colorpicker().on 'changeColor.colorpicker', (event) ->
    $(this).val(event.color.toHex())
