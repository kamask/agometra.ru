from .templates import tpl

async def not_found(request, exc):
  return tpl.TemplateResponse('404.html', {'request': request, 'title': 'Страница не найдена! | AGOMETRA'}, status_code = exc.status_code)

exception_handlers = {
  404: not_found
}
