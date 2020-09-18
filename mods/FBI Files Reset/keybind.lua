local __list = {
}
if Steam and Steam:sa_handler() then
	local level_list, job_list, mask_list, weapon_list, melee_list, grenade_list, enemy_list, armor_list, character_list, deployable_list, suit_list, weapon_color_list = tweak_data.statistics:statistics_table()
	table.insert(__list, "gadget_used_ammo_bag")
	table.insert(__list, "gadget_used_trip_mine")
	table.insert(__list, "gadget_used_sentry_gun")
	table.insert(__list, "gadget_used_ecm_jammer")
	table.insert(__list, "gadget_used_first_aid")
	table.insert(__list, "gadget_used_body_bag")
	table.insert(__list, "gadget_used_armor_bag")
	for _, __name in pairs(weapon_list) do
		table.insert(__list, "weapon_used_"..__name)
		table.insert(__list, "weapon_shots_"..__name)
		table.insert(__list, "weapon_hits_"..__name)
		table.insert(__list, "weapon_kills_"..__name)
	end
	for _, __name in pairs(grenade_list) do
		table.insert(__list, "grenade_used_"..__name)
		table.insert(__list, "grenade_kills_"..__name)
	end
	for _, __name in pairs(melee_list) do
		table.insert(__list, "melee_used_"..__name)
		table.insert(__list, "melee_kills_"..__name)
	end
	for _, __name in pairs(mask_list) do
		table.insert(__list, "mask_used_"..__name)
	end	
	--[[
	for _, __name in pairs(armor_list) do
		table.insert(__list, "armor_used_"..__name)
	end
	]]
	for _, __name in pairs(character_list) do
		table.insert(__list, "character_used_"..__name)
	end
	--[[
	for _, __name in pairs(suit_list) do
		table.insert(__list, "suit_used_"..__name)
	end
	for _, __name in pairs(glove_list) do
		table.insert(__list, "gloves_used_"..__name)
	end
	]]
	--[[
	table.insert(__list, "heist_dropin")
	table.insert(__list, "heist_failed")
	table.insert(__list, "heist_success")	
	]]
	for _, __name in pairs(enemy_list) do
		table.insert(__list, "enemy_kills_"..__name)
		table.insert(__list, "enemy_kills_melee_"..__name)
	end
	for __name, _ in pairs(tweak_data.character) do
		table.insert(__list, "enemy_kills_"..__name)
		table.insert(__list, "enemy_kills_melee_"..__name)
	end
	--[[
	for _, __name in pairs(job_list) do
		table.insert(__list, "job_"..__name)
		table.insert(__list, "contract_"..__name.."_win")
		table.insert(__list, "contract_"..__name.."_win_dropin")
		table.insert(__list, "contract_"..__name.."_fail")
	end
	]]
	for _, __api_name in pairs(__list) do
		if Steam:sa_handler():has_stat(__api_name) then
			Steam:sa_handler():set_stat(__api_name, 0)
			log("[FBI Files Reset]: Clean.API.Name: "..tostring(__api_name))
		else
			log("[FBI Files Reset]: Error.API.Name: "..tostring(__api_name))
		end
	end
	Steam:sa_handler():store_data()
	--[[
	if SystemInfo:distribution() == Idstring("STEAM") then
		managers.statistics:publish_level_to_steam()
	end
	]]
	log("[FBI Files Reset]: Set.Done: "..tostring(math.random()))
	QuickMenu:new(
		"[FBI Files Reset]",
		"Set.Done: "..tostring(math.random()),
		{
			{
				text = managers.localization:text("menu_back"),
				is_cancel_button = true
			}
		}, 
		true
	)
end