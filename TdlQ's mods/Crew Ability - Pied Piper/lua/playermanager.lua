local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

if not Network:is_server() then
	return
end

local function consume_cable_tie_of_bot()
	if managers.player:crew_ability_upgrade_value('crew_pied_piper', 0) > 0 then
		for i = managers.criminals.MAX_NR_TEAM_AI, 1, -1 do
			local slot = managers.criminals._loadout_slots[i]
			if slot then
				local character = managers.criminals._characters[slot.char_index]
				if character and character.taken and character.data.ai and alive(character.unit) then
					local loadout = managers.blackmarket:henchman_loadout(i, true)
					local cable_ties_nr = loadout and loadout.capp_cable_ties_nr
					if type(cable_ties_nr) == 'number' and cable_ties_nr > 0 then
						cable_ties_nr = cable_ties_nr - 1
						loadout.capp_cable_ties_nr = cable_ties_nr
						managers.hud:set_cable_ties_amount(character.data.panel_id, cable_ties_nr)
						if cable_ties_nr == 0 then
							local panel = managers.hud._teammate_panels[character.data.panel_id]
							if panel and alive(panel._cable_ties_panel) then
								panel._cable_ties_panel:set_alpha(0)
							end
						end
						return true
					end
				end
			end
		end
	end
end

local capp_original_playermanager_removespecial = PlayerManager.remove_special
function PlayerManager:remove_special(name)
	capp_original_playermanager_removespecial(self, name)

	if name == 'cable_tie' and consume_cable_tie_of_bot() then
		managers.player:add_cable_ties(1)
	end
end

local capp_original_playermanager_setsyncedcableties = PlayerManager.set_synced_cable_ties
function PlayerManager:set_synced_cable_ties(peer_id, amount)
	local peer_used_a_cable_tie = peer_id ~= 1 and self._global.synced_cable_ties[peer_id] and amount < self._global.synced_cable_ties[peer_id].amount and managers.network:session() and managers.network:session():peer(peer_id)

	capp_original_playermanager_setsyncedcableties(self, peer_id, amount)

	if peer_used_a_cable_tie and consume_cable_tie_of_bot() then
		managers.network:session():send_to_peer(peer_used_a_cable_tie, 'give_equipment', 'cable_tie', 1, false)
	end
end
