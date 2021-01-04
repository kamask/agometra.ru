from ..templates import tpl
from ..db import db
from ..config import HOST

async def home(request):
	exact_sizes = dict()
	try:
		raw = await db.fetch_all('''SELECT d.code as density, s.euro as size, a, b, c, d FROM exact_sizes as es
								  						JOIN density as d ON es.density_id = d.id
															JOIN sizes as s ON es.size_id = s.id''')
	except:
		raw = None

	if raw:
		for i in raw:
			if not str(i['density']) in exact_sizes: exact_sizes[str(i['density'])] = dict()
			if not i['size'] in exact_sizes[str(i['density'])]: exact_sizes[str(i['density'])][i['size']] = dict()
			exact_sizes[str(i['density'])][i['size']]['A'] = i['a']
			exact_sizes[str(i['density'])][i['size']]['B'] = i['b']
			exact_sizes[str(i['density'])][i['size']]['C'] = i['c']
			exact_sizes[str(i['density'])][i['size']]['D'] = i['d']

	return tpl.TemplateResponse('index.html', {
			'request': request,
			'title': 'Купить футболки оптом',
			'wssurl': f'wss://{HOST}/ws',
			'exact_sizes': exact_sizes
		})
