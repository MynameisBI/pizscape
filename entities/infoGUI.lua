local InfoGUI = {}

local scoreSprite = Sprites.GUI.score
local livesSprite = Sprites.GUI.lives

function InfoGUI:DrawGUI()
	lg.setColor(1, 1, 1, 1)
	lg.setFont(Fonts.GUI)
	
	lg.draw(scoreSprite, 10, 10)
	lg.draw(livesSprite, 10, 44)
	
	local score = tostring(GameManager:GetScore())
	local scoreText = score
	for i = 1, 6 - #score do scoreText = '0'..scoreText end
	lg.print(scoreText, 43, 6)
	
	local lives = tostring(GameManager:GetLives())
	local livesText = lives
	for i = 1, 2 - #lives do livesText = '0'..livesText end
	lg.print(livesText, 43, 40)
end

return InfoGUI
