local ids_unit = Idstring("unit")

function TeamAIMovement:set_player_style(_data)
	local character_name = self._unit:base()._tweak_table
	local loadout = managers.criminals:get_loadout_for(character_name)
	if loadout and self._unit and alive(self._unit) then
		CriminalsManager.set_character_visual_state(
			self._unit, 
			character_name, 
			false, --is_local_peer, 
			CriminalsManager.get_new_visual_seed(), --visual_seed, 
			_data._player_style, --player_style, 
			_data._suit_variation, --suit_variation, 
			Idstring(tostring(os.time())..tostring("/t")..tostring(math.random())..tostring(self._unit)):key(), --mask_id, 
			loadout.armor or "level_1", --armor_id, 
			loadout.armor_skins or "none"--armor_skin
		)
	end
end

Hooks:PostHook(TeamAIMovement, "set_character_anim_variables", "BotPlayerStyle_TeamAI_post_init", function(self)
	local character_name = self._unit:base()._tweak_table
	local _player_style = table.random_key(tweak_data.blackmarket.player_styles) or "none"
	local tmp_ps = tweak_data.blackmarket.player_styles[_player_style].material_variations
	local _suit_variation = type(tmp_ps) == "table" and table.random_key(tmp_ps) or "default"
	local player_style_u_name = tweak_data.blackmarket:get_player_style_value(_player_style, character_name, "third_unit")
	if player_style_u_name then
		managers.dyn_resource:load(ids_unit, Idstring(player_style_u_name), DynamicResourceManager.DYN_RESOURCES_PACKAGE, callback(self, self, "set_player_style", {_player_style = _player_style, _suit_variation = _suit_variation}))
	end
end)

HuskTeamAIMovement.set_player_style = HuskTeamAIMovement.set_player_style or TeamAIMovement.set_player_style

Hooks:PostHook(HuskTeamAIMovement, "set_character_anim_variables", "BotPlayerStyle_HuskTeamAI_post_init", function(self)
	TeamAIMovement.set_character_anim_variables(self)
end)