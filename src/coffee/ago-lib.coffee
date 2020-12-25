import { ev, log } from '/js/ksk-lib.js'

export handleInputTel = ($input) ->
  userInput = ''

  ev $input, 'click', (e) ->
    do e.preventDefault
    if $input.value == ''
      userInput = '8'
      $input.value = '+7 (___) ___-__-__'
      $input.setSelectionRange 4, 4
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

    if userInput.length > 11
      userInput = userInput[...11]

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
  return

export divHelperInsert = ($el, className, textAccess, error = null) ->
  $helper = document.createElement 'div'
  $helper.className = className
  $helper.innerText = if not error then textAccess else error
  $el.append $helper

  if error
    $helper.classList.add 'error'

  hideHelper = ->
    $helper.classList.remove 'show'
    setTimeout (->
      do $helper.remove
      return
      ), 3300

  setTimeout (->
    $helper.classList.add 'show'
    setTimeout (->
      # do hideHelper
      return
      ), 3000
    return
    ), 0

  ev $helper, 'click', hideHelper
