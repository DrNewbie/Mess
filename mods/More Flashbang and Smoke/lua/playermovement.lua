local mod_ids = Idstring("More Flashbang and Smoke"):key()
local __dt = '__dt_'..Idstring(mod_ids..'__dt'):key()
local __func1 = "F_"..Idstring("func1:"..mod_ids):key()
local __func2 = "F_"..Idstring("func2:"..mod_ids):key()
local __func3 = "F_"..Idstring("func3:"..mod_ids):key()
local __func4 = "F_"..Idstring("func4:"..mod_ids):key()
local __func5 = "F_"..Idstring("func5:"..mod_ids):key()
local __flash_smoke = function ()
	return math.random() > 0.49
end
local __pos_offset = function ()
	local __ang = math.random() * 360 * math.pi
	local __rad = math.random(20, 30)
	return Vector3(math.cos(__ang) * __rad, math.sin(__ang) * __rad, 0)
end
local __wpn_frag_flashbang = Idstring("units/payday2/weapons/wpn_frag_flashbang/wpn_frag_flashbang")
local __smoke_grenade_quick = Idstring("units/weapons/smoke_grenade_quick/smoke_grenade_quick")

PlayerMovement[__func5] = function(__var)
	local __list = {
		__enable = true,
		__max_ppl_in_row = 3,
		__rnd_frag_in_row = 3,
		__distance = 3000,
		__delay_constant = 2,
		__delay_rnd = 8
	}
	if _G[mod_ids] and _G[mod_ids].Options then
		__list.__enable = _G[mod_ids].Options:GetValue("__enable")
		__list.__max_ppl_in_row = _G[mod_ids].Options:GetValue("__max_ppl_in_row")
		__list.__rnd_frag_in_row = _G[mod_ids].Options:GetValue("__rnd_frag_in_row")
		__list.__distance = _G[mod_ids].Options:GetValue("__distance")
		__list.__delay_constant = _G[mod_ids].Options:GetValue("__delay_constant")
		__list.__delay_rnd = _G[mod_ids].Options:GetValue("__delay_rnd")
	end
	return __list[__var] or 0
end

local __delay = function ()
	return PlayerMovement[__func5]("__delay_constant") + math.random() * PlayerMovement[__func5]("__delay_rnd")
end

function PlayerMovement:__wpn_frag_flashbang_loaded()
	self[__func3] = true
end

function PlayerMovement:__smoke_grenade_quick_loaded()
	self[__func4] = true
end

Hooks:PostHook(PlayerMovement, 'init', __func1, function(self)
	self[__dt] = 1
	managers.dyn_resource:load(Idstring("unit"), __wpn_frag_flashbang, managers.dyn_resource.DYN_RESOURCES_PACKAGE, callback(self, self, "__wpn_frag_flashbang_loaded"))
	managers.dyn_resource:load(Idstring("unit"), __smoke_grenade_quick, managers.dyn_resource.DYN_RESOURCES_PACKAGE, callback(self, self, "__smoke_grenade_quick_loaded"))
end)

Hooks:PostHook(PlayerMovement, '_upd_underdog_skill', __func2, function(self, t)
	if self[__func5]("__enable") and self[__func3] and self[__func4] and managers.groupai and self[__dt] < t and type(self._attackers) == "table" then
		self[__dt] = t + __delay()
		local __all_criminals = managers.groupai:state():all_char_criminals()
		if type(__all_criminals) == "table" then
			local __try = self[__func5]("__max_ppl_in_row")
			for _, __Tcop in pairs(self._attackers) do
				local u_key = table.random_key(__all_criminals)
				local u_data = __all_criminals[u_key]
				if __try <= 0 then break end
				if u_data and u_data.unit then
					if mvector3.distance(u_data.unit:position(), __Tcop:position()) < self[__func5]("__distance") then
						__try = __try - 1
						__Tcop:movement():play_redirect("throw_grenade")
						local __position = u_data.unit:position()
						for i = 1, math.random(1, self[__func5]("__rnd_frag_in_row")) do
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