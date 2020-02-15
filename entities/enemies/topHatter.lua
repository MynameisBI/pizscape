local Enemy = require 'entities.Enemy'

local TopHatter = Class('Jazzer', Enemy)

function TopHatter:initialize(x)
	-- Description:
	--[[
		Like a true gentleman he is
		]]--

	Enemy.initialize(self, Sprites.topHatter, Sprites.topHatter_, x, 200, 1)
	
	self.health = 4
	self.maxHealth = 4
	self.maxSpeed = 44
end

return TopHatter
