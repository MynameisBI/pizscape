local Enemy = require 'entities.Enemy'

local Jazzer = Class('Jazzer', Enemy)

function Jazzer:initialize(x)
	-- Description:
	--[[
		Ze just really likes jazz you know
		]]--

	Enemy.initialize(self, Sprites.jazzer, Sprites.jazzer_, x, 100, 1)
	
	self.health = 2
	self.maxHealth = 2
	self.maxSpeed = 50
end

return Jazzer
