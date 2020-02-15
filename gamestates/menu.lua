local Button = require 'gui.button'

local camera = Camera()
local cameraX, cameraY = lg.getWidth()/2, lg.getHeight()/2

---- Menu ------------------------------------------------------------------------------------------
local Menu = {}

local playButton 	  = Button(30, 300,  Fonts.Menu_2:getWidth('PLAY'), 	 Fonts.Menu_2:getHeight())
local spellbookButton = Button(30, 350,  Fonts.Menu_2:getWidth('SPELLBOOK'), Fonts.Menu_2:getHeight())
local howToPlayButton = Button(30, 400,  Fonts.Menu_2:getWidth('HOW TO PLAY'),  Fonts.Menu_2:getHeight())
local quitButton 	  = Button(30, 480,  Fonts.Menu_2:getWidth('QUIT'), 	 Fonts.Menu_2:getHeight())
local creditButton    = Button(410, 560, Fonts.Menu_3:getWidth('CREDIT'), 	 Fonts.Menu_3:getHeight())

local spellbookBackButton = Button(430 - lg.getWidth(), 570,
								   Fonts.Menu_3:getWidth('BACK'), Fonts.Menu_3:getHeight())
local howToPlayBackButton = Button(20 + lg.getWidth(), 570, 
								   Fonts.Menu_3:getWidth('BACK'), Fonts.Menu_3:getHeight())							
local creditBackButton = Button (430, 570 + lg.getHeight(), 
								 Fonts.Menu_3:getWidth('BACK'), Fonts.Menu_3:getHeight())

local buttons = nil
local mainMenuButtons = { playButton, spellbookButton, howToPlayButton, quitButton, creditButton }
local spellbookButtons = { spellbookBackButton }
local howToPlayButtons = { howToPlayBackButton }
local creditButtons = { creditBackButton }
local buttonHoveredIndex = 1; function SetButtonIndex(index) buttonHoveredIndex = index end

local howToPlayText =
{
	"After a thousand years of imprisonment, the Pizs return back to your kingdom to have their revenge. As the grand sorcerer of the kingdom, it is up to you to defend your home against the Pizs",
	"Stop enemies from reaching the ground or you will lose lives. You lose when you're out of lives",
	"Type the spell name then press ENTER to cast it and destroy enemies",
	"Some spell need to be commanded after being cast. Use ARROWS to make a command and press SPACE to use the command", 
	"Check your spellbook for more detail"
}

---- Button command
function Play()
	AudioManager:PlaySFX('menu_1')
	Gamestate.switch(Game, data)
end

function OpenSpellbook()
	AudioManager:PlaySFX('menu_1')
	cameraX = -lg.getWidth() / 2
	
	buttons = spellbookButtons
	buttonHoveredIndex = 1
end

function CloseSpellbook()
	AudioManager:PlaySFX('menu_2')
	cameraX = lg.getWidth() / 2
	
	buttons = mainMenuButtons
	buttonHoveredIndex = 1
end

function OpenHowToPlay()
	AudioManager:PlaySFX('menu_1')
	cameraX = lg.getWidth() * 1.5
	
	buttons = howToPlayButtons
	buttonHoveredIndex = 1
end

function CloseHowToPlay()
	AudioManager:PlaySFX('menu_2')
	cameraX = lg.getWidth() / 2
	
	buttons = mainMenuButtons 
	buttonHoveredIndex = 1
end

function Quit()
	love.event.quit()
end

function ShowCredit()
	AudioManager:PlaySFX('menu_1')
	cameraY = lg.getHeight() * 1.5
	
	buttons = creditButtons
	buttonHoveredIndex = 1
end

function CloseCredit()
	AudioManager:PlaySFX('menu_2')
	cameraY = lg.getHeight() / 2
	
	buttons = mainMenuButtons
	buttonHoveredIndex = 1
end

playButton:SetCommand(Play)
spellbookButton:SetCommand(OpenSpellbook)
howToPlayButton:SetCommand(OpenHowToPlay)
quitButton:SetCommand(Quit)
creditButton:SetCommand(ShowCredit)

spellbookBackButton:SetCommand(CloseSpellbook)

