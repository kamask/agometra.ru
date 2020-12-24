import { makeObserveble } from '/js/ksk-lib.js'

export store = makeObserveble {}

init = false

export updateFromWs = (ws_handlers) ->
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

window.getAgoStore = -> store
