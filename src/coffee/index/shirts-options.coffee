{ el, ev, makeObserveble, nodeObserver, els } = window.ago.ksk
import { store } from './store.js'

export current = makeObserveble {
	density: null
	color: null
}

store.addObserver (target, property, value) ->
	if property == 'dataFromServer'
		value.addObserver (target, property, value) ->
			if property is 'density' then do renderDensityOptions
			return
		do renderDensityOptions
	return

export $options = el '#shirts .options'
$densityPrice = el '.density-price', $options

docWidth = document.documentElement.clientWidth

if docWidth <= 1199
	el '#shirts>div:last-child'
	.prepend $options

renderDensityOptions = ->
	{ density } = store.dataFromServer

	$densityList = document.createElement 'ul'
	for d in density
		$densityItem = document.createElement 'li'
		$densityItem.densityId = d.id
		$densityItem.innerText = d.code + ' г/м²'
		$densityList.append $densityItem


	$densityPrice.before $densityList

	nodeObserver $densityList, {
		subtree: true
		attributes: true
		attributeFilter: ['class']
	}, (mr) ->
		if mr.type == 'attributes' and mr.target.tagName == 'LI'
			if mr.target.classList.contains('active')
				current.density = mr.target.densityId
				if current.density == 3
					el('.bonus-price').classList.add 'show'
				else
					el('.bonus-price').classList.remove 'show'
				d = density.find (i) -> i.id == mr.target.densityId
				prices = [d.price, d.price_100, d.price_1000, d.price_1000 - 5]
				for $li, i in els 'li', $densityPrice
					if i == 4 then continue
					el 'span:last-child', $li
					.innerText = if i == 3 then "#{prices[i]}₽ и ниже" else "#{prices[i]}₽"
				do renderColorOptions
		return

	for $li, i in els 'li', $densityList
		if i == 0 then $li.classList.add 'active'

		ev $li, 'click', (e) ->
			if not @classList.contains 'active'
				el '.active', $densityList
				.classList.remove 'active'
				@classList.add 'active'
			return


	return

$colorsOptions = el '.color', $options

renderColorOptions = ->
	t = el 'ul', $colorsOptions
	if t then do t.remove

	shirts = store.dataFromServer.shirts.filter (i) -> i.density_id is current.density
	shirts.sort (a, b) -> a.id - b.id
	colorsIds = new Set (i.color_id for i in shirts)
	colors = ((store.dataFromServer.colors.find (c) -> c.id is i) for i in Array.from colorsIds)

	$colorsList = document.createElement 'ul'
	for c in colors
		$li = document.createElement 'li'
		$li.colorId = c.id
		$li.style.backgroundColor = '#' + c.hex
		$colorsList.append $li

	$colorsOptions.append $colorsList

	nodeObserver $colorsList, {
		subtree: true
		attributes: true
		attributeOldValue: true
	}, (mr) ->
		if mr.type == 'attributes' and mr.target.tagName == 'LI'
			if mr.target.classList.contains('active')
				current.color = mr.target.colorId
				do renderCount
		return

	for $li, i in els 'li', $colorsList
		if i == 0 then $li.classList.add 'active'

		ev $li, 'click', (e) ->
			if not @classList.contains 'active'
				el '.active', $colorsList
				.classList.remove 'active'
				@classList.add 'active'
			return


$existenceOptions = el '.existence', $options
$expectedOptions = el '.expected', $options

renderCount = ->
	shirts = store.dataFromServer.shirts.filter (i) -> i.density_id is current.density and i.color_id is current.color
	shirtsIds = (i.id for i in shirts)
	expected = store.dataFromServer.expected.filter (i) -> i.shirt_id in shirtsIds
	sizes = store.dataFromServer.sizes

	if expected.length is 0 then $expectedOptions.classList.add 'empty'
	else $expectedOptions.classList.remove 'empty'

	t = el 'ul', $existenceOptions
	if t then do t.remove

	shirts.sort (a, b) -> a.id - b.id

	$existenceList = document.createElement 'ul'
	for s in shirts
		size = (sizes.find (i) -> i.id is s.size_id).euro
		$li = document.createElement 'li'
		$li.innerHTML = "#{size}: <span>#{s.count} шт.</span>"
		$existenceList.append $li
	$existenceOptions.append $existenceList

	t = el 'ul', $expectedOptions
	if t then do t.remove

	if expected.length > 0
		$expectedList = document.createElement 'ul'
		for e in expected
			size = (sizes.find (i) -> i.id is (shirts.find (i) -> i.id is e.shirt_id).size_id).euro
			date = new Date e.date
			.toLocaleDateString 'ru', {
				day: 'numeric'
				month: 'long'
				year: 'numeric'
			}
			$li = document.createElement 'li'
			$li.innerHTML = "#{size}: <span>#{e.count} шт.</span> #{date}"
			$expectedList.append $li
		$expectedOptions.append $expectedList
	return
	
	
modulesLoaded = new Promise (resolve) ->
	loading = ->
		if `'wslib' in window.ago`
			do resolve
		else setTimeout loading, 100
	do loading


modulesLoaded.then ->
	{ ws_handlers } = window.ago.wslib

	ws_handlers.set 'shirts-count-subtract', (data) ->
		for s in data
			f = store.dataFromServer.shirts.findIndex (i) -> i.id is s.id
			store.dataFromServer.shirts[f].count = s.count
			do renderCount
		return