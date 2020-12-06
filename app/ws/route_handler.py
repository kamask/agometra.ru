import json
from starlette.websockets import WebSocket, WebSocketDisconnect
from ..db import db
from .ws import ws_list

from . import callback
from . import login

ws_id_counter = 0

ws_handlers = dict({
  'callback': callback.handler,
  'login': login.handler
})


async def ws_incoming(websocket):
  await websocket.accept()
  global ws_id_counter
  ws_id_counter += 1
  ws_id = ws_id_counter
  ws_list[ws_id] = websocket

  shirts_raw = await db.fetch_all('select * from shirts')
  shirts = [dict(s) for s in shirts_raw]

  density_raw = await db.fetch_all('select * from density')
  density = [dict(s) for s in density_raw]

  colors_raw = await db.fetch_all('select * from colors')
  colors = [dict(s) for s in colors_raw]

  sizes_raw = await db.fetch_all('select * from sizes')
  sizes = [dict(s) for s in sizes_raw]

  photos_shirts_raw = await db.fetch_all('select * from photos_shirts')
  photos_shirts = [dict(s) for s in photos_shirts_raw]

  data = {
    'shirts': shirts,
    'density': density,
    'colors': colors,
    'sizes': sizes,
    'photos_shirts': photos_shirts
  }

  await websocket.send_json({'type': 'id', 'data': ws_id})
  await websocket.send_json({'type': 'data-init', 'data': json.dumps(data)})
  
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