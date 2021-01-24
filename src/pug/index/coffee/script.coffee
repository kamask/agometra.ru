window.starters.push ->
	import('/js/index.js?ver=' + window.ago.AGO_CACHE_VERSION)
	cssTag = document.createElement 'link'
	cssTag.rel = 'stylesheet'
	cssTag.href = '/css/index.css'
	document.getElementsByTagName('head')[0].append cssTag