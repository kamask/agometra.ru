import './main/lk-form.js'
import * as agolib from './main/ago-lib.js'
import * as wslib from './main/ws.js'
import { cart } from './main/cart.js'

window.ago.agolib = agolib
window.ago.wslib = wslib
window.ago.cart = cart

{ ev, el, els } = window.ago.ksk

docWidth = document.documentElement.clientWidth

#-----------------------NavTop-----------------------------

navTop = el '.nav-top'
ev window, 'scroll', ->
	if docWidth > 767
		if window.pageYOffset > 10
			if not navTop.classList.contains 'show'
				navTop.classList.add 'show'
		else
			if navTop.classList.contains 'show'
				navTop.classList.remove 'show'
	return

ev el('.burger'), 'click', ->
	navTop.classList.add 'show'
	return

ev el('.close-button', navTop), 'click', ->
	navTop.classList.remove 'show'
	return

ev document, 'click', (e) ->
	if docWidth < 768 and navTop.classList.contains 'show'
		if (not navTop.contains e.target) and (not el('.burger').contains e.target)
			navTop.classList.remove 'show'
	return

els('li a', navTop).forEach (i) ->
	ev i, 'click', (e) ->
		if docWidth < 768
			navTop.classList.remove 'show'
		return
	return