import pyxel

from collision import paddle_and_puck_collide
from Player import Player
from Puck import Puck
from settings import *


class App:
    def __init__(self, player_one: Player, player_two: Player):
        self.game_paused: bool = True
        self.pause_msg: str = f"WIN AT {points_to_score_to_win!s}"
        self.bg_music_playing: bool = False
        self.player1 = player_one
        self.player2 = player_two

        pyxel.init(width=screen_x_dim,
                   height=screen_y_dim,
                   caption="PONG",
                   fullscreen=fullscreen,
                   fps=fps
                   )
        pyxel.load(assets_file_path)
        pyxel.run(self.update, self.draw)

    def start_bg_music(self):
        if not self.bg_music_playing:
            pyxel.play(1, 3, loop=True)
            self.bg_music_playing = True

    def stop_bg_music(self):
        if self.bg_music_playing:
            pyxel.stop(1)
            self.bg_music_playing = False

    def update_score(self):
        # update points and set ball
        if the_puck.x <= 0:
            self.player2.score += 1
            self.stop_bg_music()
            pyxel.play(0, 1)
            the_puck.x = paddle2.x - paddle2.width
            the_puck.y = paddle2.y + paddle2.height // 2
            if self.player2.score >= 5:
                self.pause_msg = "BRAVO P2!"
                self.player2.won = True
                self.stop_bg_music()
                pyxel.play(0, 2)
            self.game_paused = True
        elif the_puck.x + the_puck.side_length >= screen_x_dim:
            self.player1.score += 1
            self.stop_bg_music()
            pyxel.play(0, 1)
            the_puck.x = paddle1.x + paddle1.width
            the_puck.y = paddle1.y + paddle1.height // 2
            if self.player1.score >= 5:
                self.pause_msg = "BRAVO P1!"
                self.player1.won = True
                self.stop_bg_music()
                pyxel.play(0, 2)
            self.game_paused = True

    def update(self):
        if pyxel.btnp(pyxel.KEY_SPACE):
            if self.player1.won or self.player2.won:
                pyxel.quit()
            else:
                self.game_paused = not self.game_paused

        if not self.game_paused:
            self.start_bg_music()

            # Listening for input
            if pyxel.btn(pyxel.KEY_Q):
                paddle1.move_up()

            if pyxel.btn(pyxel.KEY_A):
                paddle1.move_down()

            if pyxel.btn(pyxel.KEY_O):
                paddle2.move_up()

            if pyxel.btn(pyxel.KEY_L):
                paddle2.move_down()

            # move puck
            the_puck.move()

            # check collision
            if the_puck.x <= paddle_width + paddle_padding_from_screen:
                if paddle_and_puck_collide(paddle1, the_puck):
                    the_puck.move_right = True
            elif the_puck.x + the_puck.side_length >= screen_x_dim - paddle_padding_from_screen - \
                    paddle_width:
                if paddle_and_puck_collide(paddle2, the_puck):
                    the_puck.move_right = False

        self.update_score()

    def draw(self):
        """
        This function executes each frame.
        """
        if self.game_paused:
            best_of_width = len(self.pause_msg) * 3
            pyxel.text(screen_x_dim // 2 - best_of_width // 2 - 6, screen_y_dim - screen_y_dim // 3,
                       self.pause_msg, 7)
            pyxel.text(screen_x_dim // 2 - 17, screen_y_dim - screen_y_dim // 3 + 6, "SPACEBAR", 7)
        else:
            # Clear screen to color 0 (black)
            pyxel.cls(0)

            # Draw puck
            pyxel.rect(the_puck.x, the_puck.y, the_puck.side_length, the_puck.side_length,
                       the_puck.color)

            # Draw paddles
            pyxel.rect(paddle1.x, paddle1.y, paddle1.width, paddle1.height, paddle1.color)
            pyxel.rect(paddle2.x, paddle2.y, paddle2.width, paddle2.height, paddle2.color)

            # Draw scores
            pyxel.text(screen_x_dim // 3, paddle_padding_from_screen, str(self.player1.score), 7)
            pyxel.text(screen_x_dim - screen_x_dim // 3, paddle_padding_from_screen,
                       str(self.player2.score), 7)


player1 = Player(7, "LEFT")
player2 = Player(7, "RIGHT")

paddle1 = player1.paddle
paddle2 = player2.paddle

the_puck = Puck(size=puck_size, speed=puck_speed)

if __name__ == "__main__":
    App(player1, player2)
