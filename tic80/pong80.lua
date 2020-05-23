-- title:  pong80
-- author: lorenzo
-- desc:   pong in tic80
-- script: lua

function init()
	-- this function initializes all variables to their original state
	paddingFromScreen = 5
	paddleWidth = 5
	paddleHeight = 20

	pointsToWin = 5
	gameIsOver = false

	inMainMenu = true

	singlePlayer = true
	color = 12
	puckSize = 4

	score = {
		player1 = 0,
		player2 = 0
	}

	leftPaddle = {
		width = paddleWidth,
		heigth = paddleHeight,
		x = paddingFromScreen,
		y = (136 // 2) - paddleHeight // 2,
		speed = {
			y = 0,
			max = 4
		}
	}

	rightPaddle = {
		width = paddleWidth,
		heigth = paddleHeight,
		x = 240 - paddingFromScreen - paddleWidth,
		y = (136 // 2) - paddleHeight // 2,
		speed = {
			y = 0,
			max = 4
		}
	}

	puck = {
		size = puckSize,
		x = leftPaddle.x + puckSize + 3,
		y = 136 // 2 - puckSize // 2,
		isActive = false,
		speed = {
			x = 3,
			y = math.floor(math.random())*3-1,
		}
	}
end

init()

function TIC() -- executes at the start of each frame
	cls(0) -- clears screen to black

	if inMainMenu then
		mainMenu()
	elseif gameIsOver then
		gameOver()
	else
		input() -- handles listening to input
		update() -- updates game (e.g. moving the ball, moving the paddle etc)
		collisions() -- detects collisions
		drawGameItems() -- draws game items (not GUI)
	end
end

function OVR() -- executes each frame and draws on different layer, good for GUI
	drawGUI()
end

function mainMenu()
	msg = "   Welcome to PONG\nSQUARE: 1p CIRCLE: 2p"
	local msg_width = print(msg, -50, -50, color, false)
	print(msg, 120 - msg_width // 2, 68-5, color, false)

	if btnp(4) then
		init()
		inMainMenu = false
	elseif btnp(6) then
		init()
		inMainMenu = false
		singlePlayer = false
	end
end

function collisions()
	paddleWallCollision()
	puckWallCollision()
	paddlesPuckCollision()
	puckGoalCollisions()
end

function paddleWallCollision()
	-- detects whether the paddle collides with the wall. if it does, it stops it
	if leftPaddle.y < 0 then
		leftPaddle.y = 0
	elseif leftPaddle.y > 135 - leftPaddle.heigth then
		leftPaddle.y = 135 - leftPaddle.heigth
	end

	if rightPaddle.y < 0 then
		rightPaddle.y = 0
	elseif rightPaddle.y > 135 - rightPaddle.heigth then
		rightPaddle.y = 135 - rightPaddle.heigth
	end
end

function puckWallCollision()
	-- detects puck/wall collision. if collision then inverses ball Y vector
	if puck.y < 0 or puck.y > 136 - puck.size then
		puck.speed.y = -puck.speed.y
	end
end

function puckGoalCollisions()
	puckCollidedWithLeftGoal()
	puckCollidedWithRightGoal()
end

function puckCollidedWithLeftGoal()
	if puck.x < 0 then
		return true
	else
		return false
	end
end

function puckCollidedWithRightGoal()
	if puck.x + puck.size > 240 then
		return true
	else
		return false
	end
end

function paddlesPuckCollision()
	-- handles paddle/puck collisions
	leftPaddlePuckCollision()
	rightPaddlePuckCollision()
end

function leftPaddlePuckCollision()
	-- checks whether the left paddle collided with the puck
	-- if collision, then change puck x vector
	if puck.x < leftPaddle.x + leftPaddle.width and
	   puck.x > leftPaddle.x and
	   puck.y + puck.size > leftPaddle.y and
	   puck.y < leftPaddle.y + leftPaddle.heigth then
		puck.speed.x = -puck.speed.x
	end
end

function rightPaddlePuckCollision()
	-- checks whether the right paddle collided with the puck
	-- if collision, then change puck x vector
	if puck.x + puck.size > rightPaddle.x and puck.x < rightPaddle.x + rightPaddle.width and puck.y + puck.size > rightPaddle.y and puck.y < puck.y + puck.size then
		puck.speed.x = -puck.speed.x
	end
end

function drawGameItems() -- draws game items (not GUI)
	-- draw paddles
	rect(leftPaddle.x, leftPaddle.y, leftPaddle.width, leftPaddle.heigth, color)
	rect(rightPaddle.x, rightPaddle.y, rightPaddle.width, rightPaddle.heigth, color)
	
	-- draw puck
	rect(puck.x, puck.y, puck.size, puck.size, color)
end

function drawGUI() -- draws GUI (score)
	print(tostring(score.player1), 240 // 3, paddingFromScreen, color)
	print(tostring(score.player2), 240 - 240 // 3, paddingFromScreen, color)
end

function input() -- listens to input
	-- at beginning of game, align puck.y with leftpaddle.y
	-- TODO: Move this into own function with proper checks on score
	-- also, move this out of input! it's not that related
	if puck.isActive == false and score.player1 == 0 and score.player2 == 0 then
		puck.y = leftPaddle.y + paddleHeight / 2 - puckSize / 2
	end

	-- when puck is not active, player 1 or 2 can press 4 to activate puck
	if btnp(4) or btnp(12) then
		if puck.isActive == false then
			puck.isActive = true
			p1scored = false
			p2scored = false
		end
	end

	-- handles P1DOWN
	if btn(1) then
		if leftPaddle.speed.y < leftPaddle.speed.max then
			leftPaddle.speed.y = leftPaddle.speed.y + 2
		else
			leftPaddle.speed.y = leftPaddle.speed.max
		end
	end

	-- handles P1UP
	if btn(0) then
		if leftPaddle.speed.y > -leftPaddle.speed.max then
			leftPaddle.speed.y = leftPaddle.speed.y - 2
		else
			leftPaddle.speed.y = -leftPaddle.speed.max
		end
	end

	-- handles P2DOWN
	if btn(9) then
		if rightPaddle.speed.y < rightPaddle.speed.max then
			rightPaddle.speed.y = rightPaddle.speed.y + 2
		else
			rightPaddle.speed.y = rightPaddle.speed.max
		end
	end

	-- handles P2UP
	if btn(8) then
		if rightPaddle.speed.y > -rightPaddle.speed.max then
			rightPaddle.speed.y = rightPaddle.speed.y - 2
		else
			rightPaddle.speed.y = -rightPaddle.speed.max
		end
	end
end

function update()
	updatePaddlePosition()

	-- update puck position
	if puck.isActive then
		updateActivePuckPosition()
	else
		updateInactivePuckYPosition()
	end

	if puckCollidedWithLeftGoal() then
		score.player2 = score.player2 + 1
		puck.isActive = false
		p2scored = true
		resetPuckPosition(2)
	end

	if puckCollidedWithRightGoal() then
		score.player1 = score.player1 + 1
		puck.isActive = false
		p1scored = true
		resetPuckPosition(1)
	end

	-- score detection
	if score.player1 == pointsToWin or score.player2 == pointsToWin then
		gameIsOver = true
	end
end

function updateInactivePuckYPosition()
	if p1scored then
		puck.y = leftPaddle.y + paddleHeight / 2 - puckSize / 2
		puck.x = leftPaddle.x + puckSize + 3
	elseif p2scored then
		puck.y = rightPaddle.y + paddleHeight / 2 - puckSize / 2
		puck.x = rightPaddle.x - puckSize - 3
	end
end

function gameOver() -- run when gameIsOver == true
	if score.player1 == pointsToWin then
		msg = " Bravo, Player One!\nSQUARE starts again"
	else
		msg = " Bravo, Player Two!\nSQUARE starts again"
	end

	local msg_width = print(msg, -50, -50, color, false)
	print(msg, 120 - msg_width // 2, 68-5, color, false)

	if btnp(4) then
		init()
	end
end

function updatePaddlePosition()
	-- multiplayer mode
	leftPaddle.y = leftPaddle.y + leftPaddle.speed.y

	if singlePlayer == false then
		rightPaddle.y = rightPaddle.y + rightPaddle.speed.y
	else
		rightPaddle.y = puck.y - paddleHeight // 2
	end

	-- decrease speed of paddle if speed == 0
	if leftPaddle.speed.y ~= 0 then
		if leftPaddle.speed.y > 0 then
			leftPaddle.speed.y = leftPaddle.speed.y - 1
		else
			leftPaddle.speed.y = leftPaddle.speed.y + 1
		end
	end

	if rightPaddle.speed.y ~= 0 then
		if rightPaddle.speed.y > 0 then
			rightPaddle.speed.y = rightPaddle.speed.y - 1
		else
			rightPaddle.speed.y = rightPaddle.speed.y + 1
		end
	end
end

function updateActivePuckPosition()
	puck.x = puck.x + puck.speed.x
	puck.y = puck.y + puck.speed.y
end

function resetPuckPosition(playerNumber)
	if playerNumber == 1 then
		puck.y = leftPaddle.y + paddleHeight / 2 - puckSize / 2
		puck.x = leftPaddle.x + puckSize + 3
	elseif playerNumber == 2 then
		puck.y = rightPaddle.y + paddleHeight / 2 - puckSize / 2
		puck.x = rightPaddle.x - puckSize - 3
		if singlePlayer then
			puck.isActive = true
		end
	end
end

-- <TILES>
-- 001:eccccccccc888888caaaaaaaca888888cacccccccacc0ccccacc0ccccacc0ccc
-- 002:ccccceee8888cceeaaaa0cee888a0ceeccca0ccc0cca0c0c0cca0c0c0cca0c0c
-- 003:eccccccccc888888caaaaaaaca888888cacccccccacccccccacc0ccccacc0ccc
-- 004:ccccceee8888cceeaaaa0cee888a0ceeccca0cccccca0c0c0cca0c0c0cca0c0c
-- 017:cacccccccaaaaaaacaaacaaacaaaaccccaaaaaaac8888888cc000cccecccccec
-- 018:ccca00ccaaaa0ccecaaa0ceeaaaa0ceeaaaa0cee8888ccee000cceeecccceeee
-- 019:cacccccccaaaaaaacaaacaaacaaaaccccaaaaaaac8888888cc000cccecccccec
-- 020:ccca00ccaaaa0ccecaaa0ceeaaaa0ceeaaaa0cee8888ccee000cceeecccceeee
-- </TILES>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- </WAVES>

-- <SFX>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000304000000000
-- </SFX>

-- <PALETTE>
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE>

