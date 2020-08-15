Hooks:PostHook(WeaponFactoryTweakData, "init", "F_"..Idstring("PostHook:WeaponFactoryTweakData:init:DefaultModGun"):key(), function(self)	
	for part_id, part_data in pairs(self.parts) do
		self.parts[part_id].stats = {}
		self.parts[part_id].adds = {}
		self.parts[part_id].stance_mod = {}
		self.parts[part_id].perks = {}
		self.parts[part_id].override = {}
		self.parts[part_id].custom_stats = {}
		self.parts[part_id].forbids = {}
	end
end)