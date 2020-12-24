from datetime import datetime
import requests_async as requests
import locale

from ..config import TELEGRAM_BOT_ADMINS, TELEGRAM_BOT_URL
from ..db import db, add_order_shirts
from .ws import ws_list

locale.setlocale(locale.LC_MONETARY, 'ru_RU.UTF-8')


async def handler(id, data):
	if data['tel'].isdigit() and len(data['tel']) == 11:
		tel = data['tel']
	tel_number = f"{tel[0]} ({tel[1:4]}) {tel[4:7]}-{tel[7:9]}-{tel[9:11]}"

	raw = await db.fetch_all(
		query = '''
		SELECT sh.id, sh.count as count_all, s.name as size, d.code as density, d.price, d.price_100, d.price_1000, c.name as color
		FROM shirts AS sh
		JOIN sizes AS s ON s.id = sh.size_id
		JOIN colors AS c ON c.id = sh.color_id
		JOIN density AS d ON d.id = sh.density_id
		WHERE sh.density_id = :density AND sh.color_id = :color
		''',
		values = {'color': data['color'], 'density': data['density']}
	)

	count = 0
	shirts = []
	values = []
	i = 0
	while i < len(raw):
		if str(raw[i]['id']) in data['shirts'] and raw[i]['count_all'] >= data['shirts'][str(raw[i]['id'])]:
			shirts.append(dict(raw[i]))
			shirts[-1]['count'] = data['shirts'][str(raw[i]['id'])]
			count += data['shirts'][str(raw[i]['id'])]
			values.append({'id': raw[i]['id'], 'count': raw[i]['count_all'] - data['shirts'][str(raw[i]['id'])]})
		i += 1

	if count < 20: return

	await db.execute_many('UPDATE shirts SET count = :count WHERE id = :id', values)

	order_id = await add_order_shirts({'number': tel}, data['shirts'], one_click=True)

	price_prop = 'price' if 19 < count < 100 else 'price_100' if 99 < count < 1000 else 'price_1000'

	await ws_list[id].send_json({'type': 'one-click-answer', 'data': {'order_id': order_id, 'price': locale.currency(count * shirts[0][price_prop], grouping=True)}})
	for w in ws_list.values():
		await w.send_json({'type': 'shirts-count-subtract', 'data': values})

	text = f'''
*Новый заказ - "Купить в один клик"*
Номер заказа: {order_id}

Номер телефона: [{tel_number}](tel:{tel})

Плотность: {shirts[0]['density']}г/м²
Цвет: {shirts[0]['color']}
	'''

	i = 1
	for s in shirts:
		text += f'''
{i}.) {s['size']} - {s['count']}шт.'''
		i += 1

	text += f'''

Общее колличество: {count}шт.
Цена за шт.: {locale.currency(shirts[0][price_prop])}

Итого: *{locale.currency(count * shirts[0][price_prop], grouping=True)}*

*{datetime.now().strftime("%d.%m.%Y")}*
*{datetime.now().strftime("%H:%M:%S")}*

	'''
	for a in TELEGRAM_BOT_ADMINS:
		await requests.post(TELEGRAM_BOT_URL + 'sendMessage', data={
		'chat_id': a,
		'text': text,
		'parse_mode': 'Markdown'
		})
