player = {}
player.load = function()
  player.x = 30
  player.y = 600 - 200 - 75 -- scrh - player h - ground h
  player.image = {}
  player.frame = 1
  player.timeSum = 0
  player.frameSum = 0

  player.image[1] = love.graphics.newImage("assets/player1.png")
  player.image[2] = love.graphics.newImage("assets/player2.png")

  player.ground = player.y     -- This makes the character land on the plaform.
	player.y_velocity = 0        -- Whenever the character hasn't jumped yet, the Y-Axis velocity is always at 0.
	player.jump_height = -700    -- Whenever the character jumps, he can reach this height.
	player.gravity = -1500        -- Whenever the character falls, he will descend at this rate.
end

player.draw = function()
  love.graphics.draw(player.image[player.frame], player.x, player.y)
end

player.update = function(dt)
  player.timeSum = player.timeSum + dt --full time

  if player.y_velocity ~= 0 then                                -- The game checks if player has "jumped" and left the ground.
		player.y = player.y + player.y_velocity * dt                -- This makes the character ascend/jump.
		player.y_velocity = player.y_velocity - player.gravity * dt -- This applies the gravity to the character.
  else
      -- change frame each 150ms
      if player.frameSum >= 0.15 then
        player.frame = player.frame==1 and 2 or 1
        player.frameSum = dt
      else
        player.frameSum = player.frameSum + dt
      end
	end

  -- This is in charge of collision, making sure that the character lands on the ground.
  if player.y > player.ground then    -- The game checks if the player has jumped.
    player.y_velocity = 0       -- The Y-Axis Velocity is set back to 0 meaning the character is on the ground again.
    player.y = player.ground    -- The Y-Axis Velocity is set back to 0 meaning the character is on the ground again.
  end
end

player.jump = function()
  -- The player's Y-Axis Velocity is set to it's Jump Height.
  if player.y_velocity == 0 then
    player.frame = 2
		player.y_velocity = player.jump_height
	end
end
