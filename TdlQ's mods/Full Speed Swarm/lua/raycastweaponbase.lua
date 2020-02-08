local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

function RaycastWeaponBase:fs_ammo_base()
	return self.fs_ext_ammo_base
end

RaycastWeaponBase.fs_original_ammo_base = RaycastWeaponBase.ammo_base
function RaycastWeaponBase:fs_reset_ammo_base()
	self.fs_ext_ammo_base = self:fs_original_ammo_base()
	self.ammo_base = self.fs_ammo_base
end

local fs_original_raycastweaponbase_onenabled = RaycastWeaponBase.on_enabled
function RaycastWeaponBase:on_enabled()
	self:fs_reset_ammo_base()
	fs_original_raycastweaponbase_onenabled(self)
end

-- remove some useless obfuscation, same crap in weaponammo.lua *yawn*
function RaycastWeaponBase:set_ammo_max_per_clip(ammo_max_per_clip)
	self._ammo_max_per_clip = ammo_max_per_clip
end

function RaycastWeaponBase:get_ammo_max_per_clip()
	return self._ammo_max_per_clip
end

function RaycastWeaponBase:set_ammo_max(ammo_max)
	self._ammo_max = ammo_max
end

function RaycastWeaponBase:get_ammo_max()
	return self._ammo_max
end

function RaycastWeaponBase:set_ammo_total(ammo_total)
	self._ammo_total = ammo_total
end

function RaycastWeaponBase:get_ammo_total()
	return self._ammo_total
end

function RaycastWeaponBase:set_ammo_remaining_in_clip(ammo_remaining_in_clip)
	self._ammo_remaining_in_clip = ammo_remaining_in_clip
end

function RaycastWeaponBase:get_ammo_remaining_in_clip()
	return self._ammo_remaining_in_clip
end
