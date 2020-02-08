local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

require('lib/units/weapons/RaycastWeaponBase')
require('lib/units/weapons/NewRaycastWeaponBase')

Faker.classes.RaycastWeaponBase = RaycastWeaponBase
Faker:redo_class('NewRaycastWeaponBase', 'RaycastWeaponBase')
