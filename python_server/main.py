from pythonosc import udp_client, osc_server
from pythonosc.dispatcher import Dispatcher
from time import sleep

from typing import List, Any

import hrmovematching

from threading import Thread

FRAME_RATE = 30

class ToioManager:
    def __init__(self):
        self.client = udp_client.SimpleUDPClient("127.0.0.1", 3333)
        self.disp = Dispatcher()
        self.disp.map("/toio_input", self.handle_toio_pos_update)
        self.server = osc_server.ThreadingOSCUDPServer(("127.0.0.1", 3334), self.disp)
        self.server.serve_forever()

        self.hr_x = 0
        self.hr_y = 0
        self.timeline_x = 0
        self.timeline_y = 0
        

        while True:
            self.update_position()
            self.update_projections()
            sleep(1 / FRAME_RATE)

    def handle_toio_pos_update(self, addr: str, name: str, x_pos: float, y_pos: float):
        if "hr" == name:
            self.hr_x = x_pos
            self.hr_y = y_pos
        elif "timeline" == name:
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
        x_pos = 0.0  
        y_pos = 0.0


        snap_hr_xcord, snap_hr_ycord, radiuscoords, snap_sliderpos, color = hrmovematching.hrmatching(self.hr_x, self.hr_y)

        print(snap_hr_xcord, snap_hr_ycord)
        self.client.send_message("/toio", ["hr", -50, -50])
        self.client.send_message("/toio", ["timeline", 0, 50])
        self.client.send_message("/toio", ["star_top_l", 50, y_pos])
        self.client.send_message("/toio", ["star_top_r", x_pos, y_pos])
        self.client.send_message("/toio", ["star_bot_l", x_pos, y_pos])
        self.client.send_message("/toio", ["star_bot_r", x_pos, y_pos])
        self.client.send_message("/toio", ["planet_orbit", x_pos, y_pos])

if __name__ == "__main__":
    ToioManager()