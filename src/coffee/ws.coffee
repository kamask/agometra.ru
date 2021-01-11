import { log } from './ksk-lib.js'

export ws_handlers = new Map

export ws = new WebSocket "wss://#{window.AGOHOST}/ws"

wsInit = ->
  if ws.readyState is 3
    try
      ws = new WebSocket "wss://#{window.AGOHOST}/ws"
    catch

  ws.onmessage = (e) ->
    data = JSON.parse(e.data)
    if data.type is 'id'
      ws.id = data.data
    else if ws_handlers.has(data.type)
      (ws_handlers.get data.type) data.data
    return

  ws.onclose = (e) ->
    setTimeout wsInit, 500
    return

  ws.onerror = (e) ->
    setTimeout wsInit, 500
    return

  return

do wsInit
