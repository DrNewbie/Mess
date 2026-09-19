local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local __Name = function(__id)
	return "ODI_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end
local Hook1 = __Name("update_character_visual_state")
local Bool1 = __Name("Bool1")

Hooks:PostHook(CriminalsManager, "update_character_visual_state", Hook1, function(self, __character_name, __visual_state, ...)
	if type(__character_name) == "string" and type(__visual_state) == "table" and managers.job and not __visual_state[Bool1] and Utils and (Utils:IsInGameState() or Utils:IsInHeist() or Utils:IsInCustody()) then
		__visual_state[Bool1] = true
		local __player_style = managers.blackmarket:get_default_player_style()
		local __current_level = managers.job:current_level_id()
		if __current_level and tweak_data.levels[__current_level] and tweak_data.levels[__current_level].player_style then
			__player_style = tweak_data.levels[__current_level].player_style
		end
		__visual_state.player_style = __player_style
		__visual_state.glove_id = managers.blackmarket:get_default_glove_id()
		self:update_character_visual_state(__character_name, __visual_state, ...)
	end
end)