import { el, els, ev } from '../ksk-lib.js'

$sizeA = el '#size-a'
$sizeB = el '#size-b'
$sizeC = el '#size-c'
$sizeD = el '#size-d'

$$sizes = [$sizeA, $sizeB, $sizeC, $sizeD]

current = []
currentLabel = '155г/м² - S'


$tbody = el '#exact-sizes tbody'
for $td, i in els '.S155', $tbody
  $td.classList.add 'active'
  $$sizes[i].textContent = $td.textContent
  current.push $td.textContent

$label = document.createElement 'span'
$label.className = 'label'
$sizeD.after $label

ev $tbody, 'mouseover', (e) ->
  if not e.target.classList.contains 'active'
    currentClass = e.target.className.split(' ')[0]
    if currentClass
      for $td, i in els '.'+currentClass, $tbody
        $td.classList.add 'hover'
        $$sizes[i].textContent = $td.textContent
      for $s in $$sizes
        $s.style.background = '#ffdbbc'
      $label.style.background = '#ffdbbc'
      setLabel currentClass
  return

ev $tbody, 'mouseout', (e) ->
  currentClass = e.target.className.split(' ')[0]
  if currentClass
    for $td in els '.'+currentClass, $tbody
      $td.classList.remove 'hover'
    for $s, i in $$sizes
      $s.style.background = ''
      $s.textContent = current[i]
    $label.style.background = ''
    $label.textContent = currentLabel
  return

ev $tbody, 'click', (e) ->
  if not e.target.classList.contains 'active'
    currentClass = e.target.className.split(' ')[0]
    if currentClass
      current = []
      for $td in els '.active', $tbody
        $td.classList.remove 'active'
      for $td, i in els '.'+currentClass, $tbody
        $td.className = currentClass + ' active'
        $$sizes[i].textContent = $td.textContent
        $$sizes[i].style.background = ''
        current.push $td.textContent
      $label.style.background = ''
      currentLabel = setLabel currentClass
  return

setLabel = (currentClass) ->
  [, size, density] = currentClass.match /^(\D+)(\d+)$/
  $label.textContent = density + 'г/м² - ' + size
  return $label.textContent

setLabel 'S155'

if document.documentElement.clientWidth < 600
  currentTable = 'show-155'
  $table = el '#exact-sizes table'
  $table.classList.add currentTable
  $controls = (el '#exact-sizes-controls')

  ev $controls, 'click', (e) ->
    if e.target.classList.contains 'active' then return
    el '.active', $controls
    .classList.remove 'active'
    e.target.classList.add 'active'
    $table.classList.remove currentTable
    currentTable = 'show-' + e.target.textContent.match(/^\d+/)[0]
    $table.classList.add currentTable
    return
