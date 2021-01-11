import { makeObserveble } from '../ksk-lib.js'
import { ws_handlers } from '../ws.js'

export store = makeObserveble {}

init = false

ws_handlers.set 'data-shirts-update', (data) ->
  data = JSON.parse data
  if data.where == 'all-init' and not init
    init = true
    store.dataFromServer = makeObserveble data.data
  return

export initData = ->
	new Promise (resolve) ->
		if init then resolve store.dataFromServer
		store.addObserver (target, property, val) ->
			if property is 'dataFromServer'
				resolve val
			return
		return
