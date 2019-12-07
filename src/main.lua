require("player")
require("background")

function love.load()
  love.window.setMode(1200,600)
  love.window.setTitle("MikuSanta Winter Game")
  background.load()
  player.load()
  print("Love Loaded")
end

function love.draw()
  background.draw()
  player.draw()
end

function love.update(dt)
  if love.keyboard.isDown("space") then
    player.jump()
  end
  background.update(dt)
  player.update(dt)
end

function love.keyreleased(key)
  if key == "escape" then
    love.window.close()
    os.exit(0)
  end
end
