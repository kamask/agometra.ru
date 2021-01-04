import { log } from '/js/ksk-lib.js'
import { updateFromWs } from '/js/store.js'

export ws_handlers = new Map

updateFromWs ws_handlers

export ws = new WebSocket window.AGOWSSURL

wsInit = ->
  if ws.readyState is 3
    try
      ws = new WebSocket window.AGOWSSURL
    catch error
      log error

  ws.onopen = (e) ->
    log "WebSocket conneсted"
    return

  ws.onmessage = (e) ->
    data = JSON.parse(e.data)
    if data.type is 'id'
      ws.id = data.data
    else if ws_handlers.has(data.type)
      (ws_handlers.get data.type) data.data
    return

  ws.onclose = (e) ->
    log "WebSocket closed"
    setTimeout wsInit, 500
    return

  ws.onerror = (e) ->
    log "WebSocket error: " + e.message
    setTimeout wsInit, 500
    return

  return

do wsInit
