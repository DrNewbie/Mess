local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local original_SawWeaponBase = SawWeaponBase
require('lib/units/weapons/SawWeaponBase')
Faker:redo_class('SawWeaponBase', 'NewRaycastWeaponBase')
SawWeaponBase = original_SawWeaponBase
