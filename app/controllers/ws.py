from starlette.websockets import WebSocket

async def ws(websocket):
    await websocket.accept()
    await websocket.send_text('Hello, world!')
    await websocket.close()