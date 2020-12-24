import { log, el, els, ev, makeObserveble, nodeObserver, newEl, animation } from '/js/ksk-lib.js'
import { handleInputTel } from '/js/ago-lib.js'
import { current } from '/js/shirts-options.js'
import { store } from '/js/store.js'
import { cart } from '/js/cart.js'
import { ws, ws_handlers } from '/js/ws.js'

state = makeObserveble {}
$controls = el '#calc-controls'
$total = el '#calc-total'
$actions = el '#calc-actions'
$buttonAddToCart = el '.button-white', $actions
$buttonOneClick = el '.button-green', $actions

currentCalc =
  count: 0
  state: {}

handleInputTel el 'input', $actions

if document.documentElement.clientWidth > 1200
  el '#shirts>div:first-child'
  .append $total
  el '#shirts>div:first-child'
  .append $actions

renderTotal = ->
  shirts = store.dataFromServer.shirts.filter (s) -> s.density_id is current.density and s.color_id is current.color
  currentCalc.articles = (a.article for a in shirts)
  currentCalc.state = {}
  count = currentCalc.articles.reduce ((a, i) ->
    currentCalc.state[i] = state[i] ? 0
    a + (state[i] ? 0)
    ), 0
  currentCalc.count = count
  countAll = cart.count + count
  priceCount = if countAll < 100 then 'price' else if 99 < countAll < 1000 then 'price_100' else 'price_1000'
  price = store.dataFromServer.density.find((i) -> i.id == current.density)[priceCount]
  priceOut = price.toLocaleString 'ru', {
    style: 'currency'
    currency: 'RUB'
  }
  total = (count * price).toLocaleString 'ru', {
    style: 'currency'
    currency: 'RUB'
  }
  $total.innerHTML = "#{count}шт. х #{priceOut}<br>Итого: #{total}"
  if document.documentElement.clientWidth > 1200 then $total.append $buttonAddToCart
  if count <= 0
    $total.classList.remove 'show'
    $actions.classList.remove 'show'
    setTimeout (->
      $total.style.display = 'none'
      $actions.style.display = 'none'
      return
      ), 300
  else
    $total.style.display = 'block'
    $actions.style.display = 'flex'
    setTimeout (->
      $total.classList.add 'show'
      $actions.classList.add 'show'
      return
      ), 0
  return

current.addObserver (target, prop, val) ->
  if prop is 'color'
    color = val
    density = target.density
    sizes = store.dataFromServer.sizes
    shirts = store.dataFromServer.shirts.filter (s) -> s.density_id is density and s.color_id is color

    $controls.innerHTML = ''

    shirts.sort (a, b) -> a.id - b.id

    shirts.forEach (s) ->
      $p = document.createElement 'div'
      $controls.append $p

      size = sizes.find (i) -> i.id is s.size_id
      $p.innerHTML = "<span>#{size.euro}:</span>"

      $input = document.createElement 'input'
      $p.append $input
      $input.value = state[s.article] ? '0'
      
      showing = false
      validCount = ->
        if state[s.article]
          if state[s.article] > s.count
            state[s.article] = s.count
            $input.value = s.count
            if not showing
              showing = true
              $alert = document.createElement 'div'
              $alert.innerHTML = "<span>✖</span>На складе в данный момент <br> #{s.count} футболок размера #{size.euro}.<br>Если нужно больше, то Вы можете добавить футболки другой плотности или цвета этого же размера."
              $alert.className = 'alert'
              $input.before $alert
              setTimeout (->
                $alert.classList.add 'show'
                return
                ), 100
              
              hide = ->
                $alert.classList.remove 'show'
                setTimeout (->
                  do $alert.remove
                  showing = false
                  return
                  ), 300
                return

              setTimeout hide, 8000
              ev document, 'click', (e) ->
                if $p.contains e.target or e.target is $p then return
                do hide
                return
              ev (el 'span', $alert), 'click', hide
            
        if state[s.article] < 0
          state[s.article] = 0
          $input.value = 0
        return

      ev $input, 'input', (e) ->
        if e.data == null
          data = parseInt @value
          state[s.article] = if isNaN data then 0 else data
        else
          if (/^\d$/.test e.data) then state[s.article] = parseInt @value
          else @value = state[s.article] ? ''
          if /^0\d+/.test @value then @value = parseInt @value
          do validCount
        return

      ev $input, 'click', (e) ->
        if @value is '0' then @value = ''
        return

      ev $input, 'blur', (e) ->
        if @value is '' then @value = '0'
        return

      [1, 10, 100].forEach (i) ->
          $div = document.createElement 'div'

          [i, -i].forEach (v) ->
            $button = document.createElement 'div'
            $div.append $button
            if `'ontouchstart' in document.documentElement`
              $button.className = 'touchable'
            $button.innerText = if v > 0 then '+' + v else v
            ev $button, 'click', (e) ->
              if (/-/.test @innerText) and not state[s.article] then return
              state[s.article] = if state[s.article] then state[s.article] + v else v
              $input.value = state[s.article]
              do validCount
              return
            return

          $p.append $div
        return
      return
    # state['1550048'] = 10
    do renderTotal
  return

