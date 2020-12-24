from databases import Database

from .config import DB_URL

db = Database(DB_URL)



async def add_order_shirts(client_data, shirts, one_click = False):
  raw = await db.fetch_one('SELECT id, name FROM clients WHERE number = :number', {'number': client_data['number']})
  if not raw:
    client = client_data
    query = f"INSERT INTO clients(number{', name' if 'name' in client_data else ''}) VALUES(:number{', :name' if 'name' in client_data else ''}) RETURNING id"
    client['id'] = await db.execute(query, client_data)
  else:
    client = dict(raw)
    client['number'] = client_data['number']

  order_id = await db.execute(
    'INSERT INTO orders(client_id, one_click) VALUES(:client_id, :one_click) RETURNING id',
    {'client_id': client['id'], 'one_click': one_click})

  values = []
  for k, v in shirts.items():
    values.append({'shirt_id': int(k), 'count': v, 'order_id': order_id})
  await db.execute_many(
    'INSERT INTO orders_shirts_list(order_id, shirt_id, count) VALUES(:order_id, :shirt_id, :count)',
     values)
  return order_id
