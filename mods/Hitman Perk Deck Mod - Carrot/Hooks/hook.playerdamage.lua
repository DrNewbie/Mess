local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local __Bool = "DT_"..Idstring("__Bool::"..ThisModIds):key()
local __Dt = "DT_"..Idstring("__Dt::"..ThisModIds):key()

Hooks:PostHook(PlayerDamage, "init", "F_"..Idstring("PlyDmg:init::"..ThisModIds):key(), function(self)
	if managers.player:has_category_upgrade("player", "guaranteed_armor_regen_hitman_mod") then
		self[__Bool] = managers.player:upgrade_value("player", "guaranteed_armor_regen_hitman_mod", 0)
	end
end)

Hooks:PostHook(PlayerDamage, "update", "F_"..Idstring("PlyDmg:update::"..ThisModIds):key(), function(self, __unit, __t, __dt)
	if self[__Bool] and type(self[__Bool]) == "number" and self[__Bool] > 0 then
		self[__Dt] = self[__Dt] or 0
		if self:_max_armor() > 0 then
			self[__Dt] = self[__Dt] + __dt
			if self[__Dt] >= self[__Bool] then
				self[__Dt] = 0
				self:_regenerate_armor()
			end
		end
	end
end)