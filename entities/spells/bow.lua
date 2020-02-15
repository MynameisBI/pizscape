---- Arrow
local Arrow = Class('Arrow')

local speed = 260
local sprite = Sprites.arrow
local damage = 1

local centerX = lg.getWidth()/2

function Arrow:initialize()
	self.x = centerX
	self.y = 550

	-- Find target
	local direction = {x = 0, y = -1}
	
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
		local x, y = target.x - self.x, target.y - self.y
		local dist = math.sqrt(x*x + y*y)
		direction.x, direction.y = x / dist, y / dist
	end
	
	self.rotation = Vector(direction.x, direction.y):angleTo(Vector(0, -1))
	
	-- Physics
	self.body = lp.newBody(World, self.x, self.y, 'dynamic')
	self.shape = lp.newRectangleShape(sprite:getWidth(), sprite:getHeight())
	self.fixture = lp.newFixture(self.body, self.shape)
	self.fixture:setSensor(true)
	self.fixture:setUserData(self)
	self.body:applyLinearImpulse(direction.x * speed, direction.y * speed)
	
	table.insert(Entities, self)
end

function Arrow:Update(dt)
	self.x = self.body:getX()
	self.y = self.body:getY()
	
	if self.x <= -60 or self.y <= -60 then
		removevalue_pureListTable(Entities, self)
		self.body:destroy()
	end
end

function Arrow:Draw()
	lg.setColor(1, 1, 1, 1)
	lg.draw(sprite, self.x, self.y, self.rotation, 1, 1, sprite:getWidth()/2, sprite:getHeight()/2)
end

function Arrow:OnCollisionEnter(fixture)
	local entity = fixture:getUserData()
	if entity.tag == 'enemy' then
		entity:TakeDamage(damage)
		
		removevalue_pureListTable(Entities, self)
		self.body:destroy()
		
		Particles.bow:setPosition(self.x, self.y)
		Particles.bow:emit(8)
		
		AudioManager:PlaySFX('hit_'..tostring(math.random(1, 3)))
	end
end


---- Spell
local Spell = require 'entities.Spell'

local Bow = Class('Bow', Spell)

function Bow:initialize()
	Spell.initialize(self, 0.75, 'A')
end

function Bow:Activate()
	local arrow = Arrow()
end


return Bow
