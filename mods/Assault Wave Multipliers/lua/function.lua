local mod_ids = Idstring("Holdout CS:Assault Wave Multipliers"):key()

local function __post_init(them)
	if managers.skirmish and not managers.skirmish:is_skirmish() then
		them._assault_number = them._assault_number or 0
		them._last_assault_number = them._last_assault_number or -1
		for lv = 0, 99 do
			if tweak_data.skirmish.special_unit_spawn_limits[lv - 1] then
				tweak_data.skirmish.special_unit_spawn_limits[lv] = tweak_data.skirmish.special_unit_spawn_limits[lv - 1]
			end
			if tweak_data.skirmish.assault.groups[lv - 1] then
				tweak_data.skirmish.assault.groups[lv] = tweak_data.skirmish.assault.groups[lv - 1]
			end
			if tweak_data.skirmish.wave_modifiers[1][1].data.waves[lv - 1] then
				tweak_data.skirmish.wave_modifiers[1][1].data.waves[lv] = {
					damage = tweak_data.skirmish.wave_modifiers[1][1].data.waves[lv - 1].damage * 1.05,
					health = tweak_data.skirmish.wave_modifiers[1][1].data.waves[lv - 1].health * 1.05
				}
			end
		end
	end
	return them
end

local function __post_upd_assault(them)
	if managers.skirmish and not managers.skirmish:is_skirmish() and type(them._assault_number) == "number" and type(them._last_assault_number) == "number" and them._assault_number >= 0 and them._assault_number ~= them._last_assault_number then
		them._last_assault_number = them._assault_number
		them._start_wave = managers.skirmish:wave_range()
		managers.skirmish._synced_wave_number = math.min(them._last_assault_number, 99)
		managers.skirmish.current_wave_number = function()
			return managers.skirmish._synced_wave_number
		end
		managers.skirmish:_apply_modifiers_for_wave(managers.skirmish._synced_wave_number)
		managers.skirmish:update_matchmake_attributes()
	end
	return them
end

if GroupAIStateStreet then
	Hooks:PostHook(GroupAIStateStreet, "init", "F_"..Idstring("PostHook:GroupAIStateStreet:init:"..mod_ids):key(), function(self)	
		self = __post_init(self)
	end)
	Hooks:PostHook(GroupAIStateStreet, "_upd_assault_task", "F_"..Idstring("PostHook:GroupAIStateStreet:_upd_assault_task:"..mod_ids):key(), function(self)	
		self = __post_upd_assault(self)
	end)
end

if GroupAIStateBesiege then
	Hooks:PostHook(GroupAIStateBesiege, "init", "F_"..Idstring("PostHook:GroupAIStateBesiege:init:"..mod_ids):key(), function(self)	
		self = __post_init(self)
	end)
	Hooks:PostHook(GroupAIStateBesiege, "_upd_assault_task", "F_"..Idstring("PostHook:GroupAIStateBesiege:_upd_assault_task:"..mod_ids):key(), function(self)	
		self = __post_upd_assault(self)
	end)
end