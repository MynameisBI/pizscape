local Button = require 'gui.button'

local Game = {}

Entities = {}

-- Pause
local paused = false
local pauseButton = Button(lg.getWidth() - 26, 3, 23, 23)
local resumeButton = Button(185, 246, 163, 30); resumeButton:SetActive(false)
local restartButton = Button(180, 246, 168, 30); restartButton:SetActive(false)
local mainMenuButton = Button(141, 296, 254, 30); mainMenuButton:SetActive(false)
function Pause()
	paused = true
	pauseButton:SetActive(false)
	
	mainMenuButton:SetActive(true)
	resumeButton:SetActive(true)
	
	AudioManager:PauseMusic()
end
function Resume()
	paused = false
	pauseButton:SetActive(true)
	
	mainMenuButton:SetActive(false)
	resumeButton:SetActive(false)
	
	AudioManager:PlayMusic()
end
function MainMenu()
	Gamestate.switch(Menu, data)
end
function Restart()
	Gamestate.switch(Game, data)
end
pauseButton:SetCommand(Pause)
mainMenuButton:SetCommand(MainMenu)
resumeButton:SetCommand(Resume)
restartButton:SetCommand(Restart)

pauseMenuButtons = { resumeButton, mainMenuButton }
lostMenuButtons = { restartButton, mainMenuButton }
hoveredButtonIndex = 1

function Lost()
	paused = true
	pauseButton:SetActive(false)
	
	mainMenuButton:SetActive(true)
	restartButton:SetActive(true)
	
	AudioManager:PauseMusic()
end

function Game:init()
	
end

function Game:enter()
	World = lp.newWorld(0, 0, true)
	World:setCallbacks(_beginContact)

	Entities = {}
	table.insert(Entities, Spawner)
	
	AudioManager:PlayMusic('mainTheme')
	
	Resume()
	
	GameManager:Reset()
	Spawner:Reset()
	SpellGUI:Reset()
	
	Observer:SkillUnlockEvent(1)
end

function Game:update(dt)
	if paused then return end
	
	World:update(dt)

	GameManager:UpdateInput(dt)
	GameManager:UpdateSpell(dt)

	AudioManager:Update(dt)

	SpellGUI:Update(dt)

	Observer:Update(dt)

	for k, psystem in pairs(Particles) do psystem:update(dt) end

	for i, entity in ipairs(Entities) do
		if entity.Update then entity:Update(dt) end
	end
end

