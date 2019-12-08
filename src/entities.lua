-- ENTITIES DECLARATION

stone = {}
stone.load = function()
  stone.x = 1200
  stone.y = 446 --600-76-78
  stone.list = {}
  stone.pop = {
    interval = {1 *10, 3 *10}, -- n seconds * const=10
    ndInterval = {0.1 *10, 3 *10},
    last = 0,
    next = 2,
    probability = 100
  }
  stone.hitbox = {left = 16, top = 12, right=117, bottom=78}
  stone.image = love.graphics.newImage("assets/stone.png")
  stone.touched = player.hurt
end


-- ENTITIES LOGIC

entities = {}

entities.load = function()
  stone.load()
end

entities.update = function(dt, elapsedTime)
  entities.objUpdate(stone, dt, elapsedTime)
end

entities.draw = function()
  entities.objDraw(stone)
end



entities.objUpdate = function(obj, dt, elapsedTime)
  for i,v in ipairs(stone.list) do
    obj.list[i].x = v.x - background_elems.ground_speed * dt
    if obj.list[i].x < -124 then
      table.remove(obj.list, i)
    elseif player.hit(obj, obj.list[i].x, obj.list[i].y) then
      obj.touched(elapsedTime)
    end
  end

  if elapsedTime > obj.pop.next then
    entities.objAdd(obj, elapsedTime)
  end
end

entities.objAdd = function(obj, elapsedTime)
  if obj.pop.last - obj.pop.next >= 7 then
    obj.pop.next = elapsedTime + math.random(obj.pop.ndInterval[1], obj.pop.ndInterval[2]) * 0.1
  else
    obj.pop.next = elapsedTime + math.random(obj.pop.interval[1], obj.pop.interval[2]) * 0.1
  end
  obj.pop.last = elapsedTime

  if math.random(0, 100) >= 100-obj.pop.probability then
    table.insert(obj.list, {x = obj.x, y = obj.y})
  end
end

entities.objDraw = function(obj)
  for i,v in ipairs(stone.list) do
    love.graphics.draw(stone.image, v.x, v.y)
  end
end
