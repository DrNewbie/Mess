local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

if not Global.game_settings.level_id:find('welcome_to_the_jungle_2') then
	return
end

local _ids = {}
local _modpath = ModPath

BigOilClueInteractionExt = BigOilClueInteractionExt or class(UseInteractionExt)

local clipboard_ids = Idstring('units/payday2/props/gen_prop_lab_clipboards/gen_prop_lab_clipboard')

function BigOilClueInteractionExt:interact(player)
	if not alive(self._unit) then
		return
	end

	BigOilClueInteractionExt.super.super.interact(self, player)

	LuaNetworking:SendToPeers('ClueFound', self._unit:id())
	self:sync_interacted()

	return true
end

function BigOilClueInteractionExt:sync_interacted(peer, player, status, skip_alive_check)
	local pos, rot
	if self._unit:name() == clipboard_ids then
		pos = Vector3(-726, -2422, -255)
		rot = Rotation(90, 0, 90)
	else
		pos = Vector3(-756, -2422, -255)
		rot = Rotation(90, 180, -90)
	end
	self._unit:set_position(pos)
	self._unit:set_rotation(rot)
	self._unit:interaction():set_active(false)
end

Hooks:PostHook(IngameWaitingForPlayersState, 'at_exit', 'IngameWaitingForPlayersStateAtExit_MDF', function()
	local scripts = {
		103921,
		103783
	}
	for _, script_id in ipairs(scripts) do
		local element = managers.mission:get_element_by_id(script_id)
		for _, item in ipairs(element._values.trigger_list) do
			local unit =  managers.worlddefinition:get_unit(item.notify_unit_id)
			if alive(unit) then
				if unit:damage()._state.object['b5cd43441c2f6d7e'].set_visibility[2] then
					_ids[unit:id()] = item.notify_unit_id
					unit:interaction():set_active(true)
				else
					unit:interaction():set_active(false)
				end
			end
		end
	end
end)

Hooks:Add('NetworkReceivedData', 'NetworkReceivedData_MDF', function(sender, messageType, data)
	if messageType == 'ClueFound' then
		if data then
			local id = _ids[tonumber(data)]
			local unit = id and managers.worlddefinition:get_unit(id)
			if alive(unit) and unit:interaction() then
				unit:interaction():sync_interacted()
				local peer = managers.network:session():peer(sender)
				if peer then
					managers.chat:_receive_message(
						ChatManager.GAME,
						managers.localization:to_upper_text('menu_system_message'),
						managers.localization:text('mdf_clue_found', {peer_name = peer:name()}),
						tweak_data.system_chat_color
					)
				end
			end
		end
	end
end)

Hooks:Add('LocalizationManagerPostInit', 'LocalizationManagerPostInit_MDF', function(loc)
	local language_filename

	local modname_to_language = {
		['PAYDAY 2 THAI LANGUAGE Mod'] = 'thai.txt',
	}
	for _, mod in pairs(BLT and BLT.Mods:Mods() or {}) do
		language_filename = mod:IsEnabled() and modname_to_language[mod:GetName()]
		if language_filename then
			break
		end
	end

	if not language_filename then
		for _, filename in pairs(file.GetFiles(_modpath .. 'loc/')) do
			local str = filename:match('^(.*).txt$')
			if str and Idstring(str) and Idstring(str):key() == SystemInfo:language():key() then
				language_filename = filename
				break
			end
		end
	end

	if language_filename then
		loc:load_localization_file(_modpath .. 'loc/' .. language_filename)
	end
	loc:load_localization_file(_modpath .. 'loc/english.txt', false)
end)
