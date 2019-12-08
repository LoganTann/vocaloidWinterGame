require("player")
require("background")
require("entities")

elapsedTime = 0

function love.load()
  love.window.setMode(1200,600)
  love.window.setTitle("MikuSanta Winter Game")
  background.load()
  entities.load()
  player.load()
  print("Love Loaded")
end

function love.draw()
  background.draw()
  entities.draw()
  player.draw()
end

function love.update(dt)
  elapsedTime = elapsedTime + dt
  if love.keyboard.isDown("space") then
    player.jump()
  end
  background.update(dt)
  entities.update(dt, elapsedTime)
  player.update(dt, elapsedTime)
end

function love.keyreleased(key)
  if key == "escape" then
    love.window.close()
    os.exit(0)
  end
end
