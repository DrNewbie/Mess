if UpgradesTweakData then
	Hooks:PostHook(UpgradesTweakData, "init", "RemoveWepLevelLock1", function(u_self)
		for level, level_data in pairs(u_self.level_tree) do
			if level_data.name_id == "weapons" then
				for _, upgrade in pairs(level_data.upgrades) do
					table.insert(u_self.level_tree[0].upgrades, upgrade)
				end
				u_self.level_tree[level] = {upgrades={}, name_id="weapons"}
			end
		end
	end)
end


if BlackMarketGui then
	for level, level_data in pairs(tweak_data.upgrades.level_tree) do
		if level_data.name_id == "weapons" then
			for _, upgrade in pairs(level_data.upgrades) do
				table.insert(tweak_data.upgrades.level_tree[0].upgrades, upgrade)
			end
			tweak_data.upgrades.level_tree[level] = {upgrades={}, name_id="weapons"}
		end
	end
end