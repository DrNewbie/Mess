local __ammo_bag_unit_name = Idstring("units/payday2/equipment/gen_equipment_ammobag/gen_equipment_ammobag")
local __medic_bag_unit_name = Idstring("units/payday2/equipment/gen_equipment_medicbag/gen_equipment_medicbag")
local __grenade_crate_unit_name = Idstring("units/payday2/equipment/gen_equipment_grenade_crate/gen_equipment_grenade_crate")

function SkirmishManager:Spawn_Holdout_Wave_Reward()
	if not self:is_skirmish() then
		
	else
		if (Network and Network:is_server()) or Global.game_settings.single_player then
			local __civilians = World:find_units_quick("all", managers.slot:get_mask("civilians"))
			if __civilians then
				local __spawn_ammo_bag = function(__pos, __rot)				
					local __spawn_unit = AmmoBagBase.spawn(__pos + Vector3(100, 0, 0), __rot, 0, 9999)
					if __spawn_unit then
						table.insert(self.__Wave_Rewards, __spawn_unit)
					end
					return
				end
				local __spawn_medic_bag = function(__pos, __rot)				
					local __spawn_unit = DoctorBagBase.spawn(__pos + Vector3(-100, 0, 0), __rot, 0, 9999)
					if __spawn_unit then
						table.insert(self.__Wave_Rewards, __spawn_unit)
					end
					return
				end
				local __spawn_grenade_crate = function(__pos, __rot)				
					local __spawn_unit = GrenadeCrateBase.spawn(__pos + Vector3(-100, -100, 0), __rot)
					if __spawn_unit then
						table.insert(self.__Wave_Rewards, __spawn_unit)
					end
					return
				end
				for __, __unit in pairs(__civilians) do
					if __unit and alive(__unit) then
						__spawn_ammo_bag(__unit:position(), __unit:rotation())
						__spawn_medic_bag(__unit:position(), __unit:rotation())
						__spawn_grenade_crate(__unit:position(), __unit:rotation())
					end
				end
			end
		end
	end
	return
end

function SkirmishManager:Remove_Holdout_Wave_Reward()
	if not self:is_skirmish() then
	
	else
		self.__Wave_Rewards = self.__Wave_Rewards or {}
		for __, __unit in pairs(self.__Wave_Rewards) do
			if __unit and alive(__unit) then
				if __unit:name() == __ammo_bag_unit_name then
					__unit:base()._ammo_amount = 0
					managers.network:session():send_to_peers_synched("sync_unit_event_id_16", self._unit, "base", 1)
					__unit:base():_set_empty()
				elseif __unit:name() == __ammo_bag_unit_name then
					__unit:base()._amount = 0
					managers.network:session():send_to_peers_synched("sync_unit_event_id_16", self._unit, "base", 1)
					__unit:base():_set_empty()
				elseif __unit:name() == __grenade_crate_unit_name then
					__unit:base()._grenade_amount = 0
					managers.network:session():send_to_peers_synched("sync_unit_event_id_16", self._unit, "base", 1)
					__unit:base():_set_empty()
				end
			end
		end
		self.__Wave_Rewards = {}
	end
end

Hooks:PostHook(SkirmishManager, "on_start_assault", "F_"..Idstring("PostHook:SkirmishManager:on_start_assault:Holdout Wave Reward"):key(), function(self)
	self:Remove_Holdout_Wave_Reward()
end)

Hooks:PostHook(SkirmishManager, "init", "F_"..Idstring("PostHook:SkirmishManager:init:Holdout Wave Reward"):key(), function(self)
	self.__Wave_Rewards = self.__Wave_Rewards or {}
end)