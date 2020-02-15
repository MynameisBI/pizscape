local AudioManager = {}

local currentMusic = Audio.Musics.mainTheme

local musicVolume = 1
local SFXVolume = 1

function AudioManager:Update(dt)

end

function AudioManager:PlayMusic(name)
	if name == nil then
		if currentMusic ~= nil then currentMusic.audio:play() end
		
	elseif name ~= nil then	
		for k, music in pairs(Audio.Musics) do
			if k == name then
				if currentMusic ~= nil then currentMusic.audio:stop() end
				currentMusic = music
				currentMusic.audio:setVolume(music.volume * musicVolume)
				currentMusic.audio:setLooping(true)
				currentMusic.audio:play()
			end
		end
	end
end

function AudioManager:PauseMusic() if currentMusic ~= nil then currentMusic.audio:pause() end end

function AudioManager:PlaySFX(name)
	if Audio.SFXs[name] == nil then print('no audio found') end
	
	Audio.SFXs[name].audio:stop()
	Audio.SFXs[name].audio:setVolume(Audio.SFXs[name].volume)
	Audio.SFXs[name].audio:play()
end

function AudioManager:SetMusicVolume(num) 
	if num > 1 then num = 1
	elseif num < 0 then num = 0
	end
	
	musicVolume = num 
end

function AudioManager:SetSFXVolume(num) 
	if num > 1 then num = 1
	elseif num < 0 then num = 0
	end

	musicVolume = num 
end

return AudioManager
