CharactersModule = CharactersModule or class(ItemModuleBase)

CharactersModule.type_name = "Characters"

function CharactersModule:init(core_mod, config)
	if not CharactersModule.super.init(self, core_mod, config) then
		return false
	end
	return true
end

function CharactersModule:RegisterHook()
	Hooks:PostHook(CharacterTweakData, "init", self._config.id..Idstring("CharactersModuleCharacterTweakDatainit"):key(), function(char_self)
		if char_self[self._config.id] then
			BeardLib:log("[ERROR] CharacterTweakData with id '%s' already exists!", self._config.id)
			return
		end
		local presets = char_self.presets
		char_self[self._config.id] = {
			damage = presets.gang_member_damage,
			weapon = deep_clone(presets.weapon.gang_member)
		}
		char_self[self._config.id].weapon.weapons_of_choice = {
			primary = "wpn_fps_ass_m4_npc",
			secondary = Idstring("units/payday2/weapons/wpn_npc_c45/wpn_npc_c45")
		}
		char_self[self._config.id].detection = presets.detection.gang_member
		char_self[self._config.id].move_speed = presets.move_speed.very_fast
		char_self[self._config.id].crouch_move = false
		char_self[self._config.id].speech_prefix = self._config.speech_prefix
		char_self[self._config.id].weapon_voice = self._config.weapon_voice
		char_self[self._config.id].access = self._config.access
		char_self[self._config.id].arrest = {
			timeout = 240,
			aggression_timeout = 6,
			arrest_timeout = 240
		}
	end)
	Hooks:PostHook(BlackMarketTweakData, "_init_characters", self._config.id..Idstring("CharactersModuleBlackMarketTweakData_init_characters"):key(), function(bmc_self, tweak_data)
		if bmc_self.characters[self._config.id] then
			BeardLib:log("[ERROR] BlackMarketTweakData with id '%s' already exists!", self._config.id)
			return
		end
		bmc_self.characters[self._config.id] = {
			custom = true,
			fps_unit = self._config.fps_unit,
			npc_unit = self._config.npc_unit,
			menu_unit = self._config.menu_unit,
			texture_bundle_folder = self._config.texture_bundle_folder,
			sequence = self._config.sequence,
			mask_on_sequence = self._config.mask_on_sequence,
			mask_off_sequence = self._config.mask_off_sequence
		}
		bmc_self.characters["ai_"..self._config.id] = {
			custom = true,
			npc_unit = self._config.ai_npc_unit,
			sequence = self._config.sequence,
			mask_on_sequence = self._config.mask_on_sequence,
			mask_off_sequence = self._config.mask_off_sequence
		}		
		local _characters = table.size(tweak_data.criminals.characters) + 1
		tweak_data.criminals.characters[_characters] = {
			name = self._config.id,
			order = _characters+1,
			static_data = {
				voice = "",
				ai_mask_id = self._config.id,
				ai_character_id = "ai_"..self._config.id,
				ssuffix = "v"
			},
			body_g_object = Idstring("g_body")
		}
		table.insert(tweak_data.criminals.character_names, self._config.id)
	end)
	Hooks:PostHook(EconomyTweakData, "init", self._config.id..Idstring("CharactersModuleEconomyTweakData"):key(), function(eco_self)
		local orig = self._config.character_orig
		local cc = self._config.character_cc
		eco_self.armor_skins_configs[Idstring(orig):key()] = Idstring(cc)
		eco_self.armor_skins_configs_map[Idstring(cc):key()] = Idstring(orig)	
		eco_self.character_cc_configs.locke_player = Idstring(cc)
	end)
	Hooks:PostHook(GuiTweakData, "init", self._config.id..Idstring("CharactersModuleGuiTweakData"):key(), function(gui_self)
		table.insert(gui_self.crime_net.codex[2], {
			{
				desc_id = self._config.desc_id,
				post_event = "loc_quote_set_a",
				videos = {"locke1"}
			},
			name_id = self._config.name_id,
			id = self._config.id
		})
	end)
	Hooks:PostHook(BlackMarketTweakData, "_init_masks", self._config.id..Idstring("CharactersModuleBlackMarketTweakData_init_masks"):key(), function(bmm_self)
		bmm_self.masks.character_locked[self._config.id] = self._config.default_mask
		for mask_id, mask_data in pairs(bmm_self.masks) do
			for type_id in pairs({"characters", "offsets"}) do
				if mask_data[type_id] and mask_data[type_id][self._config.id] then
					bmm_self.masks[mask_id][type_id][self._config.id] = deep_clone(mask_data[type_id][self._config.id])
				end
			end
		end
	end)
end

BeardLib:RegisterModule(CharactersModule.type_name, CharactersModule)