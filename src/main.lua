elapsedTime = 0
playing = false
require("player")
require("background")
require("entities")

bestScore = 0
lifeSprite = nil

function love.load()
  love.window.setMode(1200,600)
  love.window.setTitle("MikuSanta Winter Game")
  love.window.setVSync(-1)
  love.graphics.setNewFont("assets/PatrickHandSC-Regular.ttf", 40)
  lifeSprite = love.graphics.newImage("assets/life.png")
  background.load()
  entities.load()
  player.load()
  print("Love Loaded")
end

function love.draw()
  background.draw()
  entities.draw()
  player.draw()
  if playing then
    for i=1,player.life do
      love.graphics.draw(lifeSprite, -15 + 30 * i, 15)
    end
    love.graphics.printf("Score : "..math.ceil(background_elems.elaspedDistance * 0.003), 0, 0, 1200, "center")
  else
    love.graphics.printf("Best Score : "..bestScore, 0, 0, 1200, "center")
    love.graphics.printf("Jump to start !", 0, 50, 1200, "center")
  end
end

function love.update(dt)
  elapsedTime = elapsedTime + dt
  if love.keyboard.isDown("space") or love.mouse.isDown(1) then
    player.jump()
    if not playing then
      resetGame()
    end
  end
  background.update(dt)
  entities.update(dt)
  player.update(dt)
end

function love.keyreleased(key)
  if key == "escape" then
    love.window.close()
    os.exit(0)
  elseif key=="return" then
    resetGame()
  end
end

function resetGame()
  playing = true
  elapsedTime = 0
  player.reset()
  entities.reset()
  background.reset()
end

function onGameOver()
  if playing and background_elems.elaspedDistance * 0.003 > bestScore then
    bestScore = math.ceil(background_elems.elaspedDistance * 0.003)
    playing = false
  end
end
