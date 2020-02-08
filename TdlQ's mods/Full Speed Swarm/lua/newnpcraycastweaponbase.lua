local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local fs_original_newnpcraycastweaponbase_init = NewNPCRaycastWeaponBase.init
function NewNPCRaycastWeaponBase:init(...)
	fs_original_newnpcraycastweaponbase_init(self, ...)

	self:fs_reset_ammo_base()
end
