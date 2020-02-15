local centerX = lg.getWidth()/2
local oneThirdScreenX = lg.getWidth()/3

local damage = 3

---- Effect
local Lightning_ = Class('Lightning_')

function Lightning_:initialize(x)
	self.x = x
	self.y = 0
	
	local a = math.random(1, 4)
	if 		a == 1 then self.sprite = Sprites.lightning_1
	elseif  a == 2 then self.sprite = Sprites.lightning_2
	elseif  a == 3 then self.sprite = Sprites.lightning_3
	elseif  a == 4 then self.sprite = Sprites.lightning_4
	end
	
	self.secondsToDisappear = 0.1
	
	table.insert(Entities, self)
end

function Lightning_:Update(dt)
	self.secondsToDisappear = self.secondsToDisappear - dt
	if self.secondsToDisappear <= 0 then removevalue_pureListTable(Entities, self) end
end

function Lightning_:Draw() 
	lg.setColor(1, 1, 1, 1)
	lg.draw(self.sprite, self.x, self.y, 0, 1, 1, self.sprite:getWidth()/2) 
end


---- Spell
local Spell = require 'entities.Spell'

local Lightning = Class('Lightning', Spell)

function Lightning:initialize()
	Spell.initialize(self, 28, 'THUNDER')
	
	self.lightningLeft = 0
	self.secondsToNextLightning = 0
	self.secondsToEndCommand = 0
	
	self.commanded = false
end

function Lightning:Update(dt)
	self.currentCooldown = self.currentCooldown - dt
	
	self.secondsToEndCommand = self.secondsToEndCommand - dt
	self.secondsToNextLightning = self.secondsToNextLightning - dt
	
	if self.secondsToNextLightning <= 0 and self.lightningLeft >= 1 then
		self.lightningLeft = self.lightningLeft - 1
		self.secondsToNextLightning = 0.8
			
		local areaOffset
		local area = self.area[self.currentLightningIndex]
		if 	   area == 'left' 				  then areaOffset = 0
		elseif area == 'up' or area == 'down' then areaOffset = 1
		elseif area == 'right' 				  then areaOffset = 2
		else areaOffset = 1
		end
	
		Lightning_(areaOffset * oneThirdScreenX + oneThirdScreenX / 2 )
	
		local enemies = findEntitiesWithTag('enemy')
		for i, enemy in ipairs(enemies) do
			if areaOffset * oneThirdScreenX <= enemy.x and enemy.x <= (areaOffset + 1) * oneThirdScreenX then
				enemy:TakeDamage(damage)
			end
		end
		
		AudioManager:PlaySFX('lightning')
		
		self.currentLightningIndex = self.currentLightningIndex + 1
	end
	
	if self.secondsToEndCommand <= 0 or (self.commanded == true and self.lightningLeft <= 0) then
		Particles.rain:setEmissionRate(0)
		self.commanded = false
	end
end

function Lightning:Activate()	
	self.currentLightningIndex = 1
	self.secondsToEndCommand = 8
	self.secondsToNextLightning = 0.5
	
	Particles.rain:setEmissionRate(60)
end

function Lightning:Command(command, i)
	if self.secondsToEndCommand > 0 and #command == 3 then
		Observer:MakeCommandEvent(i)
	
		self.area = command
		
		self.lightningLeft = 3
		
		self.commanded = true
	end
end

return Lightning
