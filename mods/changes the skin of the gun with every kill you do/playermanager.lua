Hooks:PostHook(PlayerManager, "on_killshot", "GetRandomSkinsPostKillshot", function(self)
	local player_unit = self:player_unit()
	if not player_unit or not player_unit.inventory or not player_unit:inventory() then
		return
	end
	for i_sel, selection_data in pairs(player_unit:inventory()._available_selections) do
		if selection_data.unit and alive(selection_data.unit) and selection_data.unit:base() then
			local unit = selection_data.unit:base()
			if unit then				
				local cosmetics = tweak_data.blackmarket.weapon_skins[table.random_key(tweak_data.blackmarket.weapon_skins)]
				if cosmetics then
					unit._cosmetics_data = cosmetics
					unit._cosmetics_quality = table.random_key(tweak_data.economy.qualities)
					unit:_apply_cosmetics(function()
					end)
				end
			end
		end
	end
end)