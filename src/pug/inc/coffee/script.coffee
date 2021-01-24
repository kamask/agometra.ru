import * as ksk from './lib/ksk-lib.js'

if not window.AGO404
	{ el, els, ev, newEl, makeObserveble, log } = ksk
	store = window.ago = makeObserveble { ksk }

	store.AGOHOST = '{{host}}'
	store.AGO_CACHE_VERSION = '{{cache_version}}'
	store.AGO_DYNAMIC_MODULE_FIX = '1'

	starters = store.starters = []

	is_touchable = `'ontouchstart' in document.documentElement`

	loadOtherScripts = ->
		document.documentElement.removeEventListener 'mousemove', loadOtherScripts
		if is_touchable then document.documentElement.removeEventListener 'touchstart', loadOtherScripts
		for i in starters
			do i
		return

	ev document.documentElement, 'mousemove', loadOtherScripts
	if is_touchable then ev document.documentElement, 'touchstart', loadOtherScripts

	starters.push ->
		cssTag = document.createElement 'link'
		cssTag.rel = 'stylesheet'
		cssTag.href = '/css/style.css'
		document.getElementsByTagName('head')[0].append cssTag
		import('/js/lazy-loading.js?module-fix=' + store.AGO_DYNAMIC_MODULE_FIX)
		import('/js/smooth-scroll.js?module-fix=' + store.AGO_DYNAMIC_MODULE_FIX)
		import('/js/main.js?ver=' + store.AGO_CACHE_VERSION)
		if store.AGOHOST == 'agometra.ru'
			import('/js/analytics.js?module-fix=' + store.AGO_DYNAMIC_MODULE_FIX)
		return


	docWidth = document.documentElement.clientWidth
	logoNavTop = el '.nav-top>svg'
	if docWidth < 1071
		logoNavTop .setAttribute('width', 100)
		logoNavTop .setAttribute('height', 58)
	el 'footer'
	.prepend logoNavTop.cloneNode true