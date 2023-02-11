from pythonosc import udp_client
from pythonosc.dispatcher import Dispatcher

client = udp_client.SimpleUDPClient("127.0.0.1", 5005)

def snap_position(*args: List[float])

client.send_message("/toio/hr_cursor/pos", (x_pos, y_pos))