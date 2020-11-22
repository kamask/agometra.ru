import { ev, el, log } from '/js/ksk-lib.js'
import { ws } from '/js/ws.js'

$form = el '#callback-form'
$input = el '#callback-form-input'
userInput = ''

ev $form, 'submit', (e) ->
  do e.preventDefault
  ws.send(JSON.stringify({ type: 'callback', data: userInput[...11] }))
  $input.value = ''
  userInput = ''
  return

ev $input, 'input', (e) ->
  do e.preventDefault

  if e.data == null
    userInput = userInput.substr 0, userInput.length - 1

  if /\d/.test e.data
    userInput += e.data

  unless userInput.length
    userInput = '8'

  inputOut = '+7 (___) ___-__-__'

  if userInput.length == 1 and not /[87]/.test userInput
    inputOut = "+7 (#{userInput}__) ___-__-__"


  for i in [0...userInput.length]
    if i == 0
      if /[87]/.test userInput[i]
        continue
      else
        userInput = '8' + userInput
        continue
    inputOut = inputOut.replace '_', userInput[i]
  
  $input.value = inputOut[...18]
  curPos = inputOut.indexOf '_'
  $input.setSelectionRange curPos, curPos
  return

ev $input, 'blur', (e) ->
  if userInput == '8'
    $input.value = ''
    userInput = ''
  return