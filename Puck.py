import random

from settings import screen_y_dim, screen_x_dim


class Puck:
    def __init__(self, size: int, speed: int):
        self.side_length = size
        self.x = screen_x_dim // 2
        self.y = screen_y_dim // 2
        self.color = 7
        self.move_down = bool(random.getrandbits(1))
        self.move_right = bool(random.getrandbits(1))
        self.speed = speed
        self.in_left_goal: bool = False
        self.in_right_goal: bool = False

    def move(self):
        if self.y <= 0:
            self.move_down = True

        if self.y + self.side_length >= screen_y_dim:
            self.move_down = False

        if self.move_down:
            self.y += self.speed
        else:
            self.y -= self.speed

        if self.move_right:
            self.x += self.speed
        else:
            self.x -= self.speed
