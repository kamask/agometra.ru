from ..templates import tpl

async def home(request):
    return tpl.TemplateResponse('index.html', {
            'request': request,
            'title': 'Купить футболки оптом'
        })
