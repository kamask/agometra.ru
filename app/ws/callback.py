from datetime import datetime
import requests_async as requests

from ..config import TELEGRAM_BOT_ADMINS, TELEGRAM_BOT_URL
from ..db import db
from .ws import ws_list


async def handler(id, data):
  if data.isdigit() and len(data) == 11:
    await ws_list[id].send_json({'type': 'callback', 'data': 'access'})
    await db.execute(
      query='INSERT INTO callback(number) VALUES (:number)',
      values={'number': data}
      )

    tel_number = f"{data[0]} ({data[1:4]}) {data[4:7]}-{data[7:9]}-{data[9:11]}"

    text = f'''
  *Обратный звонок:*

  [{tel_number}](tel:{data})

  *{datetime.now().strftime("%d.%m.%Y")}*
  *{datetime.now().strftime("%H:%M:%S")}*
  '''

    for a in TELEGRAM_BOT_ADMINS:
      await requests.post(TELEGRAM_BOT_URL + 'sendMessage', data={
        'chat_id': a,
        'text': text,
        'parse_mode': 'Markdown'
      })