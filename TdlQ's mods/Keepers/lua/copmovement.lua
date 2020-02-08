local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

function CopMovement:tweak_data_clbk_reload(override)
	self._tweak_data = override or tweak_data.character[self._ext_base._tweak_table]
	self._action_common_data = self._action_common_data or {}
	self._action_common_data.char_tweak = self._tweak_data
end
