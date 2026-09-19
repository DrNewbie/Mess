local mod_ids = Idstring("lololol::costs 400 thousand dollars to fire this weapon for 12 seconds"):key()
local hook1 = "H_"..Idstring("NewRaycastWeaponBase:replenish:"..mod_ids):key()
local bool1 = "B_"..Idstring(hook1.."::"..mod_ids):key()
local hook2 = "H_"..Idstring("hook2::"..mod_ids):key()
local var2 = "V_"..Idstring(hook2.."::"..mod_ids):key()
local hook3 = "H_"..Idstring("hook3::"..mod_ids):key()
local ThisAmmoFire = 0
local ThisAmmoCost = 1000

Hooks:PostHook(NewRaycastWeaponBase, "replenish", hook1, function(self)
	if table.contains(self:weapon_tweak_data().categories, "minigun") then
		self[bool1] = true
		self[var2] = self:get_ammo_total()
	end
end)

Hooks:PreHook(NewRaycastWeaponBase, "fire", hook2, function(self)
	if self[bool1] then
		self[var2] = self:get_ammo_total()
	end
end)

Hooks:PostHook(NewRaycastWeaponBase, "fire", hook3, function(self)
	if self[bool1] and self[var2] and self:get_ammo_total() ~= self[var2] then
		self[var2] = self:get_ammo_total()
		ThisAmmoFire = ThisAmmoFire + 1
		DelayedCalls:Add("D_"..Idstring("Delay::[Ammo fee]"):key(), 1.5, function()
			local __cost = ThisAmmoFire * ThisAmmoCost
			ThisAmmoFire = 0
			managers.hud:present_mid_text({
				time = __cost,
				title = "[Ammo fee]",
				text = __cost.."$",
			})
		end)
		managers.money:_deduct_from_total(ThisAmmoCost)
	end
end)