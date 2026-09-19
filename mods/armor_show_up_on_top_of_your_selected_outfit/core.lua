local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local __Name = function(__id)
	return "Armor_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end

local Func1 = __Name("force_apply_armor")
local Bool1 = __Name("Bool1")

local function force_apply_armor(unit, armor_id)
	if not unit or not alive(unit) or type(armor_id) ~= "string" then
	
	else
		local armor_part = {
			level_2 = {
				"g_vest_small"
			},
			level_3 = {
				"g_vest_body"
			},
			level_4 = {
				"g_vest_body",
				"g_vest_neck"
			},
			level_5 = {
				"g_vest_body",
				"g_vest_shoulder",
				"g_vest_neck"
			},
			level_6 = {
				"g_vest_body",
				"g_vest_shoulder",
				"g_vest_neck",
				"g_vest_thies"
			},
			level_7 = {
				"g_vest_body",
				"g_vest_shoulder",
				"g_vest_neck",
				"g_vest_thies",
				"g_vest_leg_arm"
			}
		}
		local armor_data = armor_part[armor_id]
		if armor_data then
			for _, __ids in pairs(armor_data) do
				if unit:get_object(Idstring(__ids)) then
					unit:get_object(Idstring(__ids)):set_visibility(true)
				end
			end
		end		
	end
end

if MenuArmourBase and not MenuArmourBase[Bool1] then
	MenuArmourBase[Bool1] = true
	Hooks:PostHook(MenuArmourBase, "_apply_cosmetics", __Name("hook::1"), function(self, ...)
		call_on_next_update(
			function ()
				pcall(force_apply_armor, self._unit, self._armor_id)
			end
		)
	end)
	Hooks:PostHook(MenuArmourBase, "update_character_visuals", __Name("hook::2"), function(self, ...)
		call_on_next_update(
			function ()
				pcall(force_apply_armor, self._unit, self._armor_id)
			end
		)
	end)
end

if PlayerDamage and not PlayerDamage[Bool1] then
	PlayerDamage[Bool1] = true
	Hooks:PostHook(PlayerDamage, "init", __Name("hook::3"), function(self, ...)
		local armor_id = managers.blackmarket:equipped_armor()
		call_on_next_update(
			function ()
				pcall(force_apply_armor, self._unit, armor_id)
			end
		)
	end)
end

if CriminalsManager and not CriminalsManager[Bool1] then
	CriminalsManager[Bool1] = true
	Hooks:PostHook(CriminalsManager, "update_character_visual_state", __Name("hook::4"), function(self, character_name, visual_state, ...)
		local character = self:character_by_name(character_name)
		if not character or not character.unit or not alive(character.unit) then
		
		else
			local armor_id = visual_state.armor_id or character.visual_state.armor_id or "level_1"
			call_on_next_update(
				function ()
					pcall(force_apply_armor, character.unit, armor_id)
				end
			)
		end
	end)
end