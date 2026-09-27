local ThisModPath = ModPath

local __Name = function(__id)
	return "RRR_"..Idstring(tostring(__id).."::"..ThisModPath):key()
end

local ids_unit = Idstring("unit")

function CopMovement:set_player_style_alt_mod(__data)
	if not self._unit or not alive(self._unit) then
		return
	end
	local character_name = "dallas"
	local glove_id = "heist_default" --[[table.random_key(tweak_data.blackmarket.gloves)
	if not type(tweak_data.blackmarket.gloves[glove_id]) == "table" or not type(tweak_data.blackmarket.gloves[glove_id].unit) == "string" or not DB:has(ids_unit, Idstring(tweak_data.blackmarket.gloves[glove_id].unit)) then
		glove_id = "heist_default"
	end
	managers.dyn_resource:load(ids_unit, Idstring(tweak_data.blackmarket.gloves[glove_id].unit), DynamicResourceManager.DYN_RESOURCES_PACKAGE, function()

	end)]]
	local visual_state = {
		is_local_peer = false,
		visual_seed = CriminalsManager.get_new_visual_seed(),
		player_style = __data.player_style,
		suit_variation = __data.suit_variation,
		glove_id = glove_id,
		mask_id = "none",
		armor_id = "level_1",
		armor_skin = "none"
	}
	local spawn_manager = self._unit:spawn_manager()
	local unit_damage = self._unit:damage()
	if spawn_manager and unit_damage then
		pcall(CriminalsManager.set_character_visual_state, self._unit, character_name, visual_state)
		local char_mesh_unit = spawn_manager:get_unit("char_mesh")
		if char_mesh_unit and alive(char_mesh_unit) then
			if self._unit:base()._tweak_table ~= "spooc" then
				if self._unit:get_object(Idstring("g_body")) then
					self._unit:get_object(Idstring("g_body")):set_visibility(false)
				end
			end
		end
	end
end

local allow_player_style = __Name("allow_player_style")
_G[allow_player_style] = {}

local not_allow_player_style = __Name("not_allow_player_style")
_G[not_allow_player_style] = {}

local allow_player_style_check_delay = __Name("allow_player_style_check_delay")
_G[allow_player_style_check_delay] = 7

local is_loading_resource = __Name("is_loading_resource")
_G[is_loading_resource] = false

Hooks:PostHook(CopMovement, "set_character_anim_variables", __Name(1), function(self)
	if CopDamage.is_cop(self._unit:base()._tweak_table) then
		local use_this_player_style = table.random_key(_G[allow_player_style])
		if type(use_this_player_style) == "string" and not _G[not_allow_player_style][use_this_player_style] and tweak_data.blackmarket.player_styles[use_this_player_style] then
			local tmp_ps = tweak_data.blackmarket.player_styles[use_this_player_style].material_variations
			local use_this_suit_variation = type(tmp_ps) == "table" and table.random_key(tmp_ps) or "default"
			call_on_next_update(callback(self, self, "set_player_style_alt_mod", {player_style = use_this_player_style, suit_variation = use_this_suit_variation}))
		end
	end
end)

HuskCopMovement.set_player_style_alt_mod = HuskCopMovement.set_player_style_alt_mod or CopMovement.set_player_style_alt_mod

Hooks:PostHook(HuskCopMovement, "set_character_anim_variables", __Name(2), function(self)
	CopMovement.set_character_anim_variables(self)
end)

--[[
	load outfits resource
]]
Hooks:Add("GameSetupUpdate", __Name(999), function(__t, __dt)
	if _G[allow_player_style_check_delay] then
		_G[allow_player_style_check_delay] = _G[allow_player_style_check_delay] - __dt
		if _G[allow_player_style_check_delay] <= 0 then
			_G[allow_player_style_check_delay] = 7
			local player_styles = tweak_data.blackmarket.player_styles
			for player_style_name, player_style_data in pairs(player_styles) do
				local player_style_unit_name = tweak_data.blackmarket:get_player_style_value(player_style_name, "dallas", "third_unit")
				if type(player_style_unit_name) == "string" then
					local player_style_unit_name_ids = Idstring(player_style_unit_name)
					if DB:has(ids_unit, player_style_unit_name_ids) then
						if managers.dyn_resource:is_resource_ready(ids_unit, player_style_unit_name_ids, managers.dyn_resource.DYN_RESOURCES_PACKAGE) then
							_G[allow_player_style][player_style_name] = true
							_G[not_allow_player_style][player_style_name] = false
						else
							_G[not_allow_player_style][player_style_name] = true
							if not _G[is_loading_resource] then
								_G[is_loading_resource] = true
								managers.dyn_resource:load(ids_unit, player_style_unit_name_ids, DynamicResourceManager.DYN_RESOURCES_PACKAGE, function()
									_G[is_loading_resource] = false
								end)
							end
						end
					end
				end
			end
		end
	end
end)