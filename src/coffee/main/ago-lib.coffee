import { ws, ws_handlers } from './ws.js'

{ ksk, ev, log } = window.ago.ksk

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
  $el.classList.add 'alert'

  if error
    $helper.classList.add 'error'

  hideHelper = ->
    $helper.classList.remove 'show'
    setTimeout (->
      do $helper.remove
      $el.classList.remove 'alert'
      return
      ), 3300

  setTimeout (->
    $helper.classList.add 'show'
    setTimeout (->
      do hideHelper
      return
      ), 3000
    return
    ), 0

  ev $helper, 'click', hideHelper

export lkFormHandler = (lkForm, lkFormLink, formName) ->
  handleInputTel lkForm.elements.login

  ev lkFormLink, 'click', ->
    if lkForm.classList.contains 'show'
      lkForm.elements.login.value = ''
    lkForm.classList.toggle 'show'
    return

  ev document, 'click', (e) ->
    if lkForm.classList.contains('show') and  not lkForm.parentNode.contains(e.target)
      lkForm.classList.remove 'show'
      lkForm.elements.login.value = ''
    return

  ev lkForm, 'submit', (e) ->
    do e.preventDefault
    if lkForm.classList.contains 'alert' then return

    data = (@elements.login.value.replace /[\+_\(\)\s-]/g, '').replace /^7/, '8'

    if /^8\d{10}$/.test data
      ws.send JSON.stringify { type: 'login', data: { form: formName, number: data } }
      @elements.login.value = ''
    else
      divHelperInsert @, 'lk-client-helper', null, if data == '8' then 'Введите номер!' else 'Некорректный номер!'
    return

  ws_handlers.set 'login-' + formName, (data) ->
    error = if data == 'access' then null else 'Нет такого в базе'
    if error
      divHelperInsert lkForm, 'lk-client-helper', null, error
    else
      log data
    return