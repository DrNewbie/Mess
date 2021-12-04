require("lib/units/interactions/InteractionExt")

if not DB:has("unit", "units/dev_tools/mission_elements/point_interaction/carry_interaction_dummy_nosync") then
	return
end

if not Global.game_settings or not Global.game_settings.single_player or not Global.game_settings.level_id or Global.game_settings.level_id ~= "mus" then
	return
end

local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local hook3 = "F_"..Idstring("hook3::"..ThisModIds):key()
local hook4 = "F_"..Idstring("hook4::"..ThisModIds):key()
local hook5 = "F_"..Idstring("hook5::"..ThisModIds):key()
local IsSpwanDone

CarryInteractionDummyExt = CarryInteractionDummyExt or CarryInteractionExt

CarryInteractionDummyExt.old_can_select = CarryInteractionDummyExt.old_can_select or CarryInteractionDummyExt.can_select

function CarryInteractionDummyExt:can_select(player, ...)
	local AddCheck = true
	if player and player:movement() and player:movement()._current_state._ext_camera and self.__remove_this_unit and alive(self.__remove_this_unit) then
		local camera = player:movement()._current_state._ext_camera
		local mvec_to = Vector3()
		local from_pos = camera:position()
		mvector3.set(mvec_to, camera:forward())
		mvector3.multiply(mvec_to, 1000)
		mvector3.add(mvec_to, from_pos)
		local col_ray = World:raycast("ray", from_pos, mvec_to, "slot_mask", managers.slot:get_mask("all"))
		if col_ray and col_ray.unit and col_ray.unit == self.__remove_this_unit then

		else
			AddCheck = false
		end
	end
	return AddCheck and self:old_can_select(player, ...) or false
end

function CarryInteractionDummyExt:set_remove_unit_on_interact(unit)
	self.__remove_this_unit = unit
end

function CarryInteractionDummyExt:sync_interacted(peer, player, status, skip_alive_check)
	local no_player = player == nil
	player = player or peer:unit()
	if peer and not managers.player:register_carry(peer, self._unit:carry_data() and self._unit:carry_data():carry_id()) then
		return
	end
	if Network:is_server() then
		if self._remove_on_interact then
			if self._unit == managers.interaction:active_unit() then
				self:interact_interupt(managers.player:player_unit(), false)
			end
			self:remove_interact()
			self:set_active(false, true)
			if alive(player) then
				self._unit:carry_data():trigger_load(player)
			end
			self._unit:set_slot(0)
		end
		if peer then
			managers.player:set_carry_approved(peer)
		end
	end
end

local LootTempGuns = {
	_carry_id = "weapon",
	tweak_data = "take_weapons"
}

local AddonLootList = {
	[Idstring("units/pd2_dlc_jfr/props/jfr_props_wpn_m1918/jfr_props_wpn_m1918"):key()] = LootTempGuns,
	[Idstring("units/pd2_dlc_aru/props/aru_prop_weapons/aru_prop_ching_rifle"):key()] = LootTempGuns,
	[Idstring("units/pd2_dlc_jfr/props/jfr_props_wpn_thompson/jfr_props_wpn_thompson"):key()] = LootTempGuns,
	[Idstring("units/pd2_dlc_jfr/props/jfr_props_wpn_m1911/jfr_props_wpn_m1911"):key()] = LootTempGuns,
	[Idstring("units/pd2_dlc_jfr/props/jfr_props_ammos_boxes/jfr_props_ammos_boxes_05"):key()] = LootTempGuns,
}

Hooks:PreHook(CarryInteractionDummyExt, "remove_interact", hook4, function(self)
	if self.__remove_this_unit and alive(self.__remove_this_unit) then
		self.__remove_this_unit:set_slot(0)
		self.__remove_this_unit = nil
	end
end)

Hooks:PostHook(PlayerStandard, "update", hook3, function(self)
	if IsSpwanDone or not Global.game_settings or not Global.game_settings.level_id or Global.game_settings.level_id ~= "mus" then
	
	else
		IsSpwanDone = true
		local units = World:find_units_quick("all")
		for _, __unit in pairs(units) do
			if AddonLootList[__unit:name():key()] then
				local __data = AddonLootList[__unit:name():key()]
				local __carry_dummy = World:spawn_unit(Idstring("units/dev_tools/mission_elements/point_interaction/carry_interaction_dummy_nosync"), __unit:position() + Vector3(0, 0, 3), Rotation())
				if __carry_dummy and __carry_dummy.interaction and __carry_dummy:interaction() then
					__carry_dummy:interaction():set_remove_unit_on_interact(__unit)
					if __data.tweak_data then
						__carry_dummy:interaction():set_tweak_data(__data.tweak_data)
					end
					__carry_dummy:interaction():set_active(true)
				end
				if __carry_dummy and __carry_dummy.carry_data and __carry_dummy:carry_data() then
					if __data._carry_id then
						__carry_dummy:carry_data()._carry_id = __data._carry_id
					end
				end
			end
		end
	end
end)