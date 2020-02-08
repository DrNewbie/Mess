_G.MutatorRealElastic = _G.MutatorRealElastic or class(BaseMutator)
MutatorRealElastic._type = 'MutatorRealElastic'
MutatorRealElastic.name_id = 'fs_mutator_realelastic_name'
MutatorRealElastic.desc_id = 'fs_mutator_realelastic_desc'
MutatorRealElastic.has_options = false
MutatorRealElastic.reductions = {money = 0.5, exp = 0.5}
MutatorRealElastic.categories = {'gameplay'}
MutatorRealElastic.icon_coords = {8, 2}
MutatorRealElastic.incompatiblities = {
	'MutatorBigParty'
}

table.insert(FullSpeedSwarm.custom_mutators, MutatorRealElastic)

function MutatorRealElastic:setup()
	FullSpeedSwarm.settings.real_elastic = true
	FullSpeedSwarm:FinalizeSettings()

	local assault = tweak_data.group_ai.besiege.assault

	local diff = tweak_data:difficulty_to_index(Global.game_settings and Global.game_settings.difficulty or 'normal') - 1
	for i = 1, #assault.force do
		assault.force[i] = assault.force[i] + diff
	end

	for i = 1, #assault.force_pool do
		assault.force_pool[i] = math.ceil(assault.force_pool[i] / 3)
	end

	for i = 1, #assault.force_balance_mul do
		assault.force_balance_mul[i] = 1
	end

	for i = 1, #assault.force_pool_balance_mul do
		assault.force_pool_balance_mul[i] = 1
	end

	for name, preset in pairs(tweak_data.character.presets.detection) do
		if name ~= 'blind' then
			for stance, data in pairs(preset) do
				data.angle_max = math.max(data.angle_max, 160)
			end
		end
	end

	tweak_data.character.presets.gang_member_damage.MIN_DAMAGE_INTERVAL = 0.05
	local fs_original_playerdamage_chkdmgtoosoon = PlayerDamage._chk_dmg_too_soon
	PlayerDamage._chk_dmg_too_soon = function(self, damage)
		if self._char_dmg_tweak then
			return fs_original_playerdamage_chkdmgtoosoon(self, damage)
		end
	end
end
