local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local fs_original_sentrygundamage_damagefire = SentryGunDamage.damage_fire
function SentryGunDamage:damage_fire(attack_data)
	local attacker = attack_data.attacker_unit
	if attacker and not attacker:alive() then
		attack_data.attacker_unit = nil
	end

	return fs_original_sentrygundamage_damagefire(self, attack_data)
end

local fs_original_sentrygundamage_damageexplosion = SentryGunDamage.damage_explosion
function SentryGunDamage:damage_explosion(attack_data)
	local attacker = attack_data.attacker_unit
	if attacker and not attacker:alive() then
		attack_data.attacker_unit = nil
	end

	return fs_original_sentrygundamage_damageexplosion(self, attack_data)
end
