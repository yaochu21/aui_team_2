from pythonosc import udp_client, osc_server
from pythonosc.dispatcher import Dispatcher
from time import sleep

import math
from math import pi

import hrmovematching
import slidermatching

from threading import Thread

FRAME_RATE = 1

class ToioManager:
    def __init__(self):
        self.hr_x = 0
        self.hr_y = 0
        self.timeline_x = 0
        self.timeline_y = 0

        self.client = udp_client.SimpleUDPClient("127.0.0.1", 3333)
        self.disp = Dispatcher()
        self.disp.map("/toio_input", self.handle_toio_pos_update)
        self.server = osc_server.ThreadingOSCUDPServer(("127.0.0.1", 3335), self.disp)
        Thread(target=self.server.serve_forever).start()

        angle_speed = math.pi / 8 # pi/8 rad/s
        self.angle = 0

        self.update_measure = "hr"

        while True:
            self.update_position()
            self.angle += angle_speed / FRAME_RATE
            sleep(1 / FRAME_RATE)

    def handle_toio_pos_update(self, addr: str, name: str, x_pos: float, y_pos: float):
        if "hr" == name:
            if abs(x_pos - self.hr_x) > 10 or abs(y_pos - self.hr_y) > 10:
                self.hr_x = x_pos
                self.hr_y = y_pos
                self.update_measure = "hr"
        elif "timeline" == name:
            if abs(x_pos - self.timeline_x) > 5:
                self.timeline_x = x_pos
                self.update_measure = "timeline"

        # print("Message received")
    

    def update_position(self):
        print("updating position")
        if self.update_measure == "hr":
            self.snap_hr_cords, self.topleftrad, self.toprightrad, self.bottomleftrad, self.bottomrightrad, self.snap_slider_coords, \
                radiusmatch, self.color = hrmovematching.hrmatching(self.hr_x, self.hr_y)
        elif self.update_measure == "timeline":
            self.snap_hr_cords, self.topleftrad, self.toprightrad, self.bottomleftrad, self.bottomrightrad, self.snap_slider_cords, \
                self.color = slidermatching.slidermatching(self.timeline_x)

        radius = math.sqrt((self.bottomleftrad[0] - self.toprightrad[0])**2 + (self.bottomleftrad[1] - self.toprightrad[1])**2) / 2 + 5
        orbit_x = radius * math.cos(self.angle)
        orbit_y = radius * math.sin(self.angle)
        print(radius, orbit_x, orbit_y)


        self.client.send_message("/toio", ["hr", *list(map(int, self.snap_hr_cords))])
        self.client.send_message("/toio", ["timeline", *list(map(int, self.snap_slider_coords))])
        self.client.send_message("/toio", ["star_top_l", *list(map(int, self.topleftrad))])
        self.client.send_message("/toio", ["star_top_r", *list(map(int, self.toprightrad))])
        self.client.send_message("/toio", ["star_bot_l", *list(map(int, self.bottomleftrad))])
        self.client.send_message("/toio", ["star_bot_r", *list(map(int, self.bottomrightrad))])
        self.client.send_message("/toio", ["planet_orbit", int(orbit_x), int(orbit_y)])
        self.client.send_message("/star_color", list(map(int, self.color)))

        if self.update_measure is not None:
            sleep(3) # Wait for updates
            self.update_measure = None
        

if __name__ == "__main__":
    ToioManager()