local __ids_key = Idstring("Medics Throw Corpses"):key()

_G[__ids_key] = _G[__ids_key] or {}

Hooks:PostHook(MedicDamage, "heal_unit", "F_"..Idstring("PostHook:MedicDamage:heal_unit:"..__ids_key):key(), function(self, __dead_guy)
	local tweak_table = __dead_guy:base()._tweak_table
	if __dead_guy and alive(__dead_guy) and not table.contains(tweak_data.medic.disabled_units, tweak_table) then
		if not __dead_guy:base()[__ids_key] then
			local __name = __dead_guy:name()
			local __remote_unit = _G[__ids_key][__name:key()] or nil
			if not __remote_unit and DB:has(Idstring("unit"), __dead_guy:name()) then
				_G[__ids_key][__name:key()] = Idstring("No")
				local xml_node = DB:load_node(Idstring("unit"), __dead_guy:name())
				if xml_node then
					for node in xml_node:children() do
						if node:name() == "network" then
							if tostring(node:parameter("sync")) == "true" then
								__remote_unit = __dead_guy:name()
							else
								__remote_unit = Idstring(tostring(node:parameter("remote_unit")))
							end
							if DB:has(Idstring("unit"), __remote_unit) then
								_G[__ids_key][__name:key()] = __remote_unit
							end
						end
					end
				end
			end
			if __remote_unit and __remote_unit ~= Idstring("No") then
				local __spawn_pos = self._unit:position()
				local __respawn_guy = safe_spawn_unit(__remote_unit, __spawn_pos, self._unit:movement():m_rot())
				if __respawn_guy then
					__respawn_guy:base()[__ids_key] = true
					local _access = __respawn_guy:base():char_tweak().access
					if _access == "civ_male" or _access == "civ_female" then
					
					else
						local team = _access == "gangster" and "gangster" or "combatant"
						local team_id = tweak_data.levels:get_default_team_ID(team)
						local __respawn_guy_pos = __respawn_guy:position()
						__respawn_guy:movement():set_team(managers.groupai:state():team_data(team_id))
						__respawn_guy:brain():set_spawn_ai({init_state = "idle"})
						__respawn_guy:brain():set_active(false, false)
						local units_to_push = {}
						units_to_push[__respawn_guy:key()] = __respawn_guy
						call_on_next_update(function ()
							__respawn_guy:character_damage():damage_mission({
								damage = 1000 + __respawn_guy:character_damage()._health,
								col_ray = {}
							})
							call_on_next_update(function ()
								managers.explosion:units_to_push(units_to_push, self._unit:position() - Vector3(0, 0, math.random() * 30), 500 + math.random()*1000)
							end)
						end)
					end
				end
			end
		end
	end
end)

function __Run_Husk_Fix()
	if CopBrain and HuskCopBrain then
		for _func, _ in pairs(CopBrain) do
			if not HuskCopBrain[_func] then
				HuskCopBrain[_func] = function()
					return
				end
			end
		end
		HuskCopBrain.__old_post_init = HuskCopBrain.__old_post_init or HuskCopBrain.post_init
		local function __new(self, ...)
			self._logics = CopBrain._logic_variants["cop"]
			self:__old_post_init(...)		
		end
		HuskCopBrain.post_init = __new
		HuskCopBrain._timer = TimerManager:game()
	end
	if CopMovement and HuskCopMovement then
		for _func, _ in pairs(CopMovement) do
			if not HuskCopMovement[_func] then
				HuskCopMovement[_func] = CopMovement[_func]
			end
		end
	end
	if CopInventory and HuskCopInventory then
		for _func, _ in pairs(CopInventory) do
			if not HuskCopInventory[_func] then
				HuskCopInventory[_func] = CopInventory[_func]
			end
		end
	end
	if CopDamage and HuskCopDamage then
		for _func, _ in pairs(CopDamage) do
			if not HuskCopDamage[_func] then
				HuskCopDamage[_func] = CopDamage[_func]
			end
		end
	end
	if CopBase and HuskCopBase then
		for _func, _ in pairs(CopBase) do
			if not HuskCopBase[_func] then
				HuskCopBase[_func] = CopBase[_func]
			end
		end
	end
	return
end

__Run_Husk_Fix()