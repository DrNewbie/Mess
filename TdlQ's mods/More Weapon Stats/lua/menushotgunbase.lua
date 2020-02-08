local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

Faker.menuland = true
local overrider = Overrider:new()

require('lib/managers/EnemyManager')
require('lib/managers/HUDManager')
require('lib/network/base/extensions/NetworkBaseExtension')
require('lib/units/beings/player/PlayerCamera')
require('lib/units/beings/player/PlayerInventory')

overrider:remember(_G, 'NPCRaycastWeaponBase')
require('lib/units/weapons/NPCRaycastWeaponBase')
Faker:redo_class('NPCRaycastWeaponBase', 'RaycastWeaponBase')

overrider:remember(_G, 'NewNPCRaycastWeaponBase')
require('lib/units/weapons/NewNPCRaycastWeaponBase')
Faker:redo_class('NewNPCRaycastWeaponBase', 'NewRaycastWeaponBase')

overrider:remember(_G, 'ShotgunBase')
overrider:remember(_G, 'SaigaShotgun')
overrider:remember(_G, 'InstantElectricBulletBase')
require('lib/units/weapons/shotgun/ShotgunBase')
Faker:redo_class('ShotgunBase', 'NewRaycastWeaponBase')
Faker:redo_class('SaigaShotgun', 'ShotgunBase')

overrider:remember(_G, 'NewFlamethrowerBase')
require('lib/units/weapons/NewFlamethrowerBase')
Faker:redo_class('NewFlamethrowerBase', 'NewRaycastWeaponBase')

overrider:remember(_G, 'FlamethrowerEffectExtension')
require('lib/units/weapons/FlamethrowerEffectExtension')
Faker:redo_class('FlamethrowerEffectExtension', 'NewRaycastWeaponBase')

overrider:remember(_G, 'AkimboWeaponBase')
overrider:remember(_G, 'NPCAkimboWeaponBase')
overrider:remember(_G, 'EnemyAkimboWeaponBase')
require('lib/units/weapons/AkimboWeaponBase')
Faker:redo_class('AkimboWeaponBase', 'NewRaycastWeaponBase')
Faker:redo_class('NPCAkimboWeaponBase', 'NewNPCRaycastWeaponBase')
Faker:redo_class('EnemyAkimboWeaponBase', 'NPCRaycastWeaponBase')

overrider:remember(_G, 'AkimboShotgunBase')
overrider:remember(_G, 'NPCAkimboShotgunBase')
require('lib/units/weapons/AkimboShotgunBase')
Faker:redo_class('AkimboShotgunBase', 'AkimboWeaponBase')
Faker:redo_class('NPCAkimboShotgunBase', 'NPCAkimboWeaponBase')

overrider:remember(_G, 'ProjectileWeaponBase')
require('lib/units/weapons/ProjectileWeaponBase')
Faker:redo_class('ProjectileWeaponBase', 'NewRaycastWeaponBase')

overrider:remember(_G, 'BowWeaponBase')
overrider:remember(_G, 'CrossbowWeaponBase')
require('lib/units/weapons/BowWeaponBase')
Faker:redo_class('BowWeaponBase', 'ProjectileWeaponBase')
Faker:redo_class('CrossbowWeaponBase', 'ProjectileWeaponBase')

overrider:remember(_G, 'GrenadeLauncherBase')
overrider:remember(_G, 'GrenadeLauncherContinousReloadBase')
require('lib/units/weapons/GrenadeLauncherBase')
Faker:redo_class('GrenadeLauncherBase', 'ProjectileWeaponBase')
Faker:redo_class('GrenadeLauncherContinousReloadBase', 'ProjectileWeaponBase')

overrider:revert_all()
