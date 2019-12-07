background = {x = 0, speed = 100}
background_elems = {trees_x = 0, ground_x = 0, trees_speed = 350, ground_speed = 400}

----- GROUND CLASS
background_elems.load = function()
  background_elems.ground = love.graphics.newImage("assets/ground.jpg") --size : 25*76
  background_elems.groundNum = math.ceil(1200/25)
  background_elems.trees = love.graphics.newImage("assets/trees.png") --size : 430*280
  background_elems.treesNum = math.ceil(1200/300)
end

background_elems.update = function(dt)
  background_elems.ground_x = background_elems.ground_x + background_elems.ground_speed * dt
  background_elems.trees_x = background_elems.trees_x + background_elems.trees_speed * dt
  if background_elems.ground_x > 25 then
    background_elems.ground_x = background_elems.ground_x % 25
  end
  if background_elems.trees_x > 300 then
    background_elems.trees_x = background_elems.trees_x % 300
  end
end

background_elems.draw = function()
  for i=0,background_elems.groundNum do
    love.graphics.draw(background_elems.ground, 25*i - background_elems.ground_x, 600-76 )
  end
  for i=0,background_elems.treesNum do
    if i == 0 then
      love.graphics.draw(background_elems.trees, 300*i - background_elems.trees_x - 300, 600-75-280 )
    end
    love.graphics.draw(background_elems.trees, 300*i - background_elems.trees_x, 600-75-280 )
  end
end

----- BACKGROUND CLASS
background.update = function(dt)
  if background.x>-1200 then
    background.x = math.ceil(background.x - background.speed * dt)
  else
    background.x = 0
  end

  background_elems.update(dt)
end

background.load = function()
  background.image = love.graphics.newImage("assets/bg.jpg")
  --size : 1200*600
  background_elems.load()
end

background.draw = function()
  love.graphics.draw(background.image, background.x, 0)
  love.graphics.draw(background.image, background.x+1200, 0)

  background_elems.draw()
end
