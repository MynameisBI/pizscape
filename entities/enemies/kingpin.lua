local Enemy = require 'entities.Enemy'

local Kingpin = Class('Kingpin', Enemy)

function Kingpin:initialize(x, health, score)
	-- Description:
	--[[
		An overused word for bosses
		]]--

	Enemy.initialize(self, Sprites.kingpin, Sprites.kingpin_, x, score, 10, 1, 1.4, true)
	
	self.health = health
	self.maxHealth = health
	self.maxSpeed = 12
end

return Kingpin
