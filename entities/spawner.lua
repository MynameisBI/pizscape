local Jazzer = require 'entities.enemies.jazzer'
local TopHatter = require 'entities.enemies.topHatter'
local Drone = require 'entities.enemies.drone'

local allNormalEnemies = { Drone, Jazzer, TopHatter }
local normalEnemies = { Drone }

local Kingpin = require 'entities.enemies.kingpin'

local nextKingpin
local nextKingpinAdditionalScore = 2400
local isKingpin = false

local Spawner = {}

local timePass = 0

local spawnScore = 0
local spawnScoresPerWave = {}
spawnScoresPerWave[1]   = { 400,     16 }
spawnScoresPerWave[2]   = { 1000,    21 }
spawnScoresPerWave[3]   = { 2800,    26 }
spawnScoresPerWave[4]   = { 6400,    30 }
spawnScoresPerWave[5]   = { 9800,    34 }
spawnScoresPerWave[6]   = { 13000,   38 }
spawnScoresPerWave[7]   = { 17500,   42 }
spawnScoresPerWave[8]   = { 24000,   46 }
spawnScoresPerWave[9]   = { 30000,   51 }
spawnScoresPerWave[10]  = { 37000,   54 }
spawnScoresPerWave[11]  = { 45000,   57 }
spawnScoresPerWave[12]  = { 55000,   61 }
spawnScoresPerWave[13]  = { 68000,   63 }
spawnScoresPerWave[14]  = { 82000,   65 }
spawnScoresPerWave[15]  = { 100000,  67 }
spawnScoresPerWave[16]  = { 200000,  70 }
spawnScoresPerWave[17]  = { 300000,  73 }
spawnScoresPerWave[18]  = { 400000,  76 }
spawnScoresPerWave[19]  = { 500000,  79 }
spawnScoresPerWave[20]  = { 600000,  82 }
spawnScoresPerWave[21]  = { 700000,  85 }
spawnScoresPerWave[22]  = { math.huge, 90}

local spawnScoreOffsetPercent = 0.1

local secondsPerSpawnWave = 0.375
local secondsToSpawnWave = 0

--[[
a, b, c, d, e, f, g, h = false, false, false, false, false, false, false, false

function Spawner:Update(dt)
	timePass = timePass + dt
	
	if timePass > 3 and not a then
		Jazzer(100)
		a = true
		
	elseif timePass > 4 and not e then
		Jazzer(110)
		e = true
		
	elseif timePass > 2 and not f then
		Drone(460)
		Drone(480)
		f = true
		
	elseif timePass > 6 and not b then
		Jazzer(400)
		b = true
		
	elseif timePass > 8 and not c then
		TopHatter(250)
		c = true
		
	elseif timePass > 8.5 and not d then
		Jazzer(350)
		d = true
	
	elseif timePass > 10 and not g then
		Kingpin(270)		
		g = true
	
	end
end
]]--

local lastSpawnPoint = {}

function Spawner:Update(dt)
	local currentScore = GameManager:GetScore()

	secondsToSpawnWave = secondsToSpawnWave - dt
	
	if secondsToSpawnWave <= 0 then
		secondsToSpawnWave = secondsPerSpawnWave
		
		if not isKingpin then
			-- Spawner stuff
			local k_
			local spawnScoreOffset -- to spice things up
			for i = 1, 17 do
				local wave = spawnScoresPerWave[i]
				if currentScore < wave[1] then
					spawnScore = spawnScore + wave[2]
					spawnScoreOffset = math.random(-wave[2], wave[2])
					break
				end
			end
			
			while spawnScore > spawnScoreOffset*0.5 do
				local enemyIndex = math.random(1, #normalEnemies)
				local enemy = normalEnemies[enemyIndex](math.random(50, 490))
				
				spawnScore = spawnScore - enemy.score
			end
		end
		
		Unlocking(currentScore)
	end
	
end

local a, b, c, d, e, f, g, h

function Unlocking(currentScore)
	if currentScore >= 200 and not e then
		GameManager:AddSpell(2)
		SpellGUI.UpdateSpell(2)
		e = true		
		
		Observer:SkillUnlockEvent(2)
			
	elseif currentScore >= 2250 and not a then
		GameManager:AddSpell(3)
		SpellGUI.UpdateSpell(3)
		a = true		
		
		Observer:SkillUnlockEvent(3)
		
	elseif currentScore >= 4200 and not b then
		GameManager:AddSpell(4)
		SpellGUI.UpdateSpell(4)
		b = true
		
		Observer:SkillUnlockEvent(4)

	elseif currentScore >= 9000 and not c then
		GameManager:AddSpell(5)
		SpellGUI.UpdateSpell(5)
		c = true
		
		Observer:SkillUnlockEvent(5)
	
	elseif currentScore >= 16500 and not d then
		GameManager:AddSpell(6)
		SpellGUI.UpdateSpell(6)
		d = true
		
		Observer:SkillUnlockEvent(6)
	
	elseif currentScore >= 150 and not f then
		AddEnemy(2)
		f = true
	
	elseif currentScore >= 2500 and not g then
		AddEnemy(3)
		g = true
		
	end
	
	if currentScore >= nextKingpin then
		local health = math.floor( 19 + math.sqrt(nextKingpin) / 4.2 )
		local score = math.floor( 500 + nextKingpin/6.3 )
		if health >= 100 then health = 100 + math.sqrt( math.sqrt((health - 100)) ) end
		if score >= 8000 then score = math.floor( 8000 + math.sqrt(score - 8000) ) end
		Kingpin( lg.getWidth() / 2, health, score  )
		
		isKingpin = true
	
		if nextKingpin + nextKingpinAdditionalScore >= 19200 then
			nextKingpin = nextKingpin + 19200 + math.sqrt(math.sqrt( 19200 - nextKingpin - nextKingpinAdditionalScore ))
		else
			nextKingpin = nextKingpin + nextKingpin * 0.5 + nextKingpinAdditionalScore
		end
	end
end

function Spawner:isKingpinDestroyed(a) isKingpin = not a end

function AddEnemy(num)
	table.insert(normalEnemies, allNormalEnemies[num])
end

function Spawner:Reset()
	nextKingpin = 1000
	isKingpin = false	
	normalEnemies = { Drone }
	
	a, b, c, d, e, f, g, h = false, false, false, false, false, false, false, false
end

return Spawner
