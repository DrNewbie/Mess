local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local fs_original_playertased_registerreviveso = PlayerTased._register_revive_SO
function PlayerTased:_register_revive_SO()
	if not self._recover_delayed_clbk then
		fs_original_playertased_registerreviveso(self)
	end
end
