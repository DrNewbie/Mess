local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local capp_original_intimitateinteractionext_interactblocked = IntimitateInteractionExt._interact_blocked
function IntimitateInteractionExt:_interact_blocked(...)
	tweak_data.player.max_nr_following_hostages = managers.player:crew_ability_upgrade_value('crew_pied_piper', 1)
	return capp_original_intimitateinteractionext_interactblocked(self, ...)
end
