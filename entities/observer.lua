local Observer = {}

local skillNum = nil
local popUpText = nil

local flashingInterval = {}; flashingInterval['true'] = 0.7; flashingInterval['false'] = 0.7
local popUpState = false
local secondsToChangePopUpState = 0

local firstTime = {}; firstTime['5'] = false; firstTime['6'] = false

function Observer:Update(dt)
	secondsToChangePopUpState = secondsToChangePopUpState - dt
	if secondsToChangePopUpState <= 0 then 
		popUpState = not popUpState
		secondsToChangePopUpState = flashingInterval[tostring(popUpState)]
	end
end

function Observer:Draw()
	if popUpText ~= nil then
		if popUpState == true then lg.setColor(1, 1, 1, 0.8)
		elseif popUpState == false then lg.setColor(1, 1, 1, 0)
		end
		lg.setFont(Fonts.smallGUI_)
		lg.print(popUpText, 10, lg.getHeight() - 64)
	end
end

function Observer:SkillUnlockEvent(num)	
	if num == 1 then popUpText = 'type A'; skillNum = 1
	elseif num == 2 then popUpText = 'type SC'; skillNum = 2
	elseif num == 3 then popUpText = 'type CR'; skillNum = 3
	elseif num == 4 then popUpText = 'type FRZ'; skillNum = 4
	elseif num == 5 then popUpText = 'type SWORD'; skillNum = 5
	elseif num == 6 then popUpText = 'type THUNDER'; skillNum = 6
	end
end

function Observer:TextInputEvent(text)
	if skillNum == 1 then
		if text == 'A' then popUpText = 'press ENTER' end
	elseif skillNum == 2 then
		if text == 'SC' then popUpText = 'press ENTER' end		
	end
end

function Observer:CommandInputEvent(arrows)
	if skillNum == 5 and #arrows == 2 then
		if arrows[1] == 'up' and arrows[2] == 'up' then popUpText = 'press SPACE' end
	elseif skillNum == 6 and #arrows == 3 then popUpText = 'press SPACE'
	end
end

function Observer:SkillUseEvent(num)
	if num == skillNum then
		popUpText = nil
		skillNum = nil
	end
	
	if num == 5 and firstTime['5'] == false then
		skillNum = 5
		popUpText = 'Press UP UP'
		firstTime['5'] = true
		
	elseif num == 6 and firstTime['6'] == false then
		skillNum = 6
		popUpText = 'Press 3 ARROWS'
		firstTime['6'] = true
	end
end

function Observer:MakeCommandEvent(num)
	if num == skillNum then
		popUpText = nil
		skillNum = nil
	end
end

return Observer
