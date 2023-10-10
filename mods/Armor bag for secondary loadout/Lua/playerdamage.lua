local ThisModPath = ModPath

_G.ArmorBag4S = _G.ArmorBag4S or {}

local __Name = function(__id)
	return "GGG_"..Idstring(tostring(__id).."::"..ThisModPath):key()
end

ArmorBag4S.Record_Times = ArmorBag4S.Record_Times or 0

local bool_PlyOnUseArmorBagPostHook = false
Hooks:PostHook(PlayerDamage, "_on_use_armor_bag_event", __Name(1), function(self)
	local equipments, i = managers.player:equipment_data_by_name("armor_kit")
	if i and type(i) == "number" then
		if managers.player:get_equipment_amount("armor_kit", i) == 0 then
			self._unit:inventory():equip_from_armor_bag(bool_PlyOnUseArmorBagPostHook)
			bool_PlyOnUseArmorBagPostHook = not bool_PlyOnUseArmorBagPostHook
			managers.player:set_equipment_amount("armor_kit", i, 1)
			ArmorBag4S.Record_Times = ArmorBag4S.Record_Times + 1
		end
	end
end)

local bool_PlyUpdatePostHook = false
Hooks:PostHook(PlayerDamage, "update", __Name(2), function(self, unit, t)
	if not bool_PlyUpdatePostHook and game_state_machine and Utils and Utils:IsInHeist() then
		bool_PlyUpdatePostHook = true
		dofile(ThisModPath.."Lua/blackmarketmanager.lua")
	end
end)