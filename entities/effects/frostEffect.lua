local FrostEffect = Class('Frost Effect')

local speed = 580
local offsetX = 36

function FrostEffect:initialize(x, y, direction)
	if direction == 'left' then
		self.psystem = Particles_.froster_left:clone()
		self.var = -1
	
	elseif direction == 'right' then
		self.psystem = Particles_.froster_right:clone()
		self.var = 1
	end
	self.psystem:setPosition(x + offsetX * self.var, y)

	table.insert(Entities, self)
end

function FrostEffect:Update(dt)
	local x, y = self.psystem:getPosition()
	self.psystem:setPosition(x + speed * self.var * dt, y)

	self.psystem:update(dt)
	
	local x_, y_ = self.psystem:getPosition()
	if x_ <= -550 or x_ >= 1100 then
		removevalue_pureListTable(Entities, self)
	end
end

function FrostEffect:Draw()
	lg.setColor(1, 1, 1, 1)
	lg.draw(self.psystem, 0, 0)
end

return FrostEffect
