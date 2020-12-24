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


window.getAgoStore = -> store