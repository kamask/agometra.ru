from uuid import uuid4
import requests_async as request
from starlette.routing import Route, WebSocketRoute

from .config import TELEGRAM_BOT_URL, HOST_URL

from .controllers.home import home
from .controllers.tlgrm import tlgrm
from .controllers.page_404 import page_404
from .ws.route_handler import ws_incoming

webhook_token = str(uuid4())

async def tlgrm_webhook_set():
  res = await request.post(TELEGRAM_BOT_URL + 'setWebhook', data={
    'url': HOST_URL + webhook_token
  })


routes = [
  Route('/', home),
  Route('/' + webhook_token, tlgrm, methods=['POST']),
  Route('/404', page_404),
  WebSocketRoute('/ws', ws_incoming)
]
