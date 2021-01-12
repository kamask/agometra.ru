is_touchable = `'ontouchstart' in document.documentElement`
logoimg = document.querySelector '#logo-svg img'
if document.documentElement.clientWidth > 1010
	logoimg.width = 400
	logoimg.height = 253
loadOtherScripts = ->
	document.documentElement.removeEventListener 'mousemove', loadOtherScripts
	if is_touchable then document.documentElement.removeEventListener 'touchstart', loadOtherScripts
	logoimg.removeAttribute 'width'
	logoimg.removeAttribute 'height'
	import('/js/index.js?ver=' + window.AGO_CACHE_VERSION)
	return

document.documentElement.addEventListener 'mousemove', loadOtherScripts
if is_touchable then document.documentElement.addEventListener 'touchstart', loadOtherScripts