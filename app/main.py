from starlette.applications import Starlette
from .routes import routes
from .exception_handlers import exception_handlers

HTML_404_PAGE = ...

app = Starlette(debug=True, routes=routes, exception_handlers=exception_handlers)