state.addObserver (target, prop, val, old) ->
  do renderTotal
  return

ev $buttonAddToCart, 'click', ->
  calcState = []
  for a in currentCalc.articles
    if state[a] > 0
      calcState.push {shirt_id: (store.dataFromServer.shirts.find (s) -> s.article is a).id, count: state[a]}
      delete state[a]
  cart.add calcState
  do renderTotal
  for $i in els 'input', $controls
    $i.value = 0
  return

alertShow = false
alertActions = (text, error = false, delayHide = 5000) ->
  if alertShow then return
  alertShow = true
  $alert = newEl 'div'
  $alert.setAttribute 'id', 'alert-actions'
  if error then $alert.classList.add 'error'
  $alert.innerHTML = "<span>✖</span>" + text
  (el '#shirts>div:last-child').prepend $alert
  setTimeout (-> $alert.classList.add 'show'), 100
  if document.documentElement.clientWidth < 600
    setTimeout (-> $alert.scrollIntoView false), 500
    
  hide = -> $alert.classList.remove 'show'
  ev $alert, 'transitionend', (e) ->
    if not ($alert.classList.contains 'show') and e.propertyName is 'opacity'
      do $alert.remove
      alertShow = false
    return
  setTimeout hide, delayHide
  ev (el 'span', $alert), 'click', hide
  ev document, 'click', (e) ->
    if e.target isnt $alert and not ($alert.contains e.target) then do hide
  return

ev $actions, 'submit', (e) ->
  do e.preventDefault
  if currentCalc.count < 20
    alertActions 'Минимальное количество заказа не может быть менее 20шт.', true
    return

  checkCart = true #------------**********************--------------*********---------
  $input = document.forms['one-click'].elements.tel
  tel = ($input.value.replace /[\+_\(\)\s-]/g, '').replace /^7/, '8'
  if /^8\d{10}$/.test tel
    data =
      density: current.density
      color: current.color
      shirts: {}
      tel: tel
    for a in currentCalc.articles
      if state[a] > 0
        data.shirts[(store.dataFromServer.shirts.find (s) -> s.article is a).id] = state[a]
        delete state[a]
    for $i in els 'input', $controls
      $i.value = 0

    do renderTotal
    ws.send JSON.stringify { type: 'one_click', data }
    $input.value = ''
  else
    alertActions 'Для покупки в один клик необходимо указать корректный номер телефона.', true
  return

ws_handlers.set 'one-click-answer', (data) ->
  alertActions "Ваш заказ принят!<br><br>Номер заказа - #{data.order_id}.<br>Сумма заказа - #{data.price}<br><br>Мы сейчас свяжемся с Вами по указанному номеру для уточнения и подтвеждения заказа!", null, 1000*60*10
  return