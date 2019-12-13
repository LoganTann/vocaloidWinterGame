elapsedTime = 0
require("player")
require("background")
require("entities")


frameCount = 0
lastTime = 0
fps = 0
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
  love.graphics.print("Vies : "..player.life, 0, 0)
  love.graphics.print(fps.." FPS", 1200 - 45, 0)
end

function love.update(dt)
  elapsedTime = elapsedTime + dt
  if love.keyboard.isDown("space") or love.mouse.isDown(1) then
    player.jump()
  end
  background.update(dt, elapsedTime)
  entities.update(dt, elapsedTime)
  player.update(dt, elapsedTime)
  if lastTime>1 then
    lastTime = 0
    fps = frameCount
    frameCount = 0
  else
    frameCount = frameCount + 1
    lastTime = lastTime+dt
  end

end

function love.keyreleased(key)
  if key == "escape" then
    love.window.close()
    os.exit(0)
  end
end



function nothing()
  return 0
end
