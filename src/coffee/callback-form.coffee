import { ev, el, log } from '/js/ksk-lib.js'
import { handleInputTel, divHelperInsert } from '/js/ago-lib.js'
import { ws, ws_handlers } from '/js/ws.js'

$form = el '#callback-form'
$input = el '#callback-form-input'

handleInputTel $input

ev $form, 'submit', (e) ->
  do e.preventDefault
  data = ($input.value.replace /[\+_\(\)\s-]/g, '').replace /^7/, '8'
  if /^8\d{10}$/.test data
    ws.send JSON.stringify { type: 'callback', data }
    $input.value = ''
  else
    divHelperInsert $form, 'callback-helper', null, if data == '8' then 'Введите номер!' else 'Некорректный номер!'
  return

ws_handlers.set 'callback', (data) ->
  divHelperInsert $form, 'callback-helper', 'Уже набираем!'
  return