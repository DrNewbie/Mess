local mod_ids = Idstring("CircleSpin"):key()
local func1 = "F_"..Idstring("func1:0:"..mod_ids):key()

local function __anim_this_to_spin(o, __stop)
	if o and o.animate then
		local function spin_anim(o)
			local dt = nil
			local rd = 360 * 0.75 * math.random(1, 3)
			while true do
				dt = coroutine.yield()
				o:rotate(rd * dt)
			end
		end
		if __stop then
			o:stop()
		end
		o:animate(spin_anim)
	end
	return
end

function __anim_me(them, __func, __stop)
	for __class, __data in pairs(__func) do
		if them[__class] then
			for _i_name, _d_data in pairs(__data) do
				if type(_d_data) == "table" then
					for _ii_name, _dd_data in pairs(_d_data) do
						__anim_this_to_spin(them[__class]:child(_i_name):child(_dd_data), __stop)
					end
				else
					__anim_this_to_spin(them[__class]:child(_i_name), __stop)
				end
			end
		end
	end
end

if HUDTeammate then
	function HUDTeammate:__reRun()
		__anim_me(self, {
			["_cable_ties_panel"] = {
				["cable_ties"] = true
			},
			["_deployable_equipment_panel"] = {
				["equipment"] = true
			},
			["_carry_panel"] = {
				["value"] = true
			},
			["_grenades_panel"] = {
				["grenades_icon"] = true,
				["grenades_icon_ghost"] = true
			}
		}, true)
	end

	Hooks:PostHook(HUDTeammate, "init", "F_"..Idstring("HUDTeammate:init:CircleSpin"):key(), function(self)
		self:__reRun()
	end)

	Hooks:PostHook(HUDTeammate, "set_cable_tie", "F_"..Idstring("HUDTeammate:set_cable_tie:CircleSpin"):key(), function(self)
		__anim_me(self, {
			["_cable_ties_panel"] = {
				["cable_ties"] = true
			}
		}, true)
	end)

	Hooks:PostHook(HUDTeammate, "set_deployable_equipment_amount", "F_"..Idstring("HUDTeammate:set_deployable_equipment_amount:CircleSpin"):key(), function(self)
		__anim_me(self, {
			["_deployable_equipment_panel"] = {
				["equipment"] = true
			}
		}, true)
	end)

	Hooks:PostHook(HUDTeammate, "set_deployable_equipment_amount_from_string", "F_"..Idstring("HUDTeammate:set_deployable_equipment_amount_from_string:CircleSpin"):key(), function(self)
		__anim_me(self, {
			["_deployable_equipment_panel"] = {
				["equipment"] = true
			}
		}, true)
	end)

	Hooks:PostHook(HUDTeammate, "set_grenades", "F_"..Idstring("HUDTeammate:set_grenades:CircleSpin"):key(), function(self)
		__anim_me(self, {
			["_grenades_panel"] = {
				["grenades_icon"] = true,
				["grenades_icon_ghost"] = true
			}
		}, true)
	end)

	Hooks:PostHook(HUDTeammate, "set_health", "F_"..Idstring("HUDTeammate:set_health:CircleSpin"):key(), function(self, data)
		if data and data.total > 0 and data.current > 0 then
			local red = data.current / data.total
			if red > 0.01 then
				__anim_me(self, {
					["_radial_health_panel"] = {
						["radial_health"] = true,
						["radial_rip"] = true,
						["radial_rip_bg"] = true
					}
				})
			end
		end
	end)

	Hooks:PostHook(HUDTeammate, "set_armor", "F_"..Idstring("HUDTeammate:set_armor:CircleSpin"):key(), function(self, data)
		if data and data.total > 0 and data.current > 0 then
			local red = data.current / data.total
			if red > 0.01 then
				__anim_me(self, {
					["_radial_health_panel"] = {
						["radial_shield"] = true
					}
				})
			end
		end
	end)
end

if PlayerManager then
	Hooks:PostHook(PlayerManager, "update_deployable_equipment_amount_to_peers", "F_"..Idstring("PlayerManager:update_deployable_equipment_amount_to_peers:CircleSpin"):key(), function(self)
		if managers.hud and managers.hud[func1] then
			managers.hud[func1] = nil
		end
	end)
end