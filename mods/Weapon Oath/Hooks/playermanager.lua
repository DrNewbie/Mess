local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local Hook1 = "F_"..Idstring("ply::on_killshot::"..ThisModIds):key()

local function GET_POINTS(killed_unit, variant, headshot, weapon_id, weapon_base, slot_data)
	local __p = 0
	--[[]]
	if not killed_unit or not killed_unit:base() or not weapon_base then
		return 0
	end
	local char_tweak = killed_unit:base()._tweak_table
	if type(char_tweak) ~= "string" then
		return 0
	end
	local char_tweak_table = tweak_data.character[char_tweak]
	if type(char_tweak_table) ~= "table" then
		return 0
	end
	--[[]]
	if CopDamage.is_civilian(char_tweak) then
		__p = __p - 10
	elseif type(char_tweak_table.tags) == "table" and table.contains(char_tweak_table.tags, "special") then
		__p = __p + 3
	else
		__p = __p + 1
	end
	--[[]]
	if char_tweak == "medic" then
		__p = __p + 3
	elseif char_tweak == "sniper" then
		__p = __p + 3
	elseif char_tweak == "tank" then
		__p = __p + 15
	elseif char_tweak == "spooc" then
		__p = __p + 7
	elseif char_tweak == "shield" then
		__p = __p + 3
	elseif char_tweak == "taser" then
		__p = __p + 5
	elseif char_tweak == "tank_mini" then
		__p = __p + 20
	elseif char_tweak == "tank_medic" then
		__p = __p + 20
	end
	--[[]]
	return __p
end

Hooks:PostHook(PlayerManager, "on_killshot", Hook1, function(self, __killed_unit, __variant, __headshot, __weapon_id)
	local player_unit = self:player_unit()
	if not player_unit or not player_unit.inventory or not player_unit:inventory() then
	
	else
		local weapon_unit = player_unit:inventory():equipped_unit()
		if weapon_unit and alive(weapon_unit) then
			local factory_id = weapon_unit:base()._factory_id
			if factory_id then
				__weapon_id = __weapon_id or managers.weapon_factory:get_weapon_id_by_factory_id(factory_id)
				if __weapon_id then
					local weapon_tweak_data = tweak_data.weapon[__weapon_id]
					if weapon_tweak_data and type(weapon_tweak_data.__oath_data) == "table" then
						local weapon_slot, slot_category
						if weapon_tweak_data.use_data.selection_index == 2 then
							slot_category = "primaries"
							weapon_slot = managers.blackmarket:equipped_weapon_slot("primaries")
						elseif weapon_tweak_data.use_data.selection_index == 1 then
							slot_category = "secondaries"
							weapon_slot = managers.blackmarket:equipped_weapon_slot("secondaries")
						end
						if weapon_slot and slot_category then
							local slot_data = Global.blackmarket_manager.crafted_items[slot_category][weapon_slot]
							if slot_data then
								local __points = GET_POINTS(__killed_unit, __variant, __headshot, __weapon_id, weapon_unit:base(), slot_data)
								slot_data.__oath_req = weapon_tweak_data.__oath_data.__max_points
								slot_data.__oath_now = slot_data.__oath_now and slot_data.__oath_now + __points or __points
								slot_data.__oath_now = math.min(slot_data.__oath_now, slot_data.__oath_req)
								Global.blackmarket_manager.crafted_items[slot_category][weapon_slot] = slot_data
							end
						end
					end
				end
			end
		end
	end
end)