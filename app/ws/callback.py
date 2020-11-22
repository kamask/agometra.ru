from datetime import datetime
import requests_async as requests

from ..config import TELEGRAM_BOT_ADMINS, TELEGRAM_BOT_URL


async def handler(id, data):
  text = f'''
*Обратный звонок:*

[{data}](tel://{data})

*{datetime.now().strftime("%d.%m.%Y")}*
*{datetime.now().strftime("%H:%M:%S")}*
'''

  for a in TELEGRAM_BOT_ADMINS:
    await requests.post(TELEGRAM_BOT_URL + 'sendMessage', data={
      'chat_id': a,
      'text': text,
      'parse_mode': 'Markdown'
    })