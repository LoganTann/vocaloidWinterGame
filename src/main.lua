elapsedTime = 0
playing = false
require("player")
require("background")
require("entities")

bestScore = 0
lifeSprite = nil
logo = nil
firstTime = true

function love.load()
  love.window.setMode(1200,600)
  love.window.setTitle("MikuSanta Winter Game")
  love.window.setVSync(-1)
  love.graphics.setNewFont("assets/PatrickHandSC-Regular.ttf", 40)
  lifeSprite = love.graphics.newImage("assets/life.png")
  logo = love.graphics.newImage("assets/logo.png")
  logo:setFilter("nearest", "nearest")
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
    love.graphics.printf("Jump to start !", 0, 40, 1200, "center")
    love.graphics.draw(logo, 1200*0.5, 100, 0, 1.5, 1.5, 300*0.5, 0)
  end
end

function love.update(dt)
  elapsedTime = elapsedTime + dt
  if love.keyboard.isDown("space") or love.mouse.isDown(1) then
    if not playing then
      resetGame()
    end
    player.jump(firstTime)
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
  if playing then
    if background_elems.elaspedDistance * 0.003 > bestScore then
      bestScore = math.ceil(background_elems.elaspedDistance * 0.003)
    end
    playing = false
    firstTime = false
  end
end
