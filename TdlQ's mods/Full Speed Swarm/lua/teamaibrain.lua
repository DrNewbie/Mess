local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local REACT_IDLE = AIAttentionObject.REACT_IDLE

function TeamAIBrain:on_cop_neutralized(cop_key)
	local attention_info = self._logic_data.detected_attention_objects[cop_key]
	if attention_info then
		attention_info.previous_reaction = REACT_IDLE
	end
	return self._current_logic.on_cop_neutralized(self._logic_data, cop_key)
end
