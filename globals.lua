Gamestate = require 'libs.gamestate'
Class 	  = require 'libs.middleclass'
Vector 	  = require 'libs.vector'
Camera 	  = require 'libs.camera'

lg = love.graphics
lp = love.physics
lm = love.math
lk = love.keyboard
la = love.audio

function removevalue(table_, value)
	indexes = {}
	for k, v in pairs(table_) do
		indexes[v] = k
	end
	table.remove(table_, indexes[value])
end

function removevalue_pureListTable(table_, value)
	for i, v in ipairs(table_) do
		if v == value then table.remove(table_, i) end
	end
end

function findEntitiesWithTag(tag)
	local entities = {}
	
	for i, entity in ipairs(Entities) do
		if entity.tag == tag then table.insert(entities, entity) end
	end
	
	return entities
end

function comparetable_shallow(t1, t2)
	if #t1 ~= #t2 then return false end
	
	for i = 1, #t1 do
		if t1[i] ~= t2[i] then return false end
	end
	
	return true
end
