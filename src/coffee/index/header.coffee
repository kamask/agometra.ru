{ el, ev, els } = window.ago.ksk
$logo = el '#logo-svg'
$img = el 'header .bonus'
offset = 50
frX = document.documentElement.clientWidth / offset
frY = 800 / offset

ev document, 'mousemove', (e) ->
  if e.pageY < 700 and document.documentElement.clientWidth > 1200
    $logo.style.left = ((-Math.ceil e.pageX / frX) + 0) + 'px'
    $logo.style.top = ((-Math.ceil e.pageY / frY) + 0) + 'px'
    $img.style.right = ((-Math.ceil e.pageX / frX) + 0) + 'px'
    $img.style.top = ((Math.ceil e.pageY / frY) - 50) + 'px'

ev el('.bonus'), 'click', ->
	do el('#shirts-options > ul > li:nth-child(3)').click
	window.location.href = '#shirts'
	return