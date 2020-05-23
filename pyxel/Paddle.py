from settings import screen_y_dim


class Paddle:
    def __init__(self, x_position: int, color: int, height: int, width: int, speed: int):
        self.color = color
        self.height = height
        self.y = (screen_y_dim // 2) - (self.height // 2)
        self.x = x_position
        self.width = width
        self.speed = speed

    def move_up(self):
        if self.y > 0:
            self.y = self.y - self.speed

    def move_down(self):
        if (self.y + self.height) < screen_y_dim:
            self.y = self.y + self.speed
