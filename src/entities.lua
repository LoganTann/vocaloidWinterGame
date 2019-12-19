twoPi = 2*math.pi

-- ENTITIES DECLARATION

stone = {}
stone.load = function()
  stone.y = 446 --600-76-78
  stone.hitbox = {left = 16, top = 12, right=117, bottom=78}
  stone.image = love.graphics.newImage("assets/stone.png")
  stone.touched = player.hurt
  stone.reset = function()
    stone.list = {}
    stone.spawn = {
      interval = {1 *10, 3 *10}, -- n seconds * const=10
      ndInterval = {0.1 *10, 3 *10},
      last = 0, next = 1,
      probability = 60
    }
  end
  stone.reset()
end

crystal = {}
crystal.load = function()
  crystal.y = 446 --600-76-78
  crystal.hitbox = {left = 16, top = 12, right=70, bottom=78}
  crystal.image = love.graphics.newImage("assets/crystal.png")
  crystal.touched = player.hurt
  crystal.reset = function()
    crystal.list = {}
    crystal.spawn = {
      interval = {5 *10, 7 *10}, -- n seconds * const=10
      ndInterval = {0.1 *10, 1 *10},
      last = 0, next = 0.5,
      probability = 80
    }
  end
  crystal.reset()
end

iceBlock = {}
iceBlock.load = function()
  iceBlock.y = 0
  iceBlock.hitbox = {left = 15, top = 10, right=85, bottom=100}
  iceBlock.image = love.graphics.newImage("assets/iceBlock.png")
  iceBlock.fallSpeed = 700
  iceBlock.reset = function()
    iceBlock.list = {}
    iceBlock.spawn = {
      interval = {5 *10, 7 *10}, -- n seconds * const=10
      ndInterval = {5 *10, 7 *10},
      last = 0, next = 5,
      probability = 70
    }
  end
  iceBlock.reset()

  iceBlock.touched = function(this)
    this.touch = true
    background.faster(100)
  end
  iceBlock.update = function(this, dt)
    if this.y<426 then
      this.y = this.y + iceBlock.fallSpeed * dt
    end
  end
end

healBlock = {}
healBlock.load = function()
  healBlock.y = 0
  healBlock.hitbox = {left = 15, top = 10, right=85, bottom=100}
  healBlock.image1 = love.graphics.newImage("assets/healBox.png")
  healBlock.image2 = love.graphics.newImage("assets/heal.png")
  healBlock.image = healBlock.image1
  healBlock.reset = function()
    healBlock.list = {}
    healBlock.spawn = {
      interval = {5 *10, 7 *10}, -- n seconds * const=10
      ndInterval = {5 *10, 7 *10},
      last = 0, next = 10,
      probability = 10
    }
  end
  healBlock.reset()

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


snowman = {}
snowman.load = function()
  snowman.y = 0
  snowman.hitbox = {left = 0, top = 16, right=66, bottom=82}
  snowman.image = love.graphics.newImage("assets/SnowMan.png")
  snowman.touched = player.hurt
  snowman.reset = function()
    snowman.list = {}
    snowman.spawn = {
      interval = {5 *10, 7 *10}, -- n seconds * const=10
      ndInterval = {5 *10, 7 *10},
      last = 0, next = 1,
      probability = 50
    }
  end
  snowman.reset()

  snowman.update = function(this, dt)
    if (this.r<0) then
      -- this is init !
      this.x = 1230
      this.y = math.random(600+player.jump_height * 0.7, 600+player.jump_height)
      this.r = 0
    else
      this.r = (this.r > twoPi) and (this.r % twoPi) or (this.r + 3*dt)
    end
  end
end
-- ENTITIES LOGIC

entities = {
  maxSpawnDistance = 0,
  list = {stone, crystal, iceBlock, healBlock, snowman}
}

entities.load = function()
  for i in pairs(entities.list) do
    entities.list[i].load()
  end
end

entities.update = function(dt)
    for i,o in ipairs(entities.list) do
      entities.objUpdate(o, dt)
    end
end

entities.draw = function()
  for i,o in ipairs(entities.list) do
    entities.objDraw(o)
  end
end

entities.reset = function()
  for i in pairs(entities.list) do
    entities.list[i].reset()
  end
  entities.maxSpawnDistance = 0
end


entities.objUpdate = function(ent, dt)
  for i in pairs(ent.list) do
    o = ent.list[i]
    o.x = o.x - background_elems.ground_speed * dt
    if o.x < -124 then
      if type(ent.onDestroy)=="function" then
        ent.onDestroy()
      end
      table.remove(ent.list, i)
    elseif player.hit(ent, o.x, o.y) and (not o.touch) then
      ent.touched(o)
    elseif type(ent.update)=="function" then
      ent.update(o, dt)
    end
  end

  if elapsedTime > ent.spawn.next and background_elems.elaspedDistance > entities.maxSpawnDistance then
    if entities.objAdd(ent) then
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
    table.insert(obj.list, {x = 1200, y = obj.y, touch = false, r=-1})
    return true
  else
    return false
  end
end

entities.objDraw = function(obj)
  for i,v in ipairs(obj.list) do
    if (v.r > 0) then
      love.graphics.draw(obj.image, v.x, v.y, v.r, 1, 1, obj.image:getWidth()/2, obj.image:getHeight()/2)
    else
      love.graphics.draw(obj.image, v.x, v.y)
    end
  end
end
