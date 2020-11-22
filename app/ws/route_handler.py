from starlette.websockets import WebSocket, WebSocketDisconnect
from . import callback

ws_list = dict()
ws_id_counter = 0
ws_handlers = dict({
  'callback': callback.handler
})


async def ws_incoming(websocket):
  await websocket.accept()
  global ws_id_counter
  ws_id_counter += 1
  ws_id = ws_id_counter
  ws_list[ws_id] = websocket

  await websocket.send_json({'type': 'id', 'data': ws_id})
  
  try:
    while(True):
      data = await websocket.receive_json()
      if data['type'] in ws_handlers:
        await ws_handlers[data['type']](ws_id, data['data'])
  except WebSocketDisconnect:
    if ws_id in ws_list:
      del ws_list[ws_id]

  await websocket.close()
  if ws_id in ws_list:
    del ws_list[ws_id]