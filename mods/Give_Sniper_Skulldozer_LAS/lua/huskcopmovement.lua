local ids_unit = Idstring("unit")

function CopMovement:set_player_style(__data)
	local character_name = "dallas"
	if self._unit and alive(self._unit) then
		local visual_state = {
			is_local_peer = false,
			visual_seed = CriminalsManager.get_new_visual_seed(),
			player_style = __data._player_style,
			suit_variation = __data._suit_variation,
			glove_id = "none",
			mask_id = "none",
			armor_id = "level_1",
			armor_skin = "none"
		}
		CriminalsManager.set_character_visual_state(
			self._unit, 
			character_name, 
			visual_state
		)
	end
end

Hooks:PostHook(CopMovement, "set_character_anim_variables", "GiveSniperSkulldozerLAS01", function(self)
	local character_name = "dallas"
	local _player_style = "las_bulldozer_skull"
	local tmp_ps = tweak_data.blackmarket.player_styles[_player_style].material_variations
	local _suit_variation = type(tmp_ps) == "table" and table.random_key(tmp_ps) or "default"
	local player_style_u_name = tweak_data.blackmarket:get_player_style_value(_player_style, character_name, "third_unit")
	if player_style_u_name then
		managers.dyn_resource:load(ids_unit, Idstring(player_style_u_name), DynamicResourceManager.DYN_RESOURCES_PACKAGE, callback(self, self, "set_player_style", {_player_style = _player_style, _suit_variation = _suit_variation}))
	end
end)

HuskCopMovement.set_player_style = HuskCopMovement.set_player_style or CopMovement.set_player_style

Hooks:PostHook(HuskCopMovement, "set_character_anim_variables", "GiveSniperSkulldozerLAS02", function(self)
	CopMovement.set_character_anim_variables(self)
end)