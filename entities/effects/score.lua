local Score = Class('Score')

local speed = 40
local existTime = 0.8

function Score:initialize(x, y, score)
	self.x, self.y, self.score = x, y, tostring(score)
	
	self.timePass = 0
	
	table.insert(Entities, self)
end

function Score:Update(dt)
	self.y = self.y - speed*dt
	
	self.timePass = self.timePass + dt
	if self.timePass >= existTime then removevalue_pureListTable(Entities, self) end
end

function Score:Draw()
	lg.setColor(1, 1, 1, 1)
	lg.setFont(Fonts.smallGUI)
	lg.print(self.score, self.x, self.y)
end

return Score
