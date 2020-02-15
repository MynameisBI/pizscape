---- Cross__
local Cross__ = Class('Cross__')

local speed_ = 136
local sprite_ = Sprites.cross_
local damage_ = 1

local centerX = lg.getWidth()/2

function Cross__:initialize(x, y, direction)
	self.x = x 
	self.y = y 

	self.direction = direction
	
	self.rotation = Vector(direction.x, direction.y):angleTo(Vector(0, -1))
	
	-- Physics
	self.body = lp.newBody(World, self.x, self.y, 'dynamic')
	self.shape = lp.newRectangleShape(sprite_:getWidth(), sprite_:getHeight())
	self.fixture = lp.newFixture(self.body, self.shape)
	self.fixture:setSensor(true)
	self.fixture:setUserData(self)
	self.body:applyLinearImpulse(direction.x * speed_, direction.y * speed_)
	
	table.insert(Entities, self)
end

function Cross__:Update(dt)
	self.x = self.body:getX()
	self.y = self.body:getY()
	
	if self.x <= -60 or self.y <= -60 then
		removevalue_pureListTable(Entities, self)
		self.body:destroy()
	end
end

function Cross__:Draw()
	lg.setColor(1, 1, 1, 1)
	lg.draw(sprite_, self.x, self.y, self.rotation, 1, 1, sprite_:getWidth()/2, sprite_:getHeight()/2)
end

function Cross__:OnCollisionEnter(fixture)
	local entity = fixture:getUserData()
	if entity.tag == 'enemy' then
		entity:TakeDamage(damage_)
		
		removevalue_pureListTable(Entities, self)
		self.body:destroy()
		
		Particles.bow:setPosition(self.x, self.y)
		Particles.bow:emit(3)
		
		AudioManager:PlaySFX('hit_'..tostring(math.random(1, 3)))
	end
end


---- Cross_
local Cross_ = Class('Cross_')

local speed = 340
local sprite = Sprites.cross
local damage = 2

function Cross_:initialize(direction, spell)
	self.x = centerX
	self.y = 550

	self.direction = direction
	
	self.rotation = Vector(direction.x, direction.y):angleTo(Vector(0, -1))
	
	self.spell = spell
	
	-- Physics
	self.body = lp.newBody(World, self.x, self.y, 'dynamic')
	self.shape = lp.newRectangleShape(sprite:getWidth(), sprite:getHeight())
	self.fixture = lp.newFixture(self.body, self.shape)
	self.fixture:setSensor(true)
	self.fixture:setUserData(self)
	self.body:applyLinearImpulse(direction.x * speed, direction.y * speed)
	
	table.insert(Entities, self)
end

function Cross_:Update(dt)
	self.x = self.body:getX()
	self.y = self.body:getY()
	
	if self.x <= -60 or self.y <= -60 then
		removevalue_pureListTable(Entities, self)
		self.body:destroy()
	end
end

function Cross_:Draw()
	lg.setColor(1, 1, 1, 1)
	lg.draw(sprite, self.x, self.y, self.rotation, 1, 1, sprite:getWidth()/2, sprite:getHeight()/2)
end

function Cross_:OnCollisionEnter(fixture, coll)
	local entity = fixture:getUserData()
	if entity.tag == 'enemy' then
		entity:TakeDamage(damage)
		
		self.spell:SetExplode(self.x - self.direction.x*34, self.y - self.direction.y*34, self.direction)
		
		removevalue_pureListTable(Entities, self)
		self.body:destroy()
		
		Particles.bow:setPosition(self.x, self.y)
		Particles.bow:emit(6)
	end
end


---- Spell
local Spell = require 'entities.Spell'

local Cross = Class('Cross', Spell)

function Cross:initialize()
	Spell.initialize(self, 2, 'CR')
	
	self.explodeCountdown = 0.05  -- It is important to not have 2 Cross_ exist at the same time
	self.secondsToExplode = 0
	self.exploded = true
	
	self.explodeX = nil
	self.explodeY = nil
	self.explodeDir = nil
end

function Cross:Activate()
	-- Find target
	local direction = Vector(0, -1)
	
	local target
	local enemies = findEntitiesWithTag('enemy')
	local maxY = -math.huge
	
	for i, enemy in ipairs(enemies) do
		if enemy.y > maxY then
			maxY = enemy.y
			target = enemy
		end
	end
	
	if target then 
		local x, y = target.x - centerX, target.y - 550
		local dist = math.sqrt(x*x + y*y)
		direction.x, direction.y = x / dist, y / dist
	end
	
	local arrow = Cross_(direction, self)
end

function Cross:SetExplode(x, y, direction)
	self.exploded = false
	self.secondsToExplode = self.explodeCountdown

	self.explodeX = x
	self.explodeY = y
	self.explodeDir = direction
end

function Cross:Update(dt)
	self.currentCooldown = self.currentCooldown - dt
	
	self.secondsToExplode = self.secondsToExplode - dt
	if self.secondsToExplode <= 0 and self.exploded == false then
		Explode(self.explodeX, self.explodeY, self.explodeDir)
		
		self.exploded = true
	end
end

function Explode(x, y, dir)
	Cross__(x, y, dir)
	
	local dirLeft = Vector(-dir.y, dir.x)
	Cross__(x, y, dirLeft)

	local dirRight = Vector(dir.y, -dir.x)	
	Cross__(x, y, dirRight)
end

return Cross
