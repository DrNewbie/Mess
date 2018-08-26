local SkirmishMoreWaveAmount = 99

Hooks:PostHook(SkirmishTweakData, "init", "SkirmishMoreWave_16ebbdd0a81ecdbe", function(self, tweak_data)
	for lv = 1, SkirmishMoreWaveAmount do
		--self.special_unit_spawn_limits
			if not self.special_unit_spawn_limits[lv] then
				self.special_unit_spawn_limits[lv] = self.special_unit_spawn_limits[lv - 1]
			end
		--self.assault.groups
			if not self.assault.groups[lv] then
				self.assault.groups[lv] = self.assault.groups[lv - 1]
			end
		--self.ransom_amounts
			if not self.ransom_amounts[lv] then
				self.ransom_amounts[lv] = self.ransom_amounts[lv - 1] + 1
			end
		--self.wave_modifiers[1]
			if not self.wave_modifiers[1][1].data.waves[lv] then
				self.wave_modifiers[1][1].data.waves[lv] = {
					damage = self.wave_modifiers[1][1].data.waves[lv - 1].damage * 1.05
					health = self.wave_modifiers[1][1].data.waves[lv - 1].health * 1.05
				}
			end
		--tweak_data.narrative.levels
			for _, job_name in pairs(self.job_list) do
				local job = tweak_data.narrative.jobs[job_name]
				local level_name = job.chain[1].level_id
				tweak_data.levels[level_name].wave_count = SkirmishMoreWaveAmount
			end
	end
	--self.assault.groups
		local skirmish_assault_meta = {__index = function (t, key)
			if key == "groups" then
				local current_wave = managers.skirmish:current_wave_number()
				local current_wave_index = math.clamp(current_wave, 1, #self.assault.groups)

				return self.assault.groups[current_wave_index]
			else
				return rawget(t, key)
			end
		end}
		setmetatable(tweak_data.group_ai.skirmish.assault, skirmish_assault_meta)
	--self.ransom_amounts
	for i, ransom in ipairs(self.ransom_amounts) do
		self.ransom_amounts[i] = ransom + (self.ransom_amounts[i - 1] or 0)
	end
end)