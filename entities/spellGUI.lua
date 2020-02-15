local SpellGUI = {}

local spells = GameManager.spells
local spellNum = #spells

local iconSize = 36

local secondsPerUnlockText = 1.5
local secondsToEndUnlockText = 0

local stencils = {}
for i = 0, spellNum - 1 do
	stencils[i] = function()
		lg.rectangle('fill', i*(iconSize+2), lg.getHeight() - iconSize, iconSize, iconSize)
	end
end

local newestSpell = nil

function SpellGUI:Update(dt) secondsToEndUnlockText = secondsToEndUnlockText - dt end

function SpellGUI:DrawSpellCooldown()
	for i = 0, spellNum - 1 do
		local arcValue = spells[i+1].currentCooldown / spells[i+1].cooldown
		if arcValue < 0 then arcValue = 0 end
			
		lg.stencil(stencils[i], 'replace', 1)
		lg.setStencilTest('greater', 0)
		
		if arcValue ~= 0 then lg.setColor(0.75, 0.75, 0.75, 1)
		else lg.setColor(1, 1, 1, 1)
		end
		lg.draw(Sprites.GUI.cooldown[i+1], i * (iconSize+2), lg.getHeight() - iconSize)
		
		if arcValue ~= 0 then lg.setColor(0.75, 0.75, 0.75, 0.4)
		else lg.setColor(0, 0, 0, 0)
		end
		lg.arc('fill', i*(iconSize+2) + iconSize/2, lg.getHeight() - iconSize + iconSize/2, iconSize, 
			   -math.pi/2, math.pi * 2 * (1-arcValue) - math.pi/2 )
		
		lg.setStencilTest()
	end
	
	if secondsToEndUnlockText > 0 then
		lg.setColor(1, 1, 1, 0.7)
		lg.setFont(Fonts.GUI)
		lg.print('NEW SPELL UNLOCKED', lg.getWidth()/2, 230, 0, 1, 1, 
				 Fonts.GUI:getWidth('NEW SPELL UNLOCKED')/2, Fonts.GUI:getHeight()/2)
		lg.setFont(Fonts.spell)
		lg.print(GameManager.spells[newestSpell].text, lg.getWidth()/2, 280, 0, 1, 1, 
				 Fonts.spell:getWidth(GameManager.spells[newestSpell].text)/2,
				 Fonts.spell:getHeight()/2)
	end
end

function SpellGUI.UpdateSpell(num)
	spells = GameManager.spells
	spellNum = #spells
	
	for i = 0, spellNum - 1 do
		stencils[i] = function()
			lg.rectangle('fill', i*(iconSize+2), lg.getHeight() - iconSize, iconSize, iconSize)
		end
	end
	
	secondsToEndUnlockText = secondsPerUnlockText
	newestSpell = num
	
	AudioManager:PlaySFX('unlock')
end

function SpellGUI:Reset()
	spells = GameManager.spells
	spellNum = #spells
	
	for i = 0, spellNum - 1 do
		stencils[i] = function()
			lg.rectangle('fill', i*(iconSize+2), lg.getHeight() - iconSize, iconSize, iconSize)
		end
	end
	
	secondsToEndUnlockText = 0
	
	newestSpell = nil
end

return SpellGUI
