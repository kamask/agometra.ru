import json
from starlette.websockets import WebSocket, WebSocketDisconnect
from ..db import db
from .ws import ws_list

from . import callback
from . import login
from . import one_click

ws_id_counter = 0

ws_handlers = dict({
	'callback': callback.handler,
	'login': login.handler,
	'one_click': one_click.handler
})


async def ws_incoming(websocket):
	await websocket.accept()
	global ws_id_counter
	ws_id_counter += 1
	ws_id = ws_id_counter
	ws_list[ws_id] = websocket

	await websocket.send_json({'type': 'id', 'data': ws_id})

	try:
		await send_init_data(websocket)
	except:
		print("Ошибка при получении инициализирующих данных из БД!")

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


async def send_init_data(websocket):
	shirts_raw = await db.fetch_all('select * from shirts')
	shirts = [dict(s) for s in shirts_raw]

	expected_raw = await db.fetch_all('select * from expected')
	expected = [dict(s) for s in expected_raw]
	for i in expected:
		i['date'] = str(i['date'])

	density_raw = await db.fetch_all('select * from density')
	density = [dict(s) for s in density_raw]

	colors_raw = await db.fetch_all('select * from colors')
	colors = [dict(s) for s in colors_raw]

	sizes_raw = await db.fetch_all('select * from sizes')
	sizes = [dict(s) for s in sizes_raw]

	photos_shirts_raw = await db.fetch_all('select * from photos_shirts')
	photos_shirts = [dict(s) for s in photos_shirts_raw]

	gallery_agometra_raw = await db.fetch_all('select * from gallery_agometra')
	gallery_agometra = [dict(i) for i in gallery_agometra_raw]

	data = {
		'where': 'all-init',
		'data': {
			'shirts': shirts,
			'density': density,
			'colors': colors,
			'sizes': sizes,
			'photos_shirts': photos_shirts,
			'expected': expected,
			'gallery_agometra': gallery_agometra
		}
	}

	await websocket.send_json({'type': 'data-shirts-update', 'data': json.dumps(data)})
