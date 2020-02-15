local FrostEffect = require 'entities.effects.frostEffect'

---- Frost Ball
local FrostBall = Class('FrostBall')

local sprite = Sprites.frostBall
local rotateSpeed = math.pi*1.5

local speed = 340
local damage = 1
local areaY = 80

function FrostBall:initialize()
	self.x = 300
	self.y = 550

	self.rotation = 0

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
	
	-- Physics
	self.body = lp.newBody(World, self.x, self.y, 'dynamic')
	self.shape = lp.newRectangleShape(sprite:getWidth(), sprite:getHeight())
	self.fixture = lp.newFixture(self.body, self.shape)
	self.fixture:setSensor(true)
	self.fixture:setUserData(self)
	self.body:applyLinearImpulse(direction.x * speed, direction.y * speed)
	
	table.insert(Entities, self)
end

function FrostBall:Update(dt)
	self.x = self.body:getX()
	self.y = self.body:getY()

	self.rotation = self.rotation + rotateSpeed * dt
	
	if self.x <= -60 or self.y <= -60 then
		removevalue_pureListTable(Entities, self)
		self.body:destroy()
	end
end

function FrostBall:Draw()
	lg.setColor(1, 1, 1, 1)
	lg.draw(sprite, self.x, self.y, self.rotation, 1, 1, sprite:getWidth()/2, sprite:getHeight()/2)
end

function FrostBall:OnCollisionEnter(fixture)
	local entity = fixture:getUserData()
	if entity.tag == 'enemy' then
		local enemies = findEntitiesWithTag('enemy')
		local selectedEnemies = {}
		for i, enemy in ipairs(enemies) do
			if math.abs(enemy.y - self.y) <= areaY then table.insert(selectedEnemies, enemy) end
		end
	
		for i, enemy in ipairs(selectedEnemies) do
			enemy:TakeDamage(damage)
			enemy:Slow(0.5, 2)
		end
		
		removevalue_pureListTable(Entities, self)
		self.body:destroy()

		Particles.player:setPosition(self.x, self.y)
		Particles.player:emit(16)
		
		FrostEffect(self.x, self.y, 'right')
		FrostEffect(self.x, self.y, 'left')
		
		AudioManager:PlaySFX('hit_4')
	end
end


---- Spell
local Spell = require 'entities.Spell'

local Froster = Class('Froster', Spell)

function Froster:initialize()
	Spell.initialize(self, 4, 'FRZ')
end

function Froster:Activate()
	local arrow = FrostBall()
end


return Froster
