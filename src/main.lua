require("player")
require("background")
require("entities")

function love.load()
  -- Var
  elapsedTime = 0
  playing = false
  firstTime = true
  bestScore = 0
  titleAlpha = 1
  scaleParams = { scale = 1, translate = {x=0, y=0} }
  lifeSprite = love.graphics.newImage("assets/life.png")
  logo = love.graphics.newImage("assets/logo.png")
  logo:setFilter("nearest", "nearest")

  -- Win Config
  window = love.graphics.newCanvas(1200, 600)
  checksize( love.graphics.getWidth(), love.graphics.getHeight() )
  love.graphics.setNewFont("assets/PatrickHandSC-Regular.ttf", 40)

  -- Load save
  if love.filesystem.getInfo("savedata.txt") then
    local file = love.filesystem.read("savedata.txt")
    local save = tonumber(file)
    if type(save)=="number" then
      bestScore = save
    end
  end

  -- Core init
  background.load()
  entities.load()
  player.load()
end

function love.draw()
  love.graphics.setCanvas(window)
    love.graphics.clear()
    background.draw()
    entities.draw()
    player.draw()
    if playing then
      for i=1,player.life do
        love.graphics.draw(lifeSprite, -15 + 30 * i, 15)
      end
      love.graphics.printf({{1,1,1,titleAlpha},"Score : "..math.ceil(background_elems.elaspedDistance * 0.003)}, 0, 0, 1200, "center")
    else
      love.graphics.setColor(255, 255, 255, titleAlpha)
      love.graphics.printf("Best Score : "..bestScore, 0, 0, 1200, "center")
      love.graphics.printf("Jump to start !", 0, 40, 1200, "center")
      love.graphics.draw(logo, 1200*0.5, 100, 0.2 * math.sin(elapsedTime), 1.5, 1.5, 300*0.5, 0)
      love.graphics.setColor(255, 255, 255, 1)
    end
  love.graphics.setCanvas()
  love.graphics.draw(window, scaleParams.translate.x, scaleParams.translate.y, 0, scaleParams.scale, scaleParams.scale)
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
    love.event.quit()
  end
end

function love.resize(w,h)
  checksize(w,h)
end

-------------------- No-Love Events

function resetGame()
  playing = true
  elapsedTime = 0
  player.reset()
  entities.reset()
  background.reset()
end

function onGameOver(dt)
  if playing then
    if background_elems.elaspedDistance * 0.003 > bestScore then
      bestScore = math.ceil(background_elems.elaspedDistance * 0.003)
      love.filesystem.write("savedata.txt", bestScore)
    end
    playing = false
    firstTime = false
  end
  if titleAlpha<1 then
    titleAlpha = titleAlpha + dt
    if titleAlpha>1 then
      titleAlpha = 1
    end
  end
end

function checksize(w,h)
  if w~=1200 and h~=600 then
    local s = math.min(w/1200,h/600)
    local sw = s * 1200
    local sh = s * 600

    scaleParams.translate.x = w/2 - sw/2
    scaleParams.translate.y = h/2 - sh/2
    scaleParams.scale = s
  end
end
