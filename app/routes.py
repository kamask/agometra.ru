from starlette.routing import Route, WebSocketRoute
from .controllers.home import home
from .controllers.ws import ws
from .controllers.page_404 import page_404

routes = [
    Route('/', home),
    Route('/404', page_404),
    WebSocketRoute('/ws', ws)
]
