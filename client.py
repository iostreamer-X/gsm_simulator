from socketIO_client import SocketIO

def on_aaa_response(*args):
    print 'on_aaa_response', args

socketIO = SocketIO('localhost', 6000)
socketIO.on('futurelabs', on_aaa_response)
