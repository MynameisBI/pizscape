local GameManager = {}

local halfScreenX = lg.getWidth()/2

----!! SCORE !!-------------------------------------------------------------------------------------
local score = 0

function GameManager:EarnScore(score_)
	score = score + score_
end

function GameManager:GetScore() return score end

----!! LIVES !!-------------------------------------------------------------------------------------
local maxLives = 20
local currentLives = 2

function GameManager:LoseLives(lives)
	currentLives = currentLives - lives
	
	if currentLives <= 0 then
		currentLives = 0
	
		Lost()
		
		AudioManager:PlaySFX('lost')
		
		if score > highscore then
			love.filesystem.write('data.txt', tostring(score))
			highscore = tonumber( love.filesystem.read('data.txt') )
		end
		
	else
		AudioManager:PlaySFX('loseLives')
	end
end

function GameManager:GetLives() return currentLives end


----!! SPELLS !!------------------------------------------------------------------------------------
-- Take Input
local spell = ''
local command = {}

local characterKey = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
				  	   'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z' }		 
local arrowKey = { 'up', 'down', 'left', 'right' }
local commandKey = { 'space', 'return', 'backspace' }

local spaceWidth_arrow = 5

local backspaceDelay = 0.5
local d_secondsToBackspace = 0.3
local backspaceInterval = 0.05
local i_secondsToBackspace = 0.05

function GameManager:TakeInput(key)
	local type_ = CheckType(key)
	
	if type_ == 'character' then 
		spell = spell..key:upper()
		
		local x = halfScreenX + ( Fonts.spell:getWidth(spell) - Fonts.spell:getWidth(spell:sub(#spell, #spell)) )/2
		Particles.spellText:setPosition(x, 400 - 8)
		Particles.spellText:emit(math.random(5, 8))
		
		Player:Move(x, math.random(1, 3))
		
		AudioManager:PlaySFX('character')
		
		Observer:TextInputEvent(spell)
	
	elseif type_ == 'arrow' then
		table.insert(command, key)
		
		local x = halfScreenX - ((#command - 1)/2) * (spaceWidth_arrow + 37) + (#command-1) * (spaceWidth_arrow + 37)
		Particles.spellText:setPosition(x, 440 - 7)
		Particles.spellText:emit(math.random(5, 8))
		
		Player:Move(x, math.random(1, 3))
	
		AudioManager:PlaySFX('arrow')
		
		Observer:CommandInputEvent(command)
	
	elseif type_ == 'command' then
		if key == 'return' then
			local isRight = UseSpell(spell)
			
			spell = ''
			
			Player:Move(270, 0)
			
			if isRight then AudioManager:PlaySFX('castSpell')
			else AudioManager:PlaySFX('error')
			end
		
		elseif key == 'space' then
			CommandSpell(command)
			command = {}
			
			Player:Move(270, 0)
			
			AudioManager:PlaySFX('castSpell')
		
		elseif key == 'backspace' then
			spell = spell:sub(1, #spell-1)
			Player:Move(nil, 0)
			
			AudioManager:PlaySFX('castSpell')
			
		end
	end
end

function GameManager:UpdateInput(dt)
	if lk.isDown('backspace') then
		d_secondsToBackspace = d_secondsToBackspace - dt
		i_secondsToBackspace = i_secondsToBackspace - dt
	else
		d_secondsToBackspace = backspaceDelay
		i_secondsToBackspace = backspaceInterval
	end
	
	if d_secondsToBackspace <= 0 and i_secondsToBackspace <= 0 then 
		spell = spell:sub(1, #spell -1) 
		
		i_secondsToBackspace = backspaceInterval
	end
end

function CheckType(key)
	for i, key_ in ipairs(characterKey) do
		if key_ == key then return 'character' end
	end
	
	for i, key_ in ipairs(arrowKey) do
		if key_ == key then return 'arrow' end
	end
	
	for i, key_ in ipairs(commandKey) do 
		if key_ == key then return 'command' end
	end
end

-- Execute Spells
local Bow 		= require 'entities.spells.bow'
local Axe 		= require 'entities.spells.axe'
local HolySword = require 'entities.spells.holySword'
local Froster   = require 'entities.spells.froster'
local Cross 	= require 'entities.spells.cross'
local Lightning = require 'entities.spells.lightning'

local allSpells = { Bow(), Axe(), Cross(), Froster(), HolySword(), Lightning(), }
GameManager.spells = { Bow() }

function GameManager:UpdateSpell(dt) for i, spell in ipairs(self.spells) do spell:Update(dt) end end

function GameManager:AddSpell(num) table.insert(self.spells, allSpells[num]) end

function UseSpell(spellText) 
	for i, spell in ipairs(GameManager.spells) do
		if spellText == spell.text then
			spell:Use()
			
			Observer:SkillUseEvent(i)
			
			return true
		end
	end
end

function CommandSpell(command)
	for i, spell in ipairs(GameManager.spells) do 
		if spell.Command ~= nil then
			spell:Command(command, i)
		end
	end
end


----!! GUI !!---------------------------------------------------------------------------------------
function GameManager:DrawGUI()
	-- Characters
	lg.setColor(1, 1, 1, 1)
	lg.setFont(Fonts.spell)
	lg.print(spell, halfScreenX, 400, 0, 1, 1, Fonts.spell:getWidth(spell)/2, Fonts.spell:getHeight()/2)
	
	-- Arrows
	lg.setColor(1, 1, 1, 1)
	for i, arrow in ipairs(command) do
		local x = halfScreenX - ((#command - 1)/2) * (spaceWidth_arrow + 37) + (i-1) * (spaceWidth_arrow + 37)
		if 	   arrow == 'up' 	then lg.draw(Fonts.arrows.up, x, 440, 0, 1, 1, 18, 18)
		elseif arrow == 'down'  then lg.draw(Fonts.arrows.down, x, 440, 0, 1, 1, 18, 18)
		elseif arrow == 'left'  then lg.draw(Fonts.arrows.left, x, 440, 0, 1, 1, 18, 18)
		elseif arrow == 'right' then lg.draw(Fonts.arrows.right, x, 440, 0, 1, 1, 18, 18)
		end
	end
end

function GameManager:Reset()
	score = 0
	currentLives = 20
	self.spells = { Bow() }
end

return GameManager
