local Corpse = Class('Corpse')

local speedX = 70
local speedY = 70

function Corpse:initialize(sprite, x, y, existTime)
	self.x, self.y = x, y
	self.sprite = sprite
	
	self.secondsToDisappear = existTime or 0.5
	
	table.insert(Entities, self)
end

function Corpse:Update(dt)
	self.x = self.x + speedX * dt
	self.y = self.y - speedX * dt
	
	self.secondsToDisappear = self.secondsToDisappear - dt
	if self.secondsToDisappear <= 0 then removevalue_pureListTable(Entities, self) end
end

function Corpse:Draw()
	lg.setColor(0.5, 0.5, 0.5, 0.5)
	lg.draw(self.sprite, self.x, self.y, 0, 1, 1, self.sprite:getWidth()/2, self.sprite:getHeight()/2)
end

return Corpse
