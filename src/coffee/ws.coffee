import { log } from '/js/ksk-lib.js'

ws = new WebSocket 'wss://test.agometra.ru/ws'

ws.onopen = (e) ->
  log "WebSocket connedted"
  ws.send "hello Moto"
  return

ws.onmessage = (e) ->
  log "Socket take: " + e.data

ws.onclose = (e) ->
  log "Socket closed"
  return

ws.onerror = (e) ->
  log "Socket err: " + e.message