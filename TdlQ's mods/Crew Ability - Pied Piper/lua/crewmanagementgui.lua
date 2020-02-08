local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

_G.CrewAbilityPiedPiper = _G.CrewAbilityPiedPiper or {}
CrewAbilityPiedPiper._path = ModPath
CrewAbilityPiedPiper.extra_cable_ties = 4 -- don't be lame
CrewAbilityPiedPiper.filter_ability = false

function CrewAbilityPiedPiper:peer_has_capp(peer)
	for _, mod in pairs(peer:synced_mods()) do
		if mod.name == 'Crew Ability: Pied Piper' then
			return true
		end
	end

	return false
end

function CrewAbilityPiedPiper:hud_show_cable_ties()
	if managers.player:crew_ability_upgrade_value('crew_pied_piper', 0) == 0 then
		return
	end

	for _, character in pairs(managers.criminals._characters) do
		if character.taken and character.data.ai then
			local panel_id = character.data.panel_id
			if panel_id then
				managers.hud:set_cable_ties_amount(panel_id, self.extra_cable_ties)
				managers.hud:set_teammate_grenades_amount(panel_id, { amount = 0 })
				managers.hud:set_teammate_deployable_equipment_amount(panel_id, 1, { amount = 0 })

				local panel = managers.hud._teammate_panels[panel_id]
				if panel then
					if alive(panel._player_panel) then
						if panel._player_panel:alpha() > 0 then
							DelayedCalls:Add('DelayedModCAPP_hudshowcableties', 0.1, function() -- delay for MUI
								CrewAbilityPiedPiper:hud_show_cable_ties()
							end)
							return
						end
						panel._player_panel:set_visible(true)
						panel._player_panel:set_alpha(1)
						for _, child in pairs(panel._player_panel:children()) do
							child:set_alpha(child == panel._cable_ties_panel and 1 or 0)
						end
					end
				end
			end
		end
	end
end

Hooks:Add('LocalizationManagerPostInit', 'LocalizationManagerPostInit_CrewAbilityPiedPiper', function(loc)
	for _, filename in pairs(file.GetFiles(CrewAbilityPiedPiper._path .. 'loc/')) do
		local str = filename:match('^(.*).txt$')
		if str and Idstring(str) and Idstring(str):key() == SystemInfo:language():key() then
			loc:load_localization_file(CrewAbilityPiedPiper._path .. 'loc/' .. filename)
			break
		end
	end
	loc:load_localization_file(CrewAbilityPiedPiper._path .. 'loc/english.txt', false)
end)

local capp_original_crewmanagementgui_populatecustom = CrewManagementGui.populate_custom
function CrewManagementGui:populate_custom(category, henchman_index, tweak, list, ...)
	if category == 'ability' then
		table.insert(list, 'crew_pied_piper')
	end
	return capp_original_crewmanagementgui_populatecustom(self, category, henchman_index, tweak, list, ...)
end

DB:create_entry(
	Idstring('texture'),
	Idstring('guis/dlcs/mom/textures/pd2/ai_abilities_capp'),
	ModPath .. 'assets/pied_piper.texture'
)

tweak_data.hud_icons.ability_pied_piper = {
	texture_rect = { 0, 0, 128, 128 },
	texture = 'guis/dlcs/mom/textures/pd2/ai_abilities_capp'
}

tweak_data.upgrades.crew_ability_definitions.crew_pied_piper = {
	icon = 'ability_pied_piper',
	name_id = 'menu_crew_pied_piper'
}

tweak_data.upgrades.values.team.crew_pied_piper = {
	   [1] = {
			   [1] = 1,
			   [2] = 2,
			   [3] = 4
	   }
}
