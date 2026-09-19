local bool1 = "F_"..Idstring("bool1::"..tostring(_G["CivilianHasGun"])):key()

local old_default_weapon_name = CopBase.default_weapon_name
function CopBase:default_weapon_name(...)
	local Ans = old_default_weapon_name(self, ...)
	if Ans then
		return Ans
	else
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
			Idstring("units/pd2_dlc_spa/weapons/wpn_npc_svd_silenced/wpn_npc_svd_silenced")
		}
		self[bool1] = true
		return AllowWeapons[table.random_key(AllowWeapons)]
	end
end