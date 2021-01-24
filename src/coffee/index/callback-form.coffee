{ ev, el, log } = window.ago.ksk

modulesLoaded = new Promise (resolve) ->
	loading = ->
		if `'agolib' in window.ago` and `'wslib' in window.ago`
			do resolve
		else setTimeout loading, 100
	do loading


modulesLoaded.then ->
	{ handleInputTel, divHelperInsert } = window.ago.agolib
	{ ws, ws_handlers } = window.ago.wslib

	callbackForm = el '#callback-form'

	handleInputTel callbackForm.elements.number

	ev callbackForm, 'submit', (e) ->
		do e.preventDefault
		if @classList.contains 'alert' then return
		data = (@elements.number.value.replace /[\+_\(\)\s-]/g, '').replace /^7/, '8'
		if /^8\d{10}$/.test data
			ws.send JSON.stringify { type: 'callback', data }
			@elements.number.value = ''
		else
			divHelperInsert callbackForm, 'callback-helper', null, if data == '8' then 'Введите номер!' else 'Некорректный номер!'
		return

	ws_handlers.set 'callback', (data) ->
		divHelperInsert callbackForm, 'callback-helper', 'Уже набираем!'
		return
