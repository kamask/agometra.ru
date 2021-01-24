{ log, el, els, ev, imgWithWebp, makeObserveble } = window.ago.ksk
import { $options, current } from './shirts-options.js'
import { store } from './store.js'

$calcContainer = el '#shirts>div:last-child'

$photoBlock = el '#shirts-photo>div'
$sliderNav =
	next: el '.slider-nav.next', $calcContainer
	prev: el '.slider-nav.prev', $calcContainer

current.addObserver (target, property, value) ->
	photos = store.dataFromServer.photos_shirts
	if property is 'color'
		(do $el.remove for $el in els '#shirts-photo>div>div')

		photos = (p for p in photos when p.density_id is current.density and
			p.color_id is current.color)
		$$photos = (imgWithWebp p.url_jpg, p.url_webp for p in photos)
		if $$photos.length is 0 then $$photos.push imgWithWebp '/images/no-photo-shirt.jpg', '/images/no-photo-shirt.webp'

		$slider = document.createElement 'div'
		for $photo, i in $$photos
			$photo.style.opacity = '0'
			$div = document.createElement 'div'
			$div.append $photo
			$slider.append $div
		$photoBlock.append $slider

		docWidth = document.documentElement.clientWidth
		w = if docWidth > 370 then 360 else 300

		$slider.style.width = $$photos.length * w + 'px'
		$slider.style.left = '-0'

		slider = makeObserveble {current: 0}
		$sliderNav.prev.style.display = 'none'
		$$photos[0].style.opacity = '1'

		if $$photos.length < 2 then $sliderNav.next.style.display = 'none'
		else
			$sliderNav.next.style.display = 'block'
			slider.addObserver (target, property, value, old) ->
				if value <= 0 then $sliderNav.prev.style.display = 'none'
				else $sliderNav.prev.style.display = 'block'

				if value >= ($$photos.length - 1) then $sliderNav.next.style.display = 'none'
				else $sliderNav.next.style.display = 'block'

				$slider.style.left = '-' + (if value is 0 then 0 else value * w) + 'px'
				$$photos[old].style.opacity = '0'
				$$photos[value].style.opacity = '1'
				return

		ev $sliderNav.next, 'click', (e) ->
			if slider.current < $$photos.length then slider.current++
			return

		ev $sliderNav.prev, 'click', (e) ->
			if slider.current > 0 then slider.current--
			return
	return
