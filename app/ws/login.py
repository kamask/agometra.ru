from .ws import ws_list


async def handler(id, data):
  number = data['number']
  form = data['form']
  if number.isdigit() and len(number) == 11:
    await ws_list[id].send_json({'type': 'login-' + form, 'data': 'error'})