import { log, el, els } from '/js/ksk-lib.js'
import { store } from '/js/store.js'


$options = el '#shirts .options'
$densityOptions = el '.density', $options


store.addObserver (target, property, value) ->
  if property == 'dataFromServer'
    value.addObserver (target, property, value) ->
      log value
      return
  { shirts, density, colors, sizes, photos_shirts: photos} = value

  $densityList = document.createElement 'ul'
  for d in density
    $densityItem = document.createElement 'li' 
    $densityItem.densityId = d.id
    $densityItem.innerText = d.code
    $densityList.append $densityItem
  
  $densityOptions.append $densityList

  densityObserver = new MutationObserver (mutationRecords) ->
    log mutationRecords
    return

  densityObserver.observe $densityList, {
    childeList: true
    attributes: true
    attributeFilter: ['class']
  }

  setTimeout (->
    (els 'li', $densityList)[0].classList.add 'active'
    return
    ), 0
    
  return

options = 
  current: null