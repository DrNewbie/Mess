local mod_ids = Idstring("Cops Throw Grenades"):key()
local __dt = '__dt_'..Idstring(mod_ids..'__dt'):key()
local __func1 = "F_"..Idstring("func1:"..mod_ids):key()
local __func2 = "F_"..Idstring("func2:"..mod_ids):key()
local __max_ppl_in_row = 3
local __rnd_frag_in_row = 3
local __distance = 3000
local __delay = function ()
	return 2 + math.random() * 5
end
local __flash_smoke = function ()
	return math.random() > 0.49
end
local __pos_offset = function ()
	local __ang = math.random() * 360 * math.pi
	local __rad = math.random(20, 30)
	return Vector3(math.cos(__ang) * __rad, math.sin(__ang) * __rad, 0)
end

Hooks:PostHook(PlayerMovement, 'init', __func1, function(self)
	self[__dt] = 1
end)

Hooks:PostHook(PlayerMovement, '_upd_underdog_skill', __func2, function(self, t)
	if managers.groupai and self[__dt] < t and type(self._attackers) == "table" then
		self[__dt] = t + __delay()
		local __all_criminals = managers.groupai:state():all_char_criminals()
		if type(__all_criminals) == "table" then
			local __try = __max_ppl_in_row
			for _, __Tcop in pairs(self._attackers) do
				local u_key = table.random_key(__all_criminals)
				local u_data = __all_criminals[u_key]
				if __try <= 0 then break end
				if u_data and u_data.unit then
					if mvector3.distance(u_data.unit:position(), __Tcop:position()) < __distance then
						__try = __try - 1
						__Tcop:movement():play_redirect("throw_grenade")
						local __position = u_data.unit:position()
						for i = 1, math.random(1, __rnd_frag_in_row) do
							local __id = Idstring(math.random()..":"..i..":"..tostring(u_key)):key()
							local __duration = 2 * i + math.random()
							local __ignore_control = true
							local __is_flashbang = true
							if __flash_smoke() then __is_flashbang = false end
							managers.groupai:state():queue_smoke_grenade(
								__id, 
								__position + __pos_offset(), 
								__duration, 
								__ignore_control, 
								__is_flashbang
							)
							managers.groupai:state():detonate_world_smoke_grenade(__id)
						end
					end
				end
			end
		end
	end
end)