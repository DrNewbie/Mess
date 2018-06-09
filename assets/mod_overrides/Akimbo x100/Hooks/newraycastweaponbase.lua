Hooks:PostHook(NewRaycastWeaponBase, "_update_stats_values", "AkimboWTF_WeaponBase_Init", function(self)
	if type(self._blueprint) ~= "table" then
		return false
	end
	local tweak_factory = tweak_data.weapon.factory.parts
	for _, f_id in pairs(self._blueprint) do
		if type(tweak_factory[f_id].stats) == "table" and tweak_factory[f_id].stats.akimbo_wtf_buff then
			self._AkimboWTF = tweak_factory[f_id].stats.akimbo_wtf_buff
			self._AkimboWTFLink = tweak_factory[f_id].stats.akimbo_wtf_link
			self._total_ammo_mod = self._total_ammo_mod <= 0 and self._AkimboWTF or self._total_ammo_mod * self._AkimboWTF
			self:replenish()
			break
		end
	end
end)

local AkimboWTF_calculate_ammo_max_per_clip_New = NewRaycastWeaponBase.calculate_ammo_max_per_clip
function NewRaycastWeaponBase:calculate_ammo_max_per_clip(...)
	local Ans = AkimboWTF_calculate_ammo_max_per_clip_New(self, ...)
	if self._AkimboWTF then
		Ans = Ans * self._AkimboWTF
	end
	return Ans
end