function Game:draw()
	-- Draw ground
	lg.setColor(1, 1, 1, 1)
	lg.line(-2, 594, 236, 594)
	lg.line(252, 594, 542, 594)
	lg.line(-2, 600, 424, 600)
	lg.line(440, 600, 542, 600)
	lg.setColor(0, 0, 0, 1)
	local l = #GameManager.spells
	lg.rectangle('fill', 0, lg.getHeight()-36, l * 36 + (l - 1) * 2, 36)

	for i, entity in ipairs(Entities) do
		if entity.Draw then entity:Draw() end
	end
	
	lg.setColor(1, 1, 1, 1)
	for k, psystem in pairs(Particles) do lg.draw(psystem, 0, 0) end
	
	Player:Draw()
	
	GameManager:DrawGUI()
	
	Observer:Draw()
	
	SpellGUI:DrawSpellCooldown()
	
	InfoGUI:DrawGUI()
	
	lg.setColor(1, 1, 1, 1)
	lg.draw(Sprites.GUI.pause, lg.getWidth() - 25, 4)
	
	if paused then
		lg.setColor(0, 0, 0, 0.4)
		lg.rectangle('fill', 0, 0, lg.getWidth(), lg.getHeight())
		
		if resumeButton.isActive then
			lg.setFont(Fonts.Menu_2)
			if pauseMenuButtons[hoveredButtonIndex] == resumeButton then
				lg.setColor(1, 1, 1, 1)
				lg.print('RESUME', lg.getWidth()/2, 250, 0, 1, 1, Fonts.Menu_2:getWidth('RESUME')/2)
				lg.setColor(0.72, 0.72, 0.72, 1)
				lg.print('MAIN MENU', lg.getWidth()/2, 300, 0, 1, 1, Fonts.Menu_2:getWidth('MAIN MENU')/2)
				
			elseif pauseMenuButtons[hoveredButtonIndex] == mainMenuButton then
				lg.setColor(0.72, 0.72, 0.72, 1)
				lg.print('RESUME', lg.getWidth()/2, 250, 0, 1, 1, Fonts.Menu_2:getWidth('RESUME')/2)
				lg.setColor(1, 1, 1, 1)
				lg.print('MAIN MENU', lg.getWidth()/2, 300, 0, 1, 1, Fonts.Menu_2:getWidth('MAIN MENU')/2)
			
			end
			
		elseif restartButton.isActive then
			lg.setColor(1, 1, 1, 1)
			lg.setFont(Fonts.Menu_5)
			lg.print('YOU LOST', lg.getWidth()/2, 210, 0, 1, 1, Fonts.Menu_5:getWidth('YOU LOST')/2)
			
			lg.setFont(Fonts.Menu_2)
			if lostMenuButtons[hoveredButtonIndex] == restartButton then
				lg.setColor(1, 1, 1, 1)
				lg.print('RESTART', lg.getWidth()/2, 250, 0, 1, 1, Fonts.Menu_2:getWidth('RESTART')/2)
				lg.setColor(0.72, 0.72, 0.72, 1)
				lg.print('MAIN MENU', lg.getWidth()/2, 300, 0, 1, 1, Fonts.Menu_2:getWidth('MAIN MENU')/2)
				
			elseif lostMenuButtons[hoveredButtonIndex] == mainMenuButton then
				lg.setColor(0.72, 0.72, 0.72, 1)
				lg.print('RESTART', lg.getWidth()/2, 250, 0, 1, 1, Fonts.Menu_2:getWidth('RESTART')/2)
				lg.setColor(1, 1, 1, 1) 
				lg.print('MAIN MENU', lg.getWidth()/2, 300, 0, 1, 1, Fonts.Menu_2:getWidth('MAIN MENU')/2)
			
			end
		end
	end
end

function Game:keypressed(key)
	if key == 'escape' then
		Pause()
	else			
		if not paused then
			GameManager:TakeInput(key)		
			
		elseif paused then
			if resumeButton.isActive then
				if key == 'space' or key == 'return' then
					pauseMenuButtons[hoveredButtonIndex]:Execute()
				elseif key == 'up' then 
					hoveredButtonIndex = 1
				elseif key == 'down' then
					hoveredButtonIndex = 2
				end
			
			elseif restartButton.isActive then
				if key == 'space' or key == 'return' then
					lostMenuButtons[hoveredButtonIndex]:Execute()
				elseif key == 'up' then 
					hoveredButtonIndex = 1
				elseif key == 'down' then
					hoveredButtonIndex = 2
				end
			end
		end
	end
end

function Game:mousepressed(x, y, button)
	pauseButton:_mousepressed(x, y, button) 
	resumeButton:_mousepressed(x, y, button)
	mainMenuButton:_mousepressed(x, y, button)
	restartButton:_mousepressed(x, y, button)
end

function _beginContact(a, b, coll)
	if a:getUserData().OnCollisionEnter then a:getUserData():OnCollisionEnter(b, coll) end
	if b:getUserData().OnCollisionEnter then b:getUserData():OnCollisionEnter(a, coll) end
end

function Game:mousemoved(x, y)
	if resumeButton.isActive then
		for i, button in ipairs(pauseMenuButtons) do
			if button:isHover(x, y) and i ~= hoveredButtonIndex then 
				hoveredButtonIndex = i 
				AudioManager:PlaySFX('menu_3')
			end
		end
	
	elseif restartButton.isActive then
		for i, button in ipairs(lostMenuButtons) do
			if button:isHover(x, y) and i ~= hoveredButtonIndex then 
				hoveredButtonIndex = i 
				AudioManager:PlaySFX('menu_3')
			end
		end
	end
end

return Game
