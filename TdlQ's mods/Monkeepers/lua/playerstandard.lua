local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

if not Monkeepers or Monkeepers.disabled or Network:is_client() then
	return
end

local unit_type_teammate = 2

local mkp_original_playerstandard_getintimidationaction = PlayerStandard._get_intimidation_action
function PlayerStandard:_get_intimidation_action(prime_target, char_table, amount, primary_only, detect_only, secondary)
	if secondary and prime_target and prime_target.unit_type == unit_type_teammate then
		if managers.groupai:state():whisper_mode() then
			local record = managers.groupai:state():all_criminals()[prime_target.unit:key()]
			if record and record.ai then
				if prime_target.unit:movement():cool() then
					prime_target.unit:movement():_switch_to_not_cool(true)
					return 'come', false, prime_target
				end
			end
		end
	end

	return mkp_original_playerstandard_getintimidationaction(self, prime_target, char_table, amount, primary_only, detect_only, secondary)
end

local mkp_original_playerstandard_getinteractiontarget = PlayerStandard._get_interaction_target
function PlayerStandard:_get_interaction_target(char_table, my_head_pos, cam_fwd)
	if managers.groupai:state():whisper_mode() then
		if Keepers and Keepers.enabled and not self.kpr_secondary and Keepers.settings.filter_shout_at_teamai and not Keepers:IsFilterKeyPressed() then
			-- qued
		else
			for _, u_data in pairs(managers.groupai:state():all_AI_criminals()) do
				if alive(u_data.unit) then
					if self.mpk_add_ai_teammates_cool or not u_data.unit:movement():cool() then
						self:_add_unit_to_char_table(char_table, u_data.unit, unit_type_teammate, 100000, true, true, 0.01, my_head_pos, cam_fwd)
					end
				end
			end
		end
	end

	return mkp_original_playerstandard_getinteractiontarget(self, char_table, my_head_pos, cam_fwd)
end

local mkp_original_playerstandard_getunitintimidationaction = PlayerStandard._get_unit_intimidation_action
function PlayerStandard:_get_unit_intimidation_action(...)
	self.mpk_add_ai_teammates_cool = select(9, ...) and select(3, ...) and managers.groupai:state():whisper_mode()

	return mkp_original_playerstandard_getunitintimidationaction(self, ...)
end
