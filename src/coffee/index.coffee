import { el, ev, newEl, findParent } from "./ksk-lib.js"
import { ws, ws_handlers } from './ws.js'
import "./smooth-scroll.js"

import "./index/header.js"
import "./index/callback-form.js"
import "./index/lk-form.js"
import "./index/shirts-options.js"
import "./index/shirts-slider.js"
import "./index/shirts-calc.js"
import "./index/gallery_agometra.js"
import { navTopInit } from "./index/lk-form.js"

export jsmLoad = (name) ->
	import('/js/' + name + '?ver=' + window.AGO_CACHE_VERSION)

ev document.documentElement, 'mousemove', ->
	jsmLoad 'ymap.js'
	if AGOHOST == 'agometra.ru'
		jsmLoad('analytics.js')
	return

$nav = document.createElement 'nav'
$nav.id = 'nav-top'

$closeButton = document.createElement 'span'
$closeButton.id = 'nav-top-close-button'
$closeButton.innerText = 'ᗕ'

$burgerButton = document.createElement 'span'
$burgerButton.id = 'burger-menu-button'
$burgerButton.innerText = '≑'

$logo = (el '#logo-svg').cloneNode true
$logo.id = 'logo-nav-svg'

$nav.append $closeButton
$nav.append $logo
$nav.append (el 'header>address').cloneNode true
$nav.append (el 'header>.lk-client').cloneNode true
$nav.append (el 'header>nav>ul').cloneNode true

$mainContainer = el '#main-container'
$mainContainer.prepend $nav
$nav.before $burgerButton

docWidth = document.documentElement.clientWidth
$body = el 'body'

ev $burgerButton, 'click', (e) ->
  if docWidth <= 850
    $nav.style.left = '0'
    setTimeout (->
      $body.classList.add 'block-scroll'
      return
      ), 300
  return

ev $nav, 'click', (e) ->
  if docWidth <= 850 and not findParent e.target, el '#nav-top .lk-client'
    if e.target in [$nav, $logo]
      return
    $body.classList.remove 'block-scroll'
    $nav.style.left = '-380px'
  return

ev document, 'scroll', (e) ->
  scroll = window.pageYOffset
  if docWidth > 850
    if scroll > 750
      $nav.style.top = '0'
    else
      $nav.style.top = '-90px'
  return

do navTopInit
