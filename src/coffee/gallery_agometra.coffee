import { log, newEl, ev, el } from '/js/ksk-lib.js'
import { initData } from '/js/store.js'

loadImg = (img) ->
	$img = newEl 'picture'
	img360 =
	$img.innerHTML = """
	<source srcset="#{img.url.replace /\.jpg$/, '_w360.webp'}" media="(max-width: 480px)" type="image/webp">
	<source srcset="#{img.url.replace /\.jpg$/, '_w360.jpg'}" media="(max-width: 480px)">
	<source srcset="#{img.url.replace /\.jpg$/, '_w800.webp'}" type="image/webp">
	<img src="#{img.url.replace /\.jpg$/, '_w800.jpg'}" alt="#{img.desc}" />
	"""
	return $img

do (->
	{gallery_agometra: photos} = await do initData

	photos.sort (a, b) -> a.id - b.id

	current = 0

	$gallery = el '#gallery_agometra'

	$slider = newEl 'div'
	$slider.className = 'slider'
	$gallery.append $slider

	$$slides = []

	photos.forEach (p, i) ->
		$slide = newEl 'div'
		$slide.className = if i is current then 'slide show' else 'slide'
		$desc = newEl 'span'
		$desc.textContent = p.desc
		$slide.append $desc
		$slide.append loadImg p
		$slider.append $slide
		$$slides.push $slide

		# ev $slide, 'transitionend', (e) ->
		# 	if e.propertyName is 'right' and e.target.classList.contains 'hide'
		# 		e.target.classList.remove 'hide'
		# 	return
		return

	$next = newEl 'span'
	$next.className = 'next'
	$next.textContent = 'Next'
	$gallery.append $next

	$prev = newEl 'span'
	$prev.className = 'prev'
	$prev.textContent = 'Prev'
	$gallery.append $prev
	$prev.style.display = 'none'

	ev $next, 'click', ->
		if current < $$slides.length - 1
			$$slides[current].classList.remove 'show'
			$$slides[current].classList.add 'hide'
			$$slides[++current].classList.add 'show'
			if current is $$slides.length - 1 then @.style.display = 'none'
			if $prev.style.display is 'none' then $prev.style.display = 'block'
		return

	ev $prev, 'click', ->
		if current > 0
			$$slides[current--].classList.remove 'show'
			$$slides[current].classList.remove 'hide'
			$$slides[current].classList.add 'show'
			if current is 0 then @.style.display = 'none'
			if $next.style.display is 'none' then $next.style.display = 'block'
		return
	return)
