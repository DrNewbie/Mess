local mod_ids = Idstring("Holiday for All"):key()
local hook1 = "F_"..Idstring("hook1:"..mod_ids):key()
local hook2 = "F_"..Idstring("hook2:"..mod_ids):key()
local hook3 = "F_"..Idstring("hook3:"..mod_ids):key()

if LevelsTweakData then
	Hooks:PostHook(LevelsTweakData, "init", hook1, function(self)
		for lv_id, lv_data in pairs(self) do
			if type(lv_data) == "table" and lv_data.name_id then
				self[lv_id].is_christmas_heist = true
				self[lv_id].is_christmas_heist_fake = true
			end
		end
	end)
end

if CopBase then
	Hooks:PostHook(CopBase, "_chk_spawn_gear", hook2, function(self)
		local tweak = managers.job:current_level_data()
		if tweak and tweak.is_christmas_heist and not self._headwear_unit then
			self._headwear_unit = safe_spawn_unit("units/payday2/characters/ene_acc_spook_santa_hat/ene_acc_spook_santa_hat", Vector3(), Rotation())
			local align_obj_name = Idstring("Head")
			local align_obj = self._unit:get_object(align_obj_name)
			if align_obj then
				self._unit:link(align_obj_name, self._headwear_unit, self._headwear_unit:orientation_object():name())
			end
		end
	end)
end

if PlayerManager then
	PlayerManager[hook3] = PlayerManager[hook3] or PlayerManager.get_limited_exp_multiplier
	function PlayerManager:get_limited_exp_multiplier(job_id, level_id, ...)
		local multiplier = self[hook3](self, job_id, level_id, ...)
		local job_data = tweak_data.narrative:job_data(job_id) or {}
		local level_data = level_id and tweak_data.levels[level_id] or {}
		if level_data.is_christmas_heist and level_data.is_christmas_heist_fake then
			multiplier = multiplier - (tweak_data:get_value("experience_manager", "limited_xmas_bonus_multiplier") * 0.99 or 1) - 1
		end
		return multiplier
	end
end

if GameSetup and not PackageManager:loaded("packages/event_xmas") then
	PackageManager:load("packages/event_xmas")
end