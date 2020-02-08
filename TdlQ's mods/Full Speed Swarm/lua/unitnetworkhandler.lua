local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local fs_unitnetworkhandler_syncteargasgrenadeproperties = UnitNetworkHandler.sync_tear_gas_grenade_properties
function UnitNetworkHandler:sync_tear_gas_grenade_properties(grenade, ...)
	if alive(grenade) then
		fs_unitnetworkhandler_syncteargasgrenadeproperties(self, grenade, ...)
	end
end

local fs_unitnetworkhandler_syncteargasgrenadedetonate = UnitNetworkHandler.sync_tear_gas_grenade_detonate
function UnitNetworkHandler:sync_tear_gas_grenade_detonate(grenade)
	if alive(grenade) then
		fs_unitnetworkhandler_syncteargasgrenadedetonate(self, grenade)
	end
end

local fs_unitnetworkhandler_sentrygunsyncarmorpiercing = UnitNetworkHandler.sentrygun_sync_armor_piercing
function UnitNetworkHandler:sentrygun_sync_armor_piercing(unit, ...)
	if alive(unit) then
		fs_unitnetworkhandler_sentrygunsyncarmorpiercing(self, unit, ...)
	end
end

local fs_unitnetworkhandler_syncfiremodeinteraction = UnitNetworkHandler.sync_fire_mode_interaction
function UnitNetworkHandler:sync_fire_mode_interaction(unit, ...)
	if alive(unit) then
		fs_unitnetworkhandler_syncfiremodeinteraction(self, unit, ...)
	end
end

local fs_unitnetworkhandler_syncdrillupgrades = UnitNetworkHandler.sync_drill_upgrades
function UnitNetworkHandler:sync_drill_upgrades(unit, ...)
	if alive(unit) then
		fs_unitnetworkhandler_syncdrillupgrades(self, unit, ...)
	end
end

function UnitNetworkHandler:set_equipped_weapon(unit, item_index, blueprint_string, cosmetics_string, sender)
	if not self._verify_character(unit) then
		return
	end

	local peer = self._verify_sender(sender)
	if not peer then
		return
	end

	local unit_inventory = unit:inventory()
	if not unit_inventory or not unit_inventory.synch_equipped_weapon then
		return
	end

	unit_inventory:synch_equipped_weapon(item_index, blueprint_string, cosmetics_string, peer)
end

if Network:is_server() then

	local fs_unitnetworkhandler_unitnetworkhandler_damagebullet = UnitNetworkHandler.damage_bullet
	function UnitNetworkHandler:damage_bullet(subject_unit, attacker_unit, ...)
		if alive(attacker_unit) and attacker_unit:slot() == 3 then
			-- qued
		elseif alive(subject_unit) and subject_unit:slot() == 16 then
			if managers.groupai:state():is_enemy_converted_to_criminal(subject_unit) then
				-- too bad but it can't be helped (without major desync)
			else
				return -- because that's already been accounted by host
			end
		end

		fs_unitnetworkhandler_unitnetworkhandler_damagebullet(self, subject_unit, attacker_unit, ...)
	end

end
