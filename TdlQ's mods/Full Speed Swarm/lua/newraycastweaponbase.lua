local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local fs_original_newraycastweaponbase_init = NewRaycastWeaponBase.init
function NewRaycastWeaponBase:init(...)
	fs_original_newraycastweaponbase_init(self, ...)

	self:fs_reset_ammo_base()
end

local fs_original_newraycastweaponbase_resetcachedgadget = NewRaycastWeaponBase.reset_cached_gadget
function NewRaycastWeaponBase:reset_cached_gadget()
	fs_original_newraycastweaponbase_resetcachedgadget(self)

	self:fs_reset_ammo_base()
end
