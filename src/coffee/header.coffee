import { el, ev, els } from '/js/ksk-lib.js'

$logo = el '#logoSVG'
$img = el '#header-image'
offset = 50
frX = document.documentElement.clientWidth / offset
frY = 800 / offset

ev document, 'mousemove', (e) ->
  if e.pageY < 700 and document.documentElement.clientWidth > 1200
    $logo.style.left = ((-Math.ceil e.pageX / frX) + 70) + 'px'
    $logo.style.top = ((-Math.ceil e.pageY / frY) + 60) + 'px'
    $img.style.right = ((-Math.ceil e.pageX / frX) + 50) + 'px'
    $img.style.top = ((Math.ceil e.pageY / frY) + 240) + 'px'