howToPlayBackButton:SetCommand(CloseHowToPlay)

creditBackButton:SetCommand(CloseCredit)

---- Spellbook
spells 		= {'A', 'SC', 'CR', 'FRZ', 'SWORD', 'THUNDER'}
damage 		= {'1', '1', '2/1', '1', '2', '3' }
cooldown 	= {'0.75', '1.5', '3', '4', '5', '6'}
command     = {'UP x2', 'ANY x3'}


function Menu:enter()
	AudioManager:PlayMusic('menu')
	
	Particles.menu:start()
	
	buttons = mainMenuButtons
	
	local data
end

function Menu:update(dt)
	Particles.menu:update(dt)
	
	camera:lockPosition(cameraX, cameraY, Camera.smooth.linear(870))
end

function Menu:draw()
	camera:attach()
	
	---- Main menu
	lg.setColor(1, 1, 1, 1)
	
	-- Title
	lg.setFont(Fonts.Menu_1)
	lg.print('PIZSCAPE', lg.getWidth()/2, 80, 0, 1, 1, Fonts.Menu_1:getWidth('PIZSCAPE')/2)
	
	-- Highscore
	lg.setFont(Fonts.Menu_3)
	if highscore ~= -1 then lg.print('HIGHSCORE : '..tostring(highscore), 30, 276) end
	
	-- Buttons
		-- text
	lg.setFont(Fonts.Menu_2)
	lg.print('PLAY', 30, 300)
	lg.print('SPELLBOOK', 30, 350)
	lg.print('HOW TO PLAY', 30, 400)
	lg.print('QUIT', 30, 480)
	
	lg.setFont(Fonts.Menu_3)
	lg.print('CREDIT', 410, 560)
	
		-- input box
	local button = buttons[buttonHoveredIndex]
	lg.draw(Sprites.menu.arrow, button.x + button.w + 8,
			button.y + button.h/2 - Sprites.menu.arrow:getHeight()/2 - 2) 
	
	lg.line(-600, 594, -86, 594); lg.line(-70, 594, 236, 594); lg.line(252, 594, 702, 594); lg.line(718, 594, 1200, 594)
	lg.line(-600, 600, -348, 600); lg.line(-332, 600, 424, 600); lg.line(440, 600, 824, 600); lg.line(840, 600, 1200, 600)
	
	lg.draw(Particles.menu, 0, 0)
	
	---- Spellbook
	lg.setColor(1, 1, 1, 1)
	local i = -3
	for k, spellIcon in pairs(Sprites.menu.spellbook) do 
		lg.draw(spellIcon, -lg.getWidth() + 10, lg.getHeight()/2 + i * 82 - 20)
		
		local i_ = i + 4
		lg.setFont(Fonts.Menu_4)
		lg.print(spells[i_], -lg.getWidth() + 92, lg.getHeight()/2 + i * 82 - 17)
		lg.setFont(Fonts.Menu_3)
		lg.print('DAMAGE : '..damage[i_], -lg.getWidth() + 102, lg.getHeight()/2 + i * 82 + 11)
		lg.print('COOLDOWN : '..cooldown[i_], -lg.getWidth() + 102, lg.getHeight()/2 + i * 82 + 31)
		
		i = i + 1
	end
	
	lg.setFont(Fonts.Menu_3)
	lg.print('COMMAND : '..command[1], -lg.getWidth() + 290, lg.getHeight()/2 + 93)
	lg.print('COMMAND : '..command[2], -lg.getWidth() + 290, lg.getHeight()/2 + 175)
	
	lg.setFont(Fonts.Menu_3)
	lg.print('BACK', 430 - lg.getWidth(), 570)
	
	---- How To Play
	lg.setColor(1, 1, 1, 1)
	lg.setFont(Fonts.Menu_3)
	lg.print('BACK', 20 + lg.getWidth(), 570)
	
	lg.setFont(Fonts.smallGUI_)
	lg.printf(howToPlayText[1], 560, 40, 500, 'center')
	
	lg.setFont(Fonts.GUI)
	lg.printf(howToPlayText[2], 560, 190, 500, 'center')
	lg.printf(howToPlayText[3], 560, 300, 500, 'center')
	lg.printf(howToPlayText[4], 560, 380, 500, 'center')
	lg.printf(howToPlayText[5], 560, 490, 500, 'center')


	---- Credit
	lg.setColor(1, 1, 1, 1)
	lg.setFont(Fonts.Menu_3)
	lg.print('BACK', 430, 570 + lg.getHeight())
	
	lg.setFont(Fonts.Menu_3)
	lg.print('PROGRAMMING', 160, 140 + lg.getHeight(), 0, 1, 1, Fonts.Menu_3:getWidth('PROGRAMMING')/2, Fonts.Menu_3:getHeight()/2)
	lg.print('ART', lg.getWidth() - 160, 140 + lg.getHeight(), 0, 1, 1, Fonts.Menu_3:getWidth('ART')/2, Fonts.Menu_3:getHeight()/2)
	lg.print('MUSIC', 270, 280 + lg.getHeight(), 0, 1, 1, Fonts.Menu_3:getWidth('MUSIC')/2, Fonts.Menu_3:getHeight()/2)
	lg.print('SOUND FX', 270, 420 + lg.getHeight(), 0, 1, 1, Fonts.Menu_3:getWidth('SOUND FX')/2, Fonts.Menu_3:getHeight()/2)
	
	lg.setFont(Fonts.Menu_5)
	lg.print('RUMIS', 160, 175 + lg.getHeight(), 0, 1, 1, Fonts.Menu_5:getWidth('RUMIS')/2, Fonts.Menu_5:getHeight()/2)
	lg.print('RUMIS', lg.getWidth() - 160, 175 + lg.getHeight(), 0, 1, 1, Fonts.Menu_5:getWidth('RUMIS')/2, Fonts.Menu_5:getHeight()/2)
	lg.print('CHIPTUNISTCHIPPY', 270, 315 + lg.getHeight(), 0, 1, 1, Fonts.Menu_5:getWidth('CHIPTUNISTCHIPPY')/2, Fonts.Menu_5:getHeight()/2)
	lg.print('OMEGAPIXELART', 270, 455 + lg.getHeight(), 0, 1, 1, Fonts.Menu_5:getWidth('OMEGAPIXELART')/2, Fonts.Menu_5:getHeight()/2)
	
	lg.setFont(Fonts.smallGUI_)
	lg.print('https://chiptunistchippy.itch.io', 270, 332 + lg.getHeight(), 0, 1, 1, Fonts.smallGUI_:getWidth('https://chiptunistchippy.itch.io/')/2, Fonts.smallGUI_:getHeight()/2)
	lg.print('https://omegaosg.itch.io', 270, 472 + lg.getHeight(), 0, 1, 1, Fonts.smallGUI_:getWidth('https://omegaosg.itch.io/')/2, Fonts.smallGUI_:getHeight()/2)
	
	camera:detach()
