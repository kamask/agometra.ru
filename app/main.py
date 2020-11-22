from starlette.applications import Starlette
from .routes import routes, tlgrm_webhook_set
from .exception_handlers import exception_handlers

HTML_404_PAGE = ...

app = Starlette(
  debug=True,
  routes=routes,
  exception_handlers=exception_handlers,
  on_startup=[tlgrm_webhook_set]
  )
