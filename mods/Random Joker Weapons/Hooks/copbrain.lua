local AllowWeapons = {
	Idstring("units/payday2/weapons/wpn_npc_beretta92/wpn_npc_beretta92"),
	Idstring("units/payday2/weapons/wpn_npc_raging_bull/wpn_npc_raging_bull"),
	Idstring("units/payday2/weapons/wpn_npc_m4/wpn_npc_m4"),
	Idstring("units/payday2/weapons/wpn_npc_m4_yellow/wpn_npc_m4_yellow"),
	Idstring("units/payday2/weapons/wpn_npc_ak47/wpn_npc_ak47"),
	Idstring("units/payday2/weapons/wpn_npc_r870/wpn_npc_r870"),
	Idstring("units/payday2/weapons/wpn_npc_sawnoff_shotgun/wpn_npc_sawnoff_shotgun"),
	Idstring("units/payday2/weapons/wpn_npc_mp5/wpn_npc_mp5"),
	Idstring("units/payday2/weapons/wpn_npc_mp5_tactical/wpn_npc_mp5_tactical"),
	Idstring("units/payday2/weapons/wpn_npc_smg_mp9/wpn_npc_smg_mp9"),
	Idstring("units/payday2/weapons/wpn_npc_mac11/wpn_npc_mac11"),
	Idstring("units/payday2/weapons/wpn_npc_sniper/wpn_npc_sniper"),
	Idstring("units/payday2/weapons/wpn_npc_saiga/wpn_npc_saiga"),
	Idstring("units/payday2/weapons/wpn_npc_lmg_m249/wpn_npc_lmg_m249"),
	Idstring("units/payday2/weapons/wpn_npc_benelli/wpn_npc_benelli"),
	Idstring("units/payday2/weapons/wpn_npc_g36/wpn_npc_g36"),
	Idstring("units/payday2/weapons/wpn_npc_ump/wpn_npc_ump"),
	Idstring("units/payday2/weapons/wpn_npc_scar_murkywater/wpn_npc_scar_murkywater"),
	Idstring("units/pd2_dlc_mad/weapons/wpn_npc_rpk/wpn_npc_rpk"),
	Idstring("units/pd2_dlc_mad/weapons/wpn_npc_svd/wpn_npc_svd"),
	Idstring("units/pd2_dlc_mad/weapons/wpn_npc_akmsu/wpn_npc_akmsu"),
	Idstring("units/pd2_dlc_mad/weapons/wpn_npc_asval/wpn_npc_asval"),
	Idstring("units/pd2_dlc_mad/weapons/wpn_npc_sr2/wpn_npc_sr2"),
	Idstring("units/pd2_dlc_mad/weapons/wpn_npc_ak47/wpn_npc_ak47"),
	Idstring("units/pd2_dlc_chico/weapons/wpn_npc_sg417/wpn_npc_sg417"),
	Idstring("units/pd2_dlc_spa/weapons/wpn_npc_svd_silenced/wpn_npc_svd_silenced"),
	Idstring("units/pd2_dlc_drm/weapons/wpn_npc_mini/wpn_npc_mini"),
	Idstring("units/pd2_dlc_drm/weapons/wpn_npc_heavy_zeal_sniper/wpn_npc_heavy_zeal_sniper")
}

function CopBrain:GiveNewRandomWeapon(data)
	damage_multiplier = data.damage_multiplier
	new_weapon_ids = data.new_weapon_ids
	TeamAIInventory.add_unit_by_name(self._unit:inventory(), new_weapon_ids, true)
	local _ = weapon and self._unit:inventory():add_unit_by_factory_name(weapon, false, false, nil, "")
	local weapon_unit = self._unit:inventory():equipped_unit()
	weapon_unit:base():add_damage_multiplier(damage_multiplier)
end

Hooks:PostHook(CopBrain, "convert_to_criminal", "F_"..Idstring("CopBrain:convert_to_criminal"):key(), function(self, mastermind_criminal)
	local damage_multiplier = 1
	if alive(mastermind_criminal) then
		damage_multiplier = damage_multiplier * (mastermind_criminal:base():upgrade_value("player", "convert_enemies_damage_multiplier") or 1)
		damage_multiplier = damage_multiplier * (mastermind_criminal:base():upgrade_value("player", "passive_convert_enemies_damage_multiplier") or 1)
	else
		damage_multiplier = damage_multiplier * managers.player:upgrade_value("player", "convert_enemies_damage_multiplier", 1)
		damage_multiplier = damage_multiplier * managers.player:upgrade_value("player", "passive_convert_enemies_damage_multiplier", 1)
	end
	local new_weapon_ids = AllowWeapons[table.random_key(AllowWeapons)]
	local equipped_w_selection = self._unit:inventory():equipped_selection()
	if equipped_w_selection then
		self._unit:inventory():remove_selection(equipped_w_selection, true)
	end
	if not managers.dyn_resource:is_resource_ready(Idstring("unit"), new_weapon_ids, managers.dyn_resource.DYN_RESOURCES_PACKAGE) then
		managers.dyn_resource:load(Idstring("unit"), new_weapon_ids, managers.dyn_resource.DYN_RESOURCES_PACKAGE, callback(self, self, "GiveNewRandomWeapon", {new_weapon_ids = new_weapon_ids, damage_multiplier = damage_multiplier}))
	else
		self:GiveNewRandomWeapon({new_weapon_ids = new_weapon_ids, damage_multiplier = damage_multiplier})
	end
end)