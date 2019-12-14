-- ENTITIES DECLARATION

stone = {list = {}}
stone.load = function()
  stone.x = 1200
  stone.y = 446 --600-76-78
  stone.spawn = {
    interval = {1 *10, 3 *10}, -- n seconds * const=10
    ndInterval = {0.1 *10, 3 *10},
    last = 0, next = 1,
    probability = 60
  }
  stone.hitbox = {left = 16, top = 12, right=117, bottom=78}
  stone.image = love.graphics.newImage("assets/stone.png")
  stone.touched = player.hurt
  stone.update = nothing
  stone.onDestroy = nothing
end

crystal = {list = {}}
crystal.load = function()
  crystal.x = 1200
  crystal.y = 446 --600-76-78
  crystal.spawn = {
    interval = {5 *10, 7 *10}, -- n seconds * const=10
    ndInterval = {0.1 *10, 1 *10},
    last = 0, next = 0.5,
    probability = 80
  }
  crystal.hitbox = {left = 16, top = 12, right=70, bottom=78}
  crystal.image = love.graphics.newImage("assets/crystal.png")
  crystal.touched = player.hurt
  crystal.update = nothing
  crystal.onDestroy = nothing
end

iceBlock = {list = {}}
iceBlock.load = function()
  iceBlock.x = 1200
  iceBlock.y = 0
  iceBlock.spawn = {
    interval = {5 *10, 7 *10}, -- n seconds * const=10
    ndInterval = {5 *10, 7 *10},
    last = 0, next = 5,
    probability = 70
  }
  iceBlock.hitbox = {left = 15, top = 10, right=85, bottom=100}
  iceBlock.image = love.graphics.newImage("assets/iceBlock.png")
  iceBlock.touched = function(this)
    this.touch = true
    background.faster(100)
  end
  iceBlock.fallSpeed = 700
  iceBlock.update = function(this, dt)
    if this.y<426 then
      this.y = this.y + iceBlock.fallSpeed * dt
    end
  end
  iceBlock.onDestroy = nothing
end

healBlock = {list = {}}
healBlock.load = function()
  healBlock.x = 1200
  healBlock.y = 0
  healBlock.spawn = {
    interval = {5 *10, 7 *10}, -- n seconds * const=10
    ndInterval = {5 *10, 7 *10},
    last = 0, next = 5,
    probability = 10
  }
  healBlock.hitbox = {left = 15, top = 10, right=85, bottom=100}
  healBlock.image1 = love.graphics.newImage("assets/healBox.png")
  healBlock.image2 = love.graphics.newImage("assets/heal.png")
  healBlock.image = healBlock.image1
  healBlock.touched = function(this)
    this.touch = true
    player.life = player.life + 1
  end
  healBlock.update = function(this, dt)
    if this.touch then
      healBlock.image = healBlock.image2
      this.y = this.y - iceBlock.fallSpeed * dt * 1.5
    elseif this.y<426 then
      this.y = this.y + iceBlock.fallSpeed * dt
    end
  end
  healBlock.onDestroy = function()
    healBlock.image = healBlock.image1
  end
end

-- ENTITIES LOGIC

entities = {
  maxSpawnDistance = 0,
  list = {stone, crystal, iceBlock, healBlock}
}

entities.load = function()
  for i,v in ipairs(entities.list) do
    v.load()
    print("load")
  end
end

entities.update = function(dt)
    for i,v in ipairs(entities.list) do
      entities.objUpdate(v, dt)
    end
end

entities.draw = function()
    for i,v in ipairs(entities.list) do
      entities.objDraw(v)
    end
end

entities.objUpdate = function(obj, dt)
  for i,v in ipairs(obj.list) do
    obj.list[i].x = v.x - background_elems.ground_speed * dt
    if obj.list[i].x < -124 then
      obj.onDestroy()
      table.remove(obj.list, i)
    elseif player.hit(obj, obj.list[i].x, obj.list[i].y) and (not obj.list[i].touch) then
      obj.touched(obj.list[i])
    else
      obj.update(obj.list[i], dt)
    end
  end

  if elapsedTime > obj.spawn.next and background_elems.elaspedDistance > entities.maxSpawnDistance then
    if entities.objAdd(obj) then
      if math.random()>0.5 then --50 percents of chances to spawn between 50 and 100px
        entities.maxSpawnDistance = background_elems.elaspedDistance + math.random(5, 10)*10
      else -- 50% chances 350-500
        entities.maxSpawnDistance = background_elems.elaspedDistance + math.random(35, 50)*10
      end
    end
  end
end

entities.objAdd = function(obj)
  if obj.spawn.last - obj.spawn.next >= 7 then
    obj.spawn.next = elapsedTime + math.random(obj.spawn.ndInterval[1], obj.spawn.ndInterval[2]) * 0.1
  else
    obj.spawn.next = elapsedTime + math.random(obj.spawn.interval[1], obj.spawn.interval[2]) * 0.1
  end
  obj.spawn.last = elapsedTime

  if math.random(0, 100) >= 100-obj.spawn.probability then
    table.insert(obj.list, {x = obj.x, y = obj.y, touch = false})
    return true
  else
    return false
  end
end

entities.objDraw = function(obj)
  for i,v in ipairs(obj.list) do
    love.graphics.draw(obj.image, v.x, v.y)
  end
end
