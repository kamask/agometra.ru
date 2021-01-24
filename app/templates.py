from starlette.templating import Jinja2Templates

tpl = Jinja2Templates(directory='app/tpl')

tpl.env.cache_size = 0