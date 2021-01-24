{ makeObserveble } = window.ago.ksk

export store = makeObserveble {}

init = false

modulesLoaded = new Promise (resolve) ->
	loading = ->
		if `'wslib' in window.ago`
			do resolve
		else setTimeout loading, 100
	do loading

modulesLoaded.then ->
	{ ws_handlers } = window.ago.wslib
	ws_handlers.set 'data-shirts-update', (data) ->
		data = JSON.parse data
		if data.where == 'all-init' and not init
			init = true
			store.dataFromServer = makeObserveble data.data
		return
	return

export initData = ->
	new Promise (resolve) ->
		if init then resolve store.dataFromServer
		store.addObserver (target, property, val) ->
			if property is 'dataFromServer'
				resolve val
			return
		return
