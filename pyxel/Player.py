from Paddle import Paddle
from settings import *


class Player:
    def __init__(self, color: int, side: str):
        self.score: int = 0
        self.won: bool = False

        if side == "LEFT":
            self.paddle = Paddle(paddle_padding_from_screen, color, paddle_height, paddle_width,
                                 paddle_speed)
        elif side == "RIGHT":
            self.paddle = Paddle(screen_x_dim - paddle_width - paddle_padding_from_screen, color,
                                 paddle_height, paddle_width, paddle_speed)
        else:
            raise RuntimeError("Player side expected LEFT or RIGHT.")