from starlette.routing import Route
from .controllers.home import home
from .controllers.page_404 import page_404

routes = [
    Route('/', home),
    Route('/404', page_404)
]
