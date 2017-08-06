_G.SecondLoadout = _G.SecondLoadout or {}
SecondLoadout.SecondSecondary = SecondLoadout.SecondSecondary or {}
SecondLoadout.SecondPrimary = SecondLoadout.SecondPrimary or {}
SecondLoadout.SecondaryAmmo = SecondLoadout.PrimaryAmmo or {}
SecondLoadout.SecondaryAmmo = SecondLoadout.SecondaryAmmo or {}

function isPlaying()
	if not BaseNetworkHandler then return false end
	return BaseNetworkHandler._gamestate_filter.any_ingame_playing[ game_state_machine:last_queued_state_name() ]
end

function inGame()
	if not game_state_machine then return false end
	return string.find(game_state_machine:current_state_name(), "game")
end

if inGame() then
	if not isPlaying() then
		SecondLoadout.SecondSecondary = managers.blackmarket:equipped_secondary()
		SecondLoadout.SecondPrimary = managers.blackmarket:equipped_primary()
		local sb, sm, ss = WeaponDescription._get_stats(SecondLoadout.SecondSecondary.weapon_id, nil, nil, SecondLoadout.SecondSecondary.blueprint)
		SecondLoadout.SecondaryAmmo = {sb.magazine.value + sm.magazine.value + ss.magazine.value, sb.totalammo.value + sm.totalammo.value + ss.totalammo.value}
		local pb, pm, ps = WeaponDescription._get_stats(SecondLoadout.SecondPrimary.weapon_id, nil, nil, SecondLoadout.SecondPrimary.blueprint)
		SecondLoadout.SecondaryAmmo = {pb.magazine.value + pm.magazine.value + ps.magazine.value, pb.totalammo.value + pm.totalammo.value + ps.totalammo.value}
		local _dialog_data = { 
			title = "[Second Loadout]",
			text = "Current setting is saved.",
			button_list = {{ text = "OK", is_cancel_button = true }},
			id = tostring(math.random(0,0xFFFFFFFF))
		}
		managers.system_menu:show(_dialog_data)
	else
		local player_unit = managers.player:player_unit():inventory()
		if not player_unit then
			return
		end
		local _saved_secondary = SecondLoadout.SecondSecondary or {}
		local _saved_primary = SecondLoadout.SecondPrimary or {}
		local _saved_secondaryammo = SecondLoadout.SecondaryAmmo or {}
		local _saved_primaryammo = SecondLoadout.PrimaryAmmo or {}
		local _c = player_unit:equipped_unit()
		if not _c then
			return
		end
		local use_data = _c:base():get_use_data("player")
		local _s = use_data.selection_index
		local _u = player_unit:unit_by_selection(_s)
		if _u then
			local _o_factory_id = _u:base()._factory_id
			local _o_blueprint = _u:base()._blueprint
			if _o_factory_id and _o_blueprint then
				if _saved_secondary and _saved_secondary.factory_id and _s == 1 then
					SecondLoadout.SecondSecondary = {factory_id = _o_factory_id, blueprint = _o_blueprint}
					local _, mag, total, _ = _c:base():ammo_info()
					SecondLoadout.SecondaryAmmo = {mag, total}
					player_unit:remove_selection(1, true)
					player_unit:add_unit_by_factory_name(_saved_secondary.factory_id, true, false, _saved_secondary.blueprint, nil, {})
					_u:set_slot(0)
					managers.player:player_unit():inventory():equipped_unit():base():set_ammo_total(0)
					managers.player:player_unit():inventory():equipped_unit():base():set_ammo_total(0)
					managers.player:player_unit():inventory():equipped_unit():base():set_ammo_remaining_in_clip(0)
					managers.player:player_unit():inventory():equipped_unit():base():set_ammo_remaining_in_clip(0)
				end
				if _saved_primary and _saved_primary.factory_id and _s == 2 then
					SecondLoadout.SecondPrimary = {factory_id = _o_factory_id, blueprint = _o_blueprint}
					local _, mag, total, _ = _c:base():ammo_info()
					SecondLoadout.PrimaryAmmo = {mag, total}
					player_unit:remove_selection(2, true)
					player_unit:add_unit_by_factory_name(_saved_primary.factory_id, true, false, _saved_primary.blueprint, nil, {})
					_u:set_slot(0)
					managers.player:player_unit():inventory():equipped_unit():base():set_ammo_total(0)
					managers.player:player_unit():inventory():equipped_unit():base():set_ammo_total(0)
					managers.player:player_unit():inventory():equipped_unit():base():set_ammo_remaining_in_clip(0)
					managers.player:player_unit():inventory():equipped_unit():base():set_ammo_remaining_in_clip(0)
				end
			end
		end
	end
end