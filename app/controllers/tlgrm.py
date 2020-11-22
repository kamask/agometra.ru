from starlette.responses import JSONResponse


async def tlgrm(request):
  # data = await request.json()
  # msg = data['message']
  # chat = msg['chat']
  # print(f'''

  # -----------------------------------------
  # {chat['id']}

  # {chat['username']}
  # {chat['first_name']}
  # {chat['last_name']}
  
  # {msg['text']}
  # -----------------------------------------

  # ''')
  return JSONResponse({'status': 'ok'})