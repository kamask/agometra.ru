from starlette.applications import Starlette
from .config import DEBUG
from .routes import routes, tlgrm_webhook_set
from .exception_handlers import exception_handlers
from .db import db

HTML_404_PAGE = ...


async def check_migrations():
	raw = await db.fetch_one("SELECT 1 FROM information_schema.tables WHERE table_name = 'migrations';")
	if not raw:
		raise Exception('Не обнаружена структура БД! Сделайте изначальную миграцию!')


app = Starlette(
  debug=DEBUG,
  routes=routes,
  exception_handlers=exception_handlers,
  on_startup=[tlgrm_webhook_set, db.connect, check_migrations],
  on_shutdown=[db.disconnect]
  )