local Enemy = require 'entities.Enemy'

local Drone = Class('Drone', Enemy)

function Drone:initialize(x)
	-- Description:
	--[[
		Who let the drones out again?
		]]--

	Enemy.initialize(self, Sprites.drone, Sprites.drone_, x, 50, 1, 0.35, 0.3)
	
	self.health = 1
	self.maxHealth = 1
	self.maxSpeed = 65
end

return Drone
