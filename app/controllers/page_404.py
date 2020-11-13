from ..templates import tpl

async def page_404(request):
    return tpl.TemplateResponse('404.html', {'request': request, 'title': 'Страница не найдена! | AGOMETRA'}, status_code=404)
