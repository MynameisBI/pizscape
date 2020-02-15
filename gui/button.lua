local Button = Class('Button')

function Button:initialize(x, y, w, h)
	self.x, self.y, self.w, self.h = x, y, w, h
	self.isActive = true
end

function Button:SetCommand(command, ...) 
	self.command = command 
	self.a, self.b, self.c, self.d, self.e, self.f = ...
end

function Button:Execute() self.command(self.a, self.b, self.c, self.d, self.e, self.f) end

function Button:SetActive(isActive) self.isActive = isActive end

function Button:isHover(x, y)
	if self.x <= x and x <= self.x + self.w and self.y <= y and y <= self.y + self.h and self.isActive then return true
	else return false
	end
end

function Button:_mousepressed(x, y, button)
	if self.x <= x and x <= self.x + self.w and self.y <= y and y <= self.y + self.h and self.isActive then 
		self.command(self.a, self.b, self.c, self.d, self.e, self.f) 
	end
end

return Button
