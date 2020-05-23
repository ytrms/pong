import pyxel

from Paddle import Paddle
from Puck import Puck


def paddle_and_puck_collide(paddle: Paddle, puck: Puck) -> bool:
    """
    Given a paddle and a puck, returns whether the two collide.
    """

    if paddle.x + paddle.width >= puck.x >= paddle.x:
        if puck.y < paddle.y + paddle.height // 2:
            if puck.y + puck.side_length >= paddle.y:
                pyxel.play(0, 0)
                return True
        else:
            if puck.y <= paddle.y + paddle.height:
                pyxel.play(0, 0)
                return True

    if paddle.x <= puck.x + puck.side_length <= paddle.y + paddle.width:
        if puck.y < paddle.y + paddle.height // 2:
            if puck.y + puck.side_length >= paddle.y:
                pyxel.play(0, 0)
                return True
        else:
            if puck.y <= paddle.y + paddle.height:
                pyxel.play(0, 0)
                return True
    return False
