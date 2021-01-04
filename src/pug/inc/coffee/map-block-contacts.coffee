window.addEventListener 'load', ->
	init = ->
		myMap = new ymaps.Map 'map', {
			center: if document.documentElement.clientWidth <= 600 then [55.657590, 37.802574] else [55.659286, 37.784565]
			zoom: 13
			controls: ['zoomControl', 'typeSelector',  'fullscreenControl']
		}
		myMap.geoObjects.add new ymaps.Placemark [55.658767, 37.807410], {
			balloonContent: 'ООО "Агометра" - Футболки оптом.<br>Работает! 8.00 - 19.00'
			iconCaption: 'ООО "Агометра" - Футболки оптом.'
		}, {
			preset: 'islands#greenDotIconWithCaption'
		}
		return
	ymaps.ready init
	return
