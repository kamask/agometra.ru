import { el, ev, findParent, log } from "/js/ksk-lib.js"
import { ws, ws_handlers } from '/js/ws.js'
import "/js/smooth-scroll.js"
import "/js/header.js"
import "/js/callback-form.js"
import "/js/ws.js"
import "/js/lk-form.js"

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
    if scroll > 710
      $nav.style.top = '0'
    else
      $nav.style.top = '-90px'
  return

do ->
  lkForm = await import('/js/lk-form.js')
  do lkForm.navTopInit
  return
  

ws_handlers.set 'data-init', (data) ->
  window.agodata = JSON.parse data
  log JSON.parse data
  return