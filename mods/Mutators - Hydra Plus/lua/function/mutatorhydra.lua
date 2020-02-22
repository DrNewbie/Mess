Hooks:PostHook(MutatorHydra, "_max_splits", "F_"..Idstring("PostHook:MutatorHydra:_max_splits:Mutators - Hydra Plus"):key(), function(self)
	return 128
end)

MutatorHydra.re_raw_enemy_list = {
	["units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3"] = {},
	["units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2"] = {
		{
			"units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3",
			3
		},
		{
			"units/payday2/characters/ene_spook_1/ene_spook_1",
			1
		}
	},
	["units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1"] = {
		{
			"units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2",
			3
		},
		{
			"units/payday2/characters/ene_spook_1/ene_spook_1",
			1
		}
	},
	["units/pd2_dlc_vip/characters/ene_vip_1/ene_vip_1"] = {},
	["units/pd2_dlc_vip/characters/ene_phalanx_1/ene_phalanx_1"] = {
		{
			"units/payday2/characters/ene_tazer_1/ene_tazer_1",
			3
		},
		{
			"units/payday2/characters/ene_spook_1/ene_spook_1",
			1
		}
	},
	["units/payday2/characters/ene_shield_1/ene_shield_1"] = {
		{
			"units/payday2/characters/ene_tazer_1/ene_tazer_1",
			3
		},
		{
			"units/payday2/characters/ene_spook_1/ene_spook_1",
			1
		}
	},
	["units/payday2/characters/ene_shield_2/ene_shield_2"] = {
		{
			"units/payday2/characters/ene_tazer_1/ene_tazer_1",
			4
		},
		{
			"units/payday2/characters/ene_spook_1/ene_spook_1",
			1
		}
	},
	["units/payday2/characters/ene_sniper_2/ene_sniper_2"] = {},
	["units/payday2/characters/ene_sniper_1/ene_sniper_1"] = {},
	["units/payday2/characters/ene_medic_m4/ene_medic_m4"] = {
		"units/payday2/characters/ene_spook_1/ene_spook_1",
		"units/payday2/characters/ene_tazer_1/ene_tazer_1"
	},
	["units/payday2/characters/ene_medic_r870/ene_medic_r870"] = {
		"units/payday2/characters/ene_spook_1/ene_spook_1",
		"units/payday2/characters/ene_tazer_1/ene_tazer_1"
	},
	["units/payday2/characters/ene_spook_1/ene_spook_1"] = {
		"units/payday2/characters/ene_tazer_1/ene_tazer_1"
	},
	["units/payday2/characters/ene_tazer_1/ene_tazer_1"] = {
		"units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1"
	},
	["units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer/ene_zeal_bulldozer"] = {},
	["units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer_3/ene_zeal_bulldozer_3"] = {
		"units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer/ene_zeal_bulldozer"
	},
	["units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer_2/ene_zeal_bulldozer_2"] = {
		"units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer_3/ene_zeal_bulldozer_3"
	},
	["units/pd2_dlc_gitgud/characters/ene_zeal_swat_shield/ene_zeal_swat_shield"] = {
		"units/pd2_dlc_gitgud/characters/ene_zeal_cloaker/ene_zeal_cloaker"
	},
	["units/pd2_dlc_gitgud/characters/ene_zeal_cloaker/ene_zeal_cloaker"] = {
		"units/pd2_dlc_gitgud/characters/ene_zeal_tazer/ene_zeal_tazer"
	},
	["units/pd2_dlc_gitgud/characters/ene_zeal_tazer/ene_zeal_tazer"] = {
		"units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer_2/ene_zeal_bulldozer_2"
	},
	["units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy/ene_zeal_swat_heavy"] = {
		"units/pd2_dlc_gitgud/characters/ene_zeal_swat_shield/ene_zeal_swat_shield"
	},
	["units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat"] = {
		"units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy/ene_zeal_swat_heavy"
	},
	["units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1"] = {
		{
			"units/payday2/characters/ene_spook_1/ene_spook_1",
			1
		},
		{
			"units/payday2/characters/ene_shield_1/ene_shield_1",
			1
		},
		{
			"units/payday2/characters/ene_shield_2/ene_shield_2",
			1
		}
	},
	["units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"] = {
		"units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1"
	},
	["units/payday2/characters/ene_city_swat_3/ene_city_swat_3"] = {
		"units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"
	},
	["units/payday2/characters/ene_city_swat_2/ene_city_swat_2"] = {
		"units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"
	},
	["units/payday2/characters/ene_city_swat_1/ene_city_swat_1"] = {
		"units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"
	},
	["units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2"] = {
		"units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"
	},
	["units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"] = {
		"units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"
	},
	["units/payday2/characters/ene_swat_2/ene_swat_2"] = {
		"units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"
	},
	["units/payday2/characters/ene_swat_1/ene_swat_1"] = {
		"units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"
	},
	["units/payday2/characters/ene_fbi_3/ene_fbi_3"] = {
		"units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"
	},
	["units/payday2/characters/ene_fbi_2/ene_fbi_2"] = {
		"units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"
	},
	["units/payday2/characters/ene_fbi_1/ene_fbi_1"] = {
		"units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"
	},
	["units/payday2/characters/ene_cop_1/ene_cop_1"] = {
		"units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"
	},
	["units/payday2/characters/ene_cop_2/ene_cop_2"] = {
		"units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"
	},
	["units/payday2/characters/ene_cop_3/ene_cop_3"] = {
		"units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"
	},
	["units/payday2/characters/ene_cop_4/ene_cop_4"] = {
		"units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"
	},
	["units/pd2_dlc_mad/characters/ene_akan_fbi_tank_rpk_lmg/ene_akan_fbi_tank_rpk_lmg"] = {},
	["units/pd2_dlc_mad/characters/ene_akan_fbi_tank_saiga/ene_akan_fbi_tank_saiga"] = {
		{
			"units/pd2_dlc_mad/characters/ene_akan_fbi_tank_rpk_lmg/ene_akan_fbi_tank_rpk_lmg",
			3
		},
		{
			"units/pd2_dlc_mad/characters/ene_akan_fbi_spooc_asval_smg/ene_akan_fbi_spooc_asval_smg",
			1
		}
	},
	["units/pd2_dlc_mad/characters/ene_akan_fbi_tank_r870/ene_akan_fbi_tank_r870"] = {
		{
			"units/pd2_dlc_mad/characters/ene_akan_fbi_tank_saiga/ene_akan_fbi_tank_saiga",
			3
		},
		{
			"units/pd2_dlc_mad/characters/ene_akan_fbi_spooc_asval_smg/ene_akan_fbi_spooc_asval_smg",
			1
		}
	},
	["units/pd2_dlc_mad/characters/ene_akan_fbi_shield_sr2_smg/ene_akan_fbi_shield_sr2_smg"] = {
		{
			"units/pd2_dlc_mad/characters/ene_akan_cs_tazer_ak47_ass/ene_akan_cs_tazer_ak47_ass",
			1
		},
		{
			"units/pd2_dlc_mad/characters/ene_akan_fbi_spooc_asval_smg/ene_akan_fbi_spooc_asval_smg",
			4
		}
	},
	["units/pd2_dlc_mad/characters/ene_akan_cs_shield_c45/ene_akan_cs_shield_c45"] = {
		{
			"units/pd2_dlc_mad/characters/ene_akan_cs_tazer_ak47_ass/ene_akan_cs_tazer_ak47_ass",
			1
		},
		{
			"units/pd2_dlc_mad/characters/ene_akan_fbi_spooc_asval_smg/ene_akan_fbi_spooc_asval_smg",
			4
		}
	},
	["units/pd2_dlc_mad/characters/ene_akan_cs_tazer_ak47_ass/ene_akan_cs_tazer_ak47_ass"] = {
		"units/pd2_dlc_mad/characters/ene_akan_fbi_tank_r870/ene_akan_fbi_tank_r870"
	},
	["units/pd2_dlc_mad/characters/ene_akan_fbi_spooc_asval_smg/ene_akan_fbi_spooc_asval_smg"] = {
		"units/pd2_dlc_mad/characters/ene_akan_cs_tazer_ak47_ass/ene_akan_cs_tazer_ak47_ass"
	},
	["units/pd2_dlc_mad/characters/ene_akan_fbi_swat_dw_ak47_ass/ene_akan_fbi_swat_dw_ak47_ass"] = {
		"units/pd2_dlc_mad/characters/ene_akan_fbi_spooc_asval_smg/ene_akan_fbi_spooc_asval_smg"
	},
	["units/pd2_dlc_mad/characters/ene_akan_fbi_swat_dw_r870/ene_akan_fbi_swat_dw_r870"] = {
		"units/pd2_dlc_mad/characters/ene_akan_fbi_spooc_asval_smg/ene_akan_fbi_spooc_asval_smg"
	},
	["units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_g36/ene_akan_fbi_heavy_g36"] = {
		"units/pd2_dlc_mad/characters/ene_akan_fbi_swat_dw_ak47_ass/ene_akan_fbi_swat_dw_ak47_ass",
		"units/pd2_dlc_mad/characters/ene_akan_fbi_swat_dw_r870/ene_akan_fbi_swat_dw_r870"
	},
	["units/pd2_dlc_mad/characters/ene_akan_fbi_swat_r870/ene_akan_fbi_swat_r870"] = {
		"units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_g36/ene_akan_fbi_heavy_g36"
	},
	["units/pd2_dlc_mad/characters/ene_akan_fbi_swat_ak47_ass/ene_akan_fbi_swat_ak47_ass"] = {
		"units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_g36/ene_akan_fbi_heavy_g36"
	},
	["units/pd2_dlc_mad/characters/ene_akan_cs_heavy_ak47_ass/ene_akan_cs_heavy_ak47_ass"] = {
		"units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_g36/ene_akan_fbi_heavy_g36"
	},
	["units/pd2_dlc_mad/characters/ene_akan_cs_swat_r870/ene_akan_cs_swat_r870"] = {
		"units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_g36/ene_akan_fbi_heavy_g36"
	},
	["units/pd2_dlc_mad/characters/ene_akan_cs_swat_ak47_ass/ene_akan_cs_swat_ak47_ass"] = {
		"units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_g36/ene_akan_fbi_heavy_g36"
	},
	["units/pd2_dlc_mad/characters/ene_akan_cs_cop_akmsu_smg/ene_akan_cs_cop_akmsu_smg"] = {
		"units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_g36/ene_akan_fbi_heavy_g36"
	},
	["units/pd2_dlc_mad/characters/ene_akan_cs_cop_r870/ene_akan_cs_cop_r870"] = {
		"units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_g36/ene_akan_fbi_heavy_g36"
	},
	["units/pd2_dlc_mad/characters/ene_akan_cs_cop_asval_smg/ene_akan_cs_cop_asval_smg"] = {
		"units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_g36/ene_akan_fbi_heavy_g36"
	},
	["units/payday2/characters/ene_murkywater_1/ene_murkywater_1"] = {
		"units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"
	},
	["units/payday2/characters/ene_murkywater_2/ene_murkywater_2"] = {
		"units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"
	},
	["units/pd2_dlc_berry/characters/ene_murkywater_no_light/ene_murkywater_no_light"] = {
		"units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"
	},
	["units/pd2_mcmansion/characters/ene_male_hector_1/ene_male_hector_1"] = {
		"units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"
	},
	["units/pd2_mcmansion/characters/ene_male_hector_2/ene_male_hector_2"] = {
		"units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"
	},
	["units/pd2_dlc_born/characters/ene_gang_biker_boss/ene_gang_biker_boss"] = {
		"units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"
	},
	["units/payday2/characters/ene_gang_mobster_boss/ene_gang_mobster_boss"] = {
		"units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"
	},
	["units/payday2/characters/ene_gang_mobster_4/ene_gang_mobster_4"] = {
		"units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"
	},
	["units/payday2/characters/ene_gang_mobster_3/ene_gang_mobster_3"] = {
		"units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"
	},
	["units/payday2/characters/ene_gang_mobster_2/ene_gang_mobster_2"] = {
		"units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"
	},
	["units/payday2/characters/ene_gang_mobster_1/ene_gang_mobster_1"] = {
		"units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"
	},
	["units/payday2/characters/ene_secret_service_2/ene_secret_service_2"] = {
		"units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"
	},
	["units/payday2/characters/ene_secret_service_1/ene_secret_service_1"] = {
		"units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"
	},
	["units/payday2/characters/ene_security_3/ene_security_3"] = {
		"units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"
	},
	["units/payday2/characters/ene_security_2/ene_security_2"] = {
		"units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"
	},
	["units/payday2/characters/ene_security_1/ene_security_1"] = {
		"units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"
	},
	["units/payday2/characters/ene_biker_4/ene_biker_4"] = {
		"units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"
	},
	["units/payday2/characters/ene_biker_3/ene_biker_3"] = {
		"units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"
	},
	["units/payday2/characters/ene_biker_2/ene_biker_2"] = {
		"units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"
	},
	["units/payday2/characters/ene_biker_1/ene_biker_1"] = {
		"units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"
	},
	["units/payday2/characters/ene_gang_mexican_4/ene_gang_mexican_4"] = {
		"units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"
	},
	["units/payday2/characters/ene_gang_mexican_3/ene_gang_mexican_3"] = {
		"units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"
	},
	["units/payday2/characters/ene_gang_mexican_2/ene_gang_mexican_2"] = {
		"units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"
	},
	["units/payday2/characters/ene_gang_mexican_1/ene_gang_mexican_1"] = {
		"units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"
	},
	["units/payday2/characters/ene_gang_black_4/ene_gang_black_4"] = {
		"units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"
	},
	["units/payday2/characters/ene_gang_black_3/ene_gang_black_3"] = {
		"units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"
	},
	["units/payday2/characters/ene_gang_black_2/ene_gang_black_2"] = {
		"units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"
	},
	["units/payday2/characters/ene_gang_black_1/ene_gang_black_1"] = {
		"units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"
	},
	["units/payday2/characters/ene_gang_russian_3/ene_gang_russian_3"] = {
		"units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"
	},
	["units/payday2/characters/ene_gang_russian_2/ene_gang_russian_2"] = {
		"units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"
	},
	["units/payday2/characters/ene_gang_russian_1/ene_gang_russian_1"] = {
		"units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"
	}
}

Hooks:Add("LocalizationManagerPostInit", "F_"..Idstring("Hooks:Add:Localization:Add_Re_Toggle:Mutators - Hydra Plus"):key(), function(loc)
	LocalizationManager:add_localized_strings({
		["menu_hydra_re_toggle"] = "Reverse",
		["menu_hydra_re_new_desc_id"] = "Killing an enemy will split them into 2 stronger enemies."
	})
end)

Hooks:PostHook(MutatorHydra, "register_values", "F_"..Idstring("PostHook:MutatorHydra:register_values:Mutators - Hydra Plus"):key(), function(self)
	self:register_value("toggle_hydra_re", false, "nd")
end)

function MutatorHydra:_toggle_hydra_re(item)
	self:set_value("toggle_hydra_re", item:value() == "on")
end

function MutatorHydra:use_toggle_hydra_re()
	return self:value("toggle_hydra_re")
end

Hooks:PostHook(MutatorHydra, "setup_options_gui", "F_"..Idstring("PostHook:MutatorHydra:setup_options_gui:Add_Re_Toggle:Mutators - Hydra Plus"):key(), function(self, node)
	local params = {
		name = "hydra_re_toggle",
		text_id = "menu_hydra_re_toggle",
		callback = "_update_mutator_value",
		update_callback = callback(self, self, "_toggle_hydra_re")
	}
	local data_node = {
		type = "CoreMenuItemToggle.ItemToggle",
		{
			_meta = "option",
			icon = "guis/textures/menu_tickbox",
			value = "on",
			x = 24,
			y = 0,
			w = 24,
			h = 24,
			s_icon = "guis/textures/menu_tickbox",
			s_x = 24,
			s_y = 24,
			s_w = 24,
			s_h = 24
		},
		{
			_meta = "option",
			icon = "guis/textures/menu_tickbox",
			value = "off",
			x = 0,
			y = 0,
			w = 24,
			h = 24,
			s_icon = "guis/textures/menu_tickbox",
			s_x = 0,
			s_y = 24,
			s_w = 24,
			s_h = 24
		}
	}
	local new_item = node:create_item(data_node, params)
	new_item:set_value(self:use_toggle_hydra_re() and "on" or "off")
	node:add_item(new_item)
	self._node = node
	return new_item
end)

Hooks:PostHook(MutatorHydra, "name", "F_"..Idstring("PostHook:MutatorHydra:name:Mutators - Hydra Plus"):key(), function(self)
	MutatorHydra.desc_id = "mutator_hydra_desc"
	if self:_mutate_name("max_unit_depth") and self:use_toggle_hydra_re() then
		local _is_reverse = "YES"
		local name = MutatorHydra.super.name(self)
		local macros = {
			splits = self:value("max_unit_depth")
		}		
		return string.format("%s - %s , Reverse: %s", name, managers.localization:text("mutator_hydra_split_num", macros), _is_reverse)
	end
end)

Hooks:PostHook(MutatorHydra, "_spawn_unit", "F_"..Idstring("PostHook:MutatorHydra:_spawn_unit:Mutators - Hydra Plus"):key(), function(self)
	if type(self._hydra_spawns) == "table" then
		local i = 1
		for i, d in pairs(self._hydra_spawns) do
			if type(d) == "table" and not d.__slow_down then
				self._hydra_spawns[i].__slow_down = true
				self._hydra_spawns[i].t = 0.1 + math.round(i/4) * 0.2
				i = i + 1
			end
		end
	end
end)

Hooks:PostHook(MutatorHydra, "_setup_enemy_list", "F_"..Idstring("PostHook:MutatorHydra:_setup_enemy_list:Mutators - Hydra Plus"):key(), function(self)
	if self:use_toggle_hydra_re() then
		local converted_list = {}
		local _lise = self.re_raw_enemy_list
		for k, units in pairs(_lise) do
			local selector = WeightedSelector:new()
			local _k = Idstring(k):key()
			for i, unit_data in pairs(units) do
				if type(unit_data) == "table" then
					selector:add(unit_data[1] and Idstring(unit_data[1]) or false, unit_data[2] or 1)
				else
					selector:add(Idstring(unit_data), 1)
				end
			end
			converted_list[_k] = selector
		end
		self.enemy_list = converted_list
		return
	end
end)