local Score = require 'entities.effects.score'
local Corpse = require 'entities.effects.corpse'

local Enemy = Class('Enemy')

function Enemy:initialize(sprite, corpseSprite, x, score, damage, secondsPerFrame, corpseExistTime, isKingpin)
	self.x = x
	if not isKingpin then self.y = -40; self.isKingpin = false
	else self.y = -55; self.isKingpin = true
	end
	
	self.score = score
	
	self.sprite = sprite
	
	self.damage = damage or 1
	self.maxHealth = 1
	self.health = 1
	
	self.maxSpeed = 100
	self.currentSpeed = 100
	self.slowEffect = nil
	
	self.secondsToEndSlow = 0
	
	-- Physics
	self.body = lp.newBody(World, self.x, self.y)
	self.shape = lp.newRectangleShape(self.sprite:getWidth()/2, self.sprite:getHeight())
	self.fixture = lp.newFixture(self.body, self.shape)
	self.fixture:setSensor(true)
	self.fixture:setUserData(self)
	
	table.insert(Entities, self)
	self.tag = 'enemy'
	
	-- Animation
	self.quads = {}
	
	self.secondsToNextFrame = 0
	self.secondsPerFrame = secondsPerFrame or 0.5
	self.currentFrame = 1
	self.frameNum = 2
	
	self.isDead = false
	
	local w, h = sprite:getWidth(), sprite:getHeight()
	for x = 0, w/self.frameNum, w/self.frameNum do
		table.insert(self.quads, lg.newQuad(x, 0, w/self.frameNum, h, w, h))
	end
	
	self.corpseSprite = corpseSprite
	self.corpseExistTime = corpseExistTime
end

function Enemy:Update(dt)
	self.currentSpeed = self.maxSpeed
	self.secondsToEndSlow = self.secondsToEndSlow - dt
	if self.secondsToEndSlow > 0 then
		self.currentSpeed = self.maxSpeed * self.slowEffect		
	end

	self.y = self.y + self.currentSpeed * dt
	self.body:setPosition(self.x, self.y)
	
	if self.y >= 650 then 
		GameManager:LoseLives(self.damage) 
		removevalue(Entities, self)
	end
	
	self.secondsToNextFrame = self.secondsToNextFrame - dt
	if self.secondsToNextFrame <= 0 then
		self.secondsToNextFrame = self.secondsPerFrame
		self.currentFrame = self.currentFrame + 1
		if self.currentFrame > self.frameNum then self.currentFrame = 1 end
	end
end

function Enemy:Draw()
	lg.setColor(1, 1, 1, 1)
	lg.draw( self.sprite, self.quads[self.currentFrame], self.x, self.y, 0, 1, 1,
		     self.sprite:getWidth()/(self.frameNum*2), self.sprite:getHeight() )
	
	lg.setColor(0.2, 0.2, 0.2, 0.64)
	lg.line(self.x -self.sprite:getWidth()/6 -2, self.y -self.sprite:getHeight()*0.44 -21,
			self.x +self.sprite:getWidth()/6 +2, self.y -self.sprite:getHeight()*0.44 -21)
	local x_ = (self.sprite:getWidth()*2/5 + 8) * (self.health / self.maxHealth) 
	lg.setColor(1, 1, 1, 0.86)
	lg.line(self.x -self.sprite:getWidth()/5 -4, self.y -self.sprite:getHeight()*0.44 -21,
			self.x -self.sprite:getWidth()/5 -4 + x_, self.y -self.sprite:getHeight()*0.44 -21)
end

function Enemy:TakeDamage(damage)
	self.health = self.health - damage
	if self.health <= 0 then
		removevalue_pureListTable(Entities, self)
		self.body:destroy()
		
		GameManager:EarnScore(self.score)
		
		Corpse(self.corpseSprite, self.x, self.y, self.corpseExistTime)
		Score(self.x, self.y, self.score)
		
		AudioManager:PlaySFX('death_'..tostring(math.random(1, 4)))
		
		if self.isKingpin then Spawner:isKingpinDestroyed(true) end
	end
end

function Enemy:Slow(effect, duration)
	self.slowEffect = effect
	self.secondsToEndSlow = duration
end

return Enemy
