{ el, ev, log } = window.ago.ksk
import "./index/header.js"
import "./index/callback-form.js"
import "./index/shirts-options.js"
import "./index/shirts-slider.js"
import "./index/shirts-calc.js"
import "./index/exact-sizes.js"
import "./index/gallery-agometra.js"

getPosYFromWindowBottom = (elem) ->
	document.documentElement.clientHeight - elem.getBoundingClientRect().top

showWhenVisible = (elem, offset = 100) ->
	if getPosYFromWindowBottom(elem) > 100 then elem.classList.add 'show'
	else
		ev window, 'scroll', ->
			if (not elem.classList.contains 'show') and (getPosYFromWindowBottom(elem) > offset)
				elem.classList.add 'show'
			return
	return

shirtsBlock = el '#shirts'
advantagesBlock = el '#advantages'
sizesBlock = el '#exact-sizes'
galleryBlock = el '#gallery-agometra'
contactsBlock = el '#contacts'

for elem in [shirtsBlock, advantagesBlock, sizesBlock, galleryBlock, contactsBlock]
	showWhenVisible elem

modulesLoaded = new Promise (resolve) ->
	loading = ->
		if `'agolib' in window.ago`
			do resolve
		else setTimeout loading, 100
	do loading


modulesLoaded.then ->
	{ lkFormHandler  } = window.ago.agolib

	lkFormLink = el 'header .lk-client .link'
	lkForm = el 'header .lk-client form'
	lkFormHandler lkForm, lkFormLink, 'header'

	import('/js/ymap.js?ver=' + window.ago.AGO_CACHE_VERSION)
	return