from pythonosc import udp_client
from pythonosc.dispatcher import Dispatcher
from time import sleep

from typing import List, Any

from threading import Thread

FRAME_RATE = 30

class ToioManager:
    def __init__(self):
        self.client = udp_client.SimpleUDPClient("127.0.0.1", 3334)
        self.disp = Dispatcher()
        self.disp.map("/toio_input/*", self.handle_toio_pos_update)

        self.hr_x = 0
        self.hr_y = 0
        self.timeline_x = 0
        self.timeline_y = 0

        while True:
            self.update_position()
            self.update_projections()
            sleep(1 / FRAME_RATE)

    def handle_toio_pos_update(self, address: str, x_pos: float, y_pos: float):
        if "/hr_pos" in address:
            self.hr_x = x_pos
            self.hr_y = y_pos
        elif "/timeline_pos" in address:
            self.timeline_x = x_pos
            self.timeline_y = y_pos

    def update_projections(self):
        # TODO: update this with calculated parameters(?) for projections stuff
        pass

    def find_closest_point(self, x, y):
        # Sample function for updating the closest point on a grid
        # TODO: use the actual data for this to snap a toio
        return x + 10, y + 10

    def update_position(self):
        # TODO: update this with calculated x and y values for each toio
        x_pos = 0
        y_pos = 0

        # Example code below for accessing class vars
        hr_pos = self.find_closest_point(self.hr_x, self.hr_y)

        self.client.send_message("/toio/hr", hr_pos)
        self.client.send_message("/toio/timeline", (x_pos, y_pos))
        self.client.send_message("/toio/star/top_l", (x_pos, y_pos))
        self.client.send_message("/toio/star/top_r", (x_pos, y_pos))
        self.client.send_message("/toio/star/bot_l", (x_pos, y_pos))
        self.client.send_message("/toio/star/bot_r", (x_pos, y_pos))
        self.client.send_message("/toio/planet_orbit", (x_pos, y_pos))

if __name__ == "__main__":
    ToioManager()