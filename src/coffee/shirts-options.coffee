import { log, el, ev, makeObserveble, els } from '/js/ksk-lib.js'
import { store } from '/js/store.js'

export current = makeObserveble {
  density: null
  color: null
}

store.addObserver (target, property, value) ->
  if property == 'dataFromServer'
    value.addObserver (target, property, value) ->
      if property is 'density' then do renderDensityOptions
      return
    do renderDensityOptions
  return

$options = el '#shirts .options'
$densityPrice = el '.density-price', $options

renderDensityOptions = ->
  { density } = store.dataFromServer

  $densityList = document.createElement 'ul'
  for d in density
    $densityItem = document.createElement 'li'
    $densityItem.densityId = d.id
    $densityItem.innerText = d.code
    $densityList.append $densityItem

  
  $densityPrice.before $densityList

  densityObserver = new MutationObserver (mutationRecords) ->
    for mr, i in mutationRecords
      if mr.type == 'attributes' and mr.target.tagName == 'LI'
        if mr.target.classList.contains('active')
          current.density = mr.target.densityId
          d = store.dataFromServer.density.find (i) -> i.id == current.density
          prices = [d.price, d.price_100, d.price_1000, d.price_1000 - 5]
          for $li, i in els 'li', $densityPrice
            el 'span:last-child', $li
            .innerText = if i == 3 then "#{prices[i]}₽ и ниже" else "#{prices[i]}₽"
          do renderColorOptions
    return

  densityObserver.observe $densityList, {
    subtree: true
    attributes: true
    attributeOldValue: true
    attributeFilter: ['class']
  }

  for $li, i in els 'li', $densityList
    if i == 0 then $li.classList.add 'active'
      
    ev $li, 'click', (e) ->
      if not @classList.contains 'active'
        el '.active', $densityList
        .classList.remove 'active'
        @classList.add 'active'
      return

  
  return

$colorsOptions = el '.color', $options

renderColorOptions = ->
  t = el 'ul', $colorsOptions
  if t then do t.remove

  shirts = store.dataFromServer.shirts.filter (i) -> i.density_id is current.density
  colorsIds = new Set (i.color_id for i in shirts)
  colors = [(store.dataFromServer.colors.find (c) -> c.id is i) for i in Array.from colorsIds]
  colors = colors[0]

  $colorsList = document.createElement 'ul'
  for c in colors
    $li = document.createElement 'li'
    $li.colorId = c.id
    $li.style.backgroundColor = '#' + c.hex
    $colorsList.append $li

  $colorsOptions.append $colorsList

  colorsObserver = new MutationObserver (mutationRecords) ->
    for mr in mutationRecords
      if mr.type == 'attributes' and mr.target.tagName == 'LI'
        if mr.target.classList.contains('active')
          current.color = mr.target.colorId
          do renderCount
    return

  colorsObserver.observe $colorsList, {
    subtree: true
    attributes: true
    attributeOldValue: true
    attributeFilter: ['class']
  }

  for $li, i in els 'li', $colorsList
    if i == 0 then $li.classList.add 'active'

    ev $li, 'click', (e) ->
      if not @classList.contains 'active'
        el '.active', $colorsList
        .classList.remove 'active'
        @classList.add 'active'
      return

renderCount = ->
  shirts = store.dataFromServer.shirts.filter (i) -> i.density_id is current.density and i.color_id is current.color
  expected = store.dataFromServer.expected
  log new Date expected[0].date
  return