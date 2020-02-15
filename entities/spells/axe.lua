-- Axes
local Axe_ = Class('Axe_')

local sprite = Sprites.scythe
local rotateSpeed = math.pi*1.5

local speed = 200
local damage = 1

function Axe_:initialize(x, y, direction)
	self.x = x
	self.y = y
	
	self.baseRotation = Vector(direction.x, direction.y):angleTo(Vector(0, -1))
	self.rotation = self.baseRotation + math.random(0, 4)/6 * math.pi
	
	-- Physics
	self.body = lp.newBody(World, self.x, self.y, 'dynamic')
	self.shape = lp.newRectangleShape(sprite:getWidth(), sprite:getHeight())
	self.fixture = lp.newFixture(self.body, self.shape)
	self.fixture:setSensor(true)
	self.fixture:setUserData(self)
	self.body:applyLinearImpulse(direction.x * speed, direction.y * speed)
	
	table.insert(Entities, self)
end

function Axe_:Update(dt)
	self.x = self.body:getX()
	self.y = self.body:getY()
	
	self.rotation = self.rotation + rotateSpeed * dt

	if self.x <= -60 or self.y <= -60 then
		removevalue_pureListTable(Entities, self)
		self.body:destroy()
	end
end

function Axe_:Draw()
	lg.setColor(1, 1, 1, 1)
	lg.draw(sprite, self.x, self.y, self.rotation, 1, 1, sprite:getWidth()/2, sprite:getHeight()/2)
end

function Axe_:OnCollisionEnter(fixture)
	local entity = fixture:getUserData()
	if entity.tag == 'enemy' then
		entity:TakeDamage(damage)
		
		removevalue_pureListTable(Entities, self)
		self.body:destroy()
		
		Particles.scythe:setPosition(self.x, self.y)
		Particles.scythe:setDirection(self.baseRotation + math.pi/2)
		Particles.scythe:emit(8)
		
		AudioManager:PlaySFX('hit_'..tostring(math.random(1, 3)))
	end
end


---- Spell
local Spell = require 'entities.Spell'

local Axe = Class('Axe', Spell)

local centerX = lg.getWidth()/2

function Axe:initialize()
	Spell.initialize(self, 1.5, 'SC')
end

function Axe:Activate()
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

	local axe1 = Axe_(centerX-20, 570, direction)
	local axe2 = Axe_(centerX	, 550, direction)
	local axe3 = Axe_(centerX+20, 570, direction)
end


return Axe
