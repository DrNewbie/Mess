local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local capp_original_teamaibase_save = TeamAIBase.save
function TeamAIBase:save(data)
	local original_ability = self._loadout.ability
	if original_ability == 'crew_pied_piper' and CrewAbilityPiedPiper.filter_ability then
		self._loadout.ability = nil
	end

	capp_original_teamaibase_save(self, data)

	self._loadout.ability = original_ability
end
