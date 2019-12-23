player = {}
player.load = function()
  player.reset()
  player.x = 30
  player.y = 600 - 200 - 75 -- scrh - player h - ground h
  player.image = {}
  player.frame = 1
  player.changeFrameAt = 0
  player.image[1] = love.graphics.newImage("assets/player1.png")
  player.image[2] = love.graphics.newImage("assets/player2.png")
  player.ground = player.y     -- This makes the character land on the plaform.
	player.y_velocity = 0        -- Whenever the character hasn't jumped yet, the Y-Axis velocity is always at 0.
	player.jump_height = -600    -- Whenever the character jumps, he can reach this height.
	player.gravity = -1500        -- Whenever the character falls, he will descend at this rate.
  player.damageSnd = love.audio.newSource("assets/Damage.wav", "static")
  player.jmpSnd = love.audio.newSource("assets/jump.wav", "static")
end

player.reset = function()
  player.show = true
  player.changeFrameAt = 0
  player.frame = 1
  player.gameOver = false
  player.life = 3
  player.quitTime = -1
  if not firstTime then
    player.x = -240
  end
end

player.draw = function()
  if player.show then
    love.graphics.draw(player.frame and player.image[2] or player.image[1], player.x, player.y)
  end
end

player.update = function(dt)
  if player.y_velocity ~= 0 then                                -- The game checks if player has "jumped" and left the ground.
		player.y = player.y + player.y_velocity * dt                -- This makes the character ascend/jump.
		player.y_velocity = player.y_velocity - player.gravity * dt -- This applies the gravity to the character.
  else
      if player.changeFrameAt<elapsedTime then
        player.frame = not player.frame
        player.changeFrameAt = elapsedTime+0.15
      end
	end

  if player.x < 30 then
    player.x = player.x + 100*dt
  end

  if player.blink then
    player.show = elapsedTime*10 %2 > 1 --if 10^-1 is pair => change each 100 ms
    if elapsedTime > player.blinkEnd then
      player.blink = false
      player.show = true
    end
  end


  if player.gameOver then
    if player.quitTime <= 0 then
      player.y_velocity = player.jump_height * 0.7
      player.quitTime = elapsedTime + 2
    elseif elapsedTime > player.quitTime then
      onGameOver(dt)
    else
      titleAlpha = titleAlpha - dt
    end
  elseif player.y > player.ground then
    player.y_velocity = 0       -- The Y-Axis Velocity is set back to 0 meaning the character is on the ground again.
    player.y = player.ground    -- The Y-Axis Velocity is set back to 0 meaning the character is on the ground again.
  end
end

player.jump = function()
  -- The player's Y-Axis Velocity is set to it's Jump Height.
  if player.y_velocity == 0 then
    player.frame = 2
    player.y_velocity = player.jump_height
	player.jmpSnd:play()
  elseif player.y_velocity>-750 then
    player.y_velocity = player.y_velocity - 11
  end
end

player.hurt = function()
  player.life = player.life - 1
  if player.life <=0 then
    player.gameOver = true
  end
  player.blink = true
  player.blinkEnd = elapsedTime + 1.5
  player.damageSnd:play()
end

player.hitbox = {left=140, top=20, right=197, bottom=197}

player.hit = function(obj, obj_x, obj_y)
  return (not player.blink) and
      player.x + player.hitbox.right > obj_x + obj.hitbox.left and
      player.x + player.hitbox.left < obj_x + obj.hitbox.right and
      player.y + player.hitbox.bottom > obj_y + obj.hitbox.top and
      player.y + player.hitbox.top < obj_y + obj.hitbox.bottom
end