end


function Menu:leave()
	Particles.menu:reset()
	Particles.menu:stop()
end

function Menu:keypressed(key)
	if key == 'up' then
		buttonHoveredIndex = buttonHoveredIndex - 1
		if buttonHoveredIndex < 1 then buttonHoveredIndex = 1 end
		AudioManager:PlaySFX('menu_3')
		
	elseif key == 'down' then
		buttonHoveredIndex = buttonHoveredIndex + 1
		if buttonHoveredIndex > #buttons then buttonHoveredIndex = #buttons end
		AudioManager:PlaySFX('menu_3')
	
	elseif key == 'return' or key == 'space' then
		buttons[buttonHoveredIndex]:Execute()
		
	end
end

function Menu:mousemoved(x, y)
	local x_, y_ = camera:mousePosition()
	for i, button in ipairs(buttons) do
		if button.y <= y_ and y_ <= button.y + button.h then 
			if buttonHoveredIndex ~= i then
				buttonHoveredIndex = i 
			
				AudioManager:PlaySFX('menu_3')
				
				break
			end
		end
	end
end

function Menu:mousepressed(x, y, button)
	local x_, y_ = camera:mousePosition()
	for i, button in ipairs(buttons) do button:_mousepressed(x_, y_, button) end
end

return Menu
