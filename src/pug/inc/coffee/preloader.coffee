preloaderContainer = document.getElementById('preloaderContainer')
windowLoadHandler = ->
	window.removeEventListener 'load', windowLoadHandler
	preloaderContainer.style.opacity = '0'
	preloaderContainer.addEventListener 'transitionend', ->
		window.scrollTo 0, 0
		do this.remove
		return
window.addEventListener 'load', windowLoadHandler
