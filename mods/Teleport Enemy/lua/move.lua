function _boolsomething()
	if managers.network then
		if managers.network.matchmake:get_lobby_attributes() > 1 then
			return true
		end
	end
	return false
end

local nowtime = function (type) return type and TimerManager:game():time() or managers.player:player_timer():time() end
local lastostime = os.time()
local lasttime = {}
local ddlayy = 15
local _setfunc1avc = CopMovement.set_position
function CopMovement:set_position(pos)
	if _boolsomething() then
		local enemyType = tostring(self._unit:base()._tweak_table)
		if ( enemyType == "security" or enemyType == "gensec" or
			enemyType == "cop" or enemyType == "fbi" or
			enemyType == "swat" or enemyType == "heavy_swat" or
			enemyType == "fbi_swat" or enemyType == "fbi_heavy_swat" or
			enemyType == "city_swat" or enemyType == "sniper" or
			enemyType == "gangster" or enemyType == "taser" or
			enemyType == "tank" or enemyType == "spooc" or enemyType == "shield" ) then
			local idx = tonumber(self._unit:id())
			if idx > 0 then
				local now1 = nowtime()
				local now2 = math.floor(now1)
				now2 = now2%ddlayy
				idx = idx % 500
				if ( lasttime[idx] or 0 ) <= 0 then
					lasttime[idx] = 5
					pos = rand_vector3_use(pos)
				else
					if (now2-1) <= lasttime[idx] and lasttime[idx] <= (now2+1) then
						pos = rand_vector3_use(pos)
						if lastostime ~= os.time() then
							lastostime = os.time()
							math.randomseed(lastostime)
						end
						lasttime[idx] = math.random(ddlayy-1)
					end
				end
			end
		end
	end
	_setfunc1avc(self, pos)
end
function rand_vector3_use(pos)
	local use_v3_list = {pos, pos, pos, pos}
	local z_offsett = {0, 0, 0, 0, 300, 400, 200, 500}
	local i = 0
	for _, data in pairs(managers.groupai:state():all_player_criminals()) do
		i = i + 1
		use_v3_list[i] = data.unit:position()
	end
	pos = use_v3_list[math.random(#use_v3_list)]
	pos = pos + Vector3(math.random(-500,500), math.random(-500,500), z_offsett[math.random(#z_offsett)])
	return pos
end