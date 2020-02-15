require 'globals'
require 'assets'

AudioManager = require 'entities.audioManager'
GameManager  = require 'entities.gameManager'
Spawner      = require 'entities.spawner'
SpellGUI     = require 'entities.spellGUI'
Player 		 = require 'entities.player'
InfoGUI 	 = require 'entities.infoGUI'
Observer	 = require 'entities.observer'

Game = require 'gamestates.game'
Menu = require 'gamestates.menu'

if love.filesystem.read('data.txt') == nil then
	love.filesystem.write('data.txt', '-1')
end
highscore = love.filesystem.read('data.txt')
highscore = tonumber(highscore)

function love.load(data)
	Gamestate.switch(Menu, data)
	Gamestate.registerEvents()
end

function love.update(dt)

end

function love.draw()

end

function love.quit()
	
end
