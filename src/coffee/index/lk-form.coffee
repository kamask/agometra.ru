import { el, ev, findParent, log } from "../ksk-lib.js"
import { handleInputTel, divHelperInsert } from '../ago-lib.js'
import { ws, ws_handlers } from '../ws.js'

handleLkForm = (formSelector, buttonSelector) ->
  $lkNavButton = el buttonSelector
  $form = el formSelector
  $input = el 'input', $form
  $burgerMenuButton = el '#burger-menu-button'

  form = formSelector.split(' ')[0]

  ev $lkNavButton, 'click', (e) ->
    if $form.classList.contains 'show'
      setTimeout (->
        $form.style.display = 'none'
        $input.value = ''
        return
        ), 250
    else
      $form.style.display = 'flex'

    setTimeout (->
      $form.classList.toggle 'show'
      return
      ), 0
    return

  ev document, 'click', (e) ->
    isClickedForm = Boolean((findParent e.target, $form) or
    (e.target == $form) or
    (findParent e.target, $burgerMenuButton) or
    (findParent e.target, $lkNavButton))

    if not isClickedForm
      $form.classList.remove 'show'
      setTimeout (->
        $form.style.display = 'none'
        $input.value = ''
        return
        ), 250
    return

  ev $form, 'submit', (e) ->
    do e.preventDefault
    data = ($input.value.replace /[\+_\(\)\s-]/g, '').replace /^7/, '8'
    if /^8\d{10}$/.test data
      ws.send JSON.stringify { type: 'login', data: { form, number: data } }
      $input.value = ''
    else
      divHelperInsert $form, 'lk-client-helper', null, if data == '8' then 'Введите номер!' else 'Некорректный номер!'
    return

  ws_handlers.set 'login-' + form, (data) ->
    error = if data == 'access' then null else 'Нет такого в базе'
    if error
      divHelperInsert $form, 'lk-client-helper', null, error
    else
      log data
    return

  handleInputTel $input


handleLkForm 'header .lk-client>form', 'header .lk-client>div:first-child'

export navTopInit = ->
  handleLkForm '#nav-top .lk-client>form', '#nav-top .lk-client>div:first-child'
  return
