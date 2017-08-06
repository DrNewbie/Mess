function BlackMarketTweakData:_init_deployables(tweak_data)
	self.deployables = {}
	self.deployables.doctor_bag = {}
	self.deployables.doctor_bag.name_id = "bm_equipment_doctor_bag"
	self.deployables.ammo_bag = {}
	self.deployables.ammo_bag.name_id = "bm_equipment_ammo_bag"
	self.deployables.ecm_jammer = {}
	self.deployables.ecm_jammer.name_id = "bm_equipment_ecm_jammer"
	self.deployables.sentry_gun = {}
	self.deployables.sentry_gun.name_id = "bm_equipment_sentry_gun"
	self.deployables.sentry_gun_silent = {}
	self.deployables.sentry_gun_silent.name_id = "bm_equipment_sentry_gun_silent"
	self.deployables.trip_mine = {}
	self.deployables.trip_mine.name_id = "bm_equipment_trip_mine"
	self.deployables.armor_kit = {}
	self.deployables.armor_kit.name_id = "bm_equipment_armor_kit"
	self.deployables.first_aid_kit = {}
	self.deployables.first_aid_kit.name_id = "bm_equipment_first_aid_kit"
	self.deployables.bodybags_bag = {}
	self.deployables.bodybags_bag.name_id = "bm_equipment_bodybags_bag"
	self.deployables.trip_mine_silent = {}
	self.deployables.trip_mine_silent.name_id = "bm_equipment_trip_mine_silent"
	self:_add_desc_from_name_macro(self.deployables)
end