local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local Hook1 = "F_"..Idstring("Hook1::"..ThisModIds):key()

Hooks:PostHook(BlackMarketTweakData, "_init_projectiles", Hook1, function(self)
	self.projectiles.wpn_prj_four.name_id = "bm_c4_grenade_local_name"
	self.projectiles.wpn_prj_four.desc_id = "bm_c4_grenade_local_desc" 
	self.projectiles.wpn_prj_four.unit = "units/payday2/equipment/gen_equipment_tripmine/gen_equipment_c4bomb_husk"
	self.projectiles.wpn_prj_four.unit_dummy = "units/payday2/weapons/wpn_upg_dummy/wpn_upg_dummy"
	self.projectiles.wpn_prj_four.local_unit = "units/payday2/weapons/wpn_upg_dummy/wpn_upg_dummy"
	self.projectiles.wpn_prj_four.icon = "equipment_c4"
	self.projectiles.wpn_prj_four.add_trail_effect = false
end)