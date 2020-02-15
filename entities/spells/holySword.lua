---- Swords
local Sword = Class('Sword')

local speed = 600
local sprite = Sprites.sword
local damage = 2
local moveTowardsSpeed = 80

local centerX = lg.getWidth()/2

function Sword:initialize(x, y)
	self.x = x
	self.y = y
	
	self.isActivate = false
	
	self.destinationY = nil
	
	-- Physics
	self.body = lp.newBody(World, self.x, self.y, 'dynamic')
	self.shape = lp.newRectangleShape(sprite:getWidth(), sprite:getHeight())
	self.fixture = lp.newFixture(self.body, self.shape)
	self.fixture:setSensor(true)
	self.fixture:setUserData(self)
	
	table.insert(Entities, self)
end

function Sword:Update(dt)
	if self.isActivate then	
		self.x = self.body:getX()
		self.y = self.body:getY()

		if self.x <= -60 or self.y <= -60 then
			removevalue_pureListTable(Entities, self)
			self.body:destroy()
		end
	end
	
	if self.destinationY ~= nil and not self.isActivate then
		self.y = self.y - moveTowardsSpeed * dt
		self.body:setY(self.y)
		
		if self.y - self.destinationY <= 4 then self.destinationY = nil end
	end
end

function Sword:Draw()
	lg.setColor(1, 1, 1, 1)
	lg.draw(sprite, self.x, self.y, 0, 1, 1, sprite:getWidth()/2, sprite:getHeight()/2)
end

function Sword:OnCollisionEnter(fixture)
	if self.isActivate then
		local entity = fixture:getUserData()
		if entity.tag == 'enemy' then
			entity:TakeDamage(damage)
			
			removevalue_pureListTable(Entities, self)
			self.body:destroy()
			
			Particles.player:setPosition(self.x, self.y-30)
			Particles.player:emit(8)
			
			Particles.sword:setPosition(self.x, self.y)
			Particles.sword:emit(6)
			
			AudioManager:PlaySFX('hit_'..tostring(math.random(1, 3)))
		end
	end
end

function Sword:Destroy()
	if not self.body:isDestroyed() then 
		removevalue_pureListTable(Entities, self)
		self.body:destroy()
	end
end

function Sword:MoveTowards(y) self.destinationY = y end

function Sword:Activate() 
	if not self.isActivate then
		self.isActivate = true 	
		self.body:applyLinearImpulse(0, -speed)
	end
end


---- Spell
local Spell = require 'entities.Spell'

local HolySword = Class('Holy Sword', Spell)

local spawnY = 500

local spacer = 66

function HolySword:initialize()
	Spell.initialize(self, 20, 'SWORD', {'up', 'up'})
	
	self.wavesEachActivation = 3
	self.wavesLeft = 0
	self.secondsToEndCommand = 0
	self.swords = {}; for y = 1, self.wavesEachActivation do self.swords[y] = {} end
end

function HolySword:Activate()
	self.wavesLeft = self.wavesEachActivation
	self.secondsToEndCommand = 8
	
	-- Spawn swords
	for y = 1, self.wavesEachActivation do
		for x = 1, 7 do self.swords[y][x] = Sword(x * spacer + (centerX - spacer*4) + math.random(-10, 10), y * spacer + spawnY) end
	end 
end

function HolySword:Command(command, i)
	if comparetable_shallow(command, self.command) then
		Observer:MakeCommandEvent(i)
	
		-- Activate swords
		if self.secondsToEndCommand > 0 and self.wavesLeft >= 1 then
			for x = 1, 7 do self.swords[self.wavesEachActivation - self.wavesLeft + 1][x]:Activate() end
			
			self.wavesLeft = self.wavesLeft - 1
			
			for y = self.wavesEachActivation - self.wavesLeft + 1, self.wavesEachActivation do
				for x = 1, 7 do
					self.swords[y][x]:MoveTowards(y * spacer + spawnY - (self.wavesEachActivation - self.wavesLeft) * spacer)
				end
			end			
		end
	end
end

function HolySword:Update(dt)
	self.currentCooldown = self.currentCooldown - dt
	
	self.secondsToEndCommand = self.secondsToEndCommand - dt
	if self.secondsToEndCommand <= 0 then
		for y = 1, self.wavesEachActivation do
			for x = 1, 7 do 
				if self.swords[y][x] ~= nil then
					if self.swords[y][x].isActivate == false then self.swords[y][x]:Destroy() end
				end
			end
		end 
	end
end

return HolySword
