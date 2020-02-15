local Player = {}

local default = Sprites.player.default
local _1 = Sprites.player._1
local _2 = Sprites.player._2
local _3 = Sprites.player._3

local x = 270

local currentSprite = 0

function Player:Update(dt)

end

function Player:Draw()
	lg.setColor(1, 1, 1, 1)
	
	local sprite
	if currentSprite == 0 then sprite = default
	elseif currentSprite == 1 then sprite = _1
	elseif currentSprite == 2 then sprite = _2
	elseif currentSprite == 3 then sprite = _3
	end
	
	lg.draw(sprite, x, 585, 0, 1, 1, sprite:getWidth()/2, sprite:getHeight()/2)
end

function Player:DoMagic(num)
	Particles.player:setPosition(270, 536)
	Particles.player:emit(num)
end

function Player:Move(x_, spriteNum)
	x = x_ or x
	currentSprite = spriteNum
end

return Player
