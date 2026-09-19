Hooks:Add("MenuManagerBuildCustomMenus", "MenuManagerBuildCustomMenus_CSMutators", function( menu_manager, nodes )
	if nodes.crime_spree_lobby then
		if nodes.menu_mutators then
			nodes.menu_mutators:parameters().sync_state = "blackmarket"
		end
		MenuHelper:AddMenuItem( nodes.crime_spree_lobby, "mutators", "menu_mutators", "menu_mutators" )
	end
end)