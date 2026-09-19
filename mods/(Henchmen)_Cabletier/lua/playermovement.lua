Hooks:PostHook(PlayerMovement, "chk_play_mask_on_slow_mo", "Refresh_cable_tie_Amount", function(self)
	if managers.groupai and managers.groupai:state() and managers.player:has_category_upgrade("team", "crew_cabletier") then
		local Add = 0
		for _, u_data in pairs(managers.groupai:state():all_AI_criminals()) do
			if u_data and u_data.unit and alive(u_data.unit) then
				Add = Add + 1				
			end
		end
		managers.player.crew_cabletier_addon = Add * 3
		managers.player.crew_cabletier_backup = managers.player.crew_cabletier_backup or tweak_data.equipments.specials.cable_tie
		tweak_data.equipments.specials.cable_tie.max_quantity = tweak_data.equipments.specials.cable_tie.max_quantity + managers.player.crew_cabletier_addon
		managers.player:add_cable_ties(managers.player.crew_cabletier_addon)
	end
end)