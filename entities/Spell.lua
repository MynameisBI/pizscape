local Spell = Class('Spell')

function Spell:initialize(cooldown, text, command)
	self.tag = 'spell'
	
	self.cooldown = cooldown
	self.currentCooldown = 0
	
	self.text = text
	self.command = command
end

function Spell:Use(...)
	if self.currentCooldown <= 0 then
		self.currentCooldown = self.cooldown
		
		self:Activate(...)
		
		Player:DoMagic(22)
		
	else
		print("can't use spell, spell on cooldown")
	end
end

function Spell:Activate() end

function Spell:Command() end

function Spell:Update(dt)
	self.currentCooldown = self.currentCooldown - dt
end

return Spell
