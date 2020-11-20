import { animation, findParent, el, log } from '/js/ksk-lib.js'

slow = false

scrollHandler = (e) ->
  do e.preventDefault

  if e.deltaY == 1
    slow = true

  animateHandler = (val) ->
    window.scrollTo 0, val

  rAFID = animation window.pageYOffset, (if slow then e.deltaY * 40 else e.deltaY),
    300, animateHandler, 'quad-out', rAFID

document.documentElement.addEventListener 'wheel', scrollHandler, { passive: false }