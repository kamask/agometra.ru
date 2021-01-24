{ newEl, ev, el } = window.ago.ksk
import { initData } from './store.js'

loadImg = (img) ->
	$img = newEl 'picture'
	$img.innerHTML = """
	<source srcset="#{img.url.replace /\.jpg$/, '_w360.webp'}" media="(max-width: 480px)" type="image/webp">
	<source srcset="#{img.url.replace /\.jpg$/, '_w360.jpg'}" media="(max-width: 480px)">
	<source srcset="#{img.url.replace /\.jpg$/, '_w800.webp'}" type="image/webp">
	<img src="#{img.url.replace /\.jpg$/, '_w800.jpg'}" alt="#{img.desc}" />
	"""
	return $img

loadPreview = (img) ->
	$img = newEl 'picture'
	$img.innerHTML = """
	<source srcset="#{img.url.replace /\.jpg$/, '_w360.webp'}" type="image/webp">
	<img src="#{img.url.replace /\.jpg$/, '_w360.jpg'}" alt="#{img.desc}" />
	"""
	return $img

do (->
	{gallery_agometra: photos} = await do initData

	photos.sort (a, b) -> a.id - b.id

	current = 0

	$gallery = el '#gallery-agometra'

	$slider = newEl 'div'
	$slider.className = 'slider'
	$gallery.append $slider

	$previews = newEl 'div'
	$previews.className = 'previews'

	$$slides = []
	$$prevslides = []

	$next = newEl 'span'
	$next.className = 'next'
	$next.innerHTML = '''<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" aria-hidden="true" focusable="false" viewBox="0 0 17 16"><path d="M9 16a8 8 0 0 0 8-8a8 8 0 0 0-8-8a8 8 0 0 0-8 8a8 8 0 0 0 8 8zM7 4.154c.186-.205.775-.205.96 0l4.9 3.467a.567.567 0 0 1 0 .745l-4.9 3.48c-.185.205-.774.205-.96 0V4.154z" fill="#eacaaf" fill-rule="evenodd"/></svg>'''

	$prev = newEl 'span'
	$prev.className = 'prev'
	$prev.innerHTML = '''<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" aria-hidden="true" focusable="false" viewBox="0 0 17 16"><path d="M9 0a8 8 0 0 0-8 8a8 8 0 0 0 8 8a8 8 0 0 0 8-8c0-4.418-3.58-8-8-8zm2 11.846c-.186.205-.774.205-.96 0l-4.9-3.467a.563.563 0 0 1 0-.745l4.9-3.48c.185-.205.773-.205.96 0v7.692z" fill="#eacaaf" fill-rule="evenodd"/></svg>'''

	$prev.style.opacity = 'none'

	$controls = newEl 'div'
	$gallery.append $controls

	$controls.append $prev
	$controls.append $previews
	$controls.append $next

	photos.forEach (p, i) ->
		$slide = newEl 'div'
		$slide.className = 'slide'
		$desc = newEl 'span'
		$desc.textContent = p.desc
		$slide.append $desc
		$slide.append loadImg p
		$slider.append $slide
		$$slides.push $slide
		$prevslide = newEl 'div'
		$prevslide.append loadPreview p
		$previews.append $prevslide
		$$prevslides.push $prevslide
		if i is current
			$slide.classList.add 'show'
			$prevslide.classList.add 'current'
		return

	ev $next, 'click', ->
		if current < $$slides.length - 1
			$$prevslides[current].classList.remove 'current'
			$$slides[current].classList.remove 'show'
			$$slides[current].classList.add 'hide'
			$$slides[++current].classList.add 'show'
			$$prevslides[current].classList.add 'current'
			if current is $$slides.length - 1 then @.style.opacity = '0'
			if $prev.style.opacity is '0' then $prev.style.opacity = '1'
			do previewsMove
		return

	ev $prev, 'click', ->
		if current > 0
			$$prevslides[current].classList.remove 'current'
			$$slides[current--].classList.remove 'show'
			$$slides[current].classList.remove 'hide'
			$$slides[current].classList.add 'show'
			$$prevslides[current].classList.add 'current'
			if current is 0 then @.style.opacity = '0'
			if $next.style.opacity is '0' then $next.style.opacity = '1'
			do previewsMove
		return

	previewsMove = ->
		frameSize = 100
		widthAllPreviews = $$prevslides.length * (frameSize + 10)
		stockSize = widthAllPreviews - $previews.offsetWidth
		if stockSize > 0
			currentFramePos = ((current + 1) * (frameSize + 10)) - (frameSize / 2)
			middle = $previews.offsetWidth / 2
			$$prevslides[0].style.marginLeft = ''
			if currentFramePos > middle
				offset = currentFramePos - middle
				if offset > stockSize then offset = stockSize
				$$prevslides[0].style.marginLeft = '-' + offset + 'px'

		return

	return)
