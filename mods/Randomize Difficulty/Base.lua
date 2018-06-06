if not Global.game_settings then
	return
end

_G.RandomizeDifficulty = _G.RandomizeDifficulty or {}

RandomizeDifficulty.Main_Delay = nil

RandomizeDifficulty.Last_Difficulty = Global.game_settings.difficulty

RandomizeDifficulty.Difficulty_Ready2Change = false

local Net = _G.LuaNetworking

function RandomizeDifficulty:ChanageDifficulty()
	if self.Difficulty_Ready2Change then
		Global.game_settings.difficulty = self.Last_Difficulty
		self.Difficulty_Ready2Change = false
	
		if managers.hud._hud_assault_corner._set_hostage_offseted then
			managers.hud._hud_assault_corner:_set_hostage_offseted(true)
		end
		
		tweak_data:set_difficulty(self.Last_Difficulty)

		local difficulty_data = {
			hard = {name_id = "menu_difficulty_hard", icon_id = "icon_difficulty_hard"},
			overkill = {name_id = "menu_difficulty_very_hard", icon_id = "icon_difficulty_overkill"},
			overkill_145 = {name_id = "menu_difficulty_overkill", icon_id = "icon_difficulty_overkill_145"},
			easy_wish = {name_id = "menu_difficulty_easy_wish", icon_id = "icon_difficulty_easy_wish"},
			overkill_290 = {name_id = "menu_difficulty_apocalypse", icon_id = "icon_difficulty_overkill_290"},
			sm_wish = {name_id = "menu_difficulty_sm_wish", icon_id = "icon_difficulty_sm_wish"}
		}
		if HudChallengeNotification and difficulty_data[self.Last_Difficulty] then
			HudChallengeNotification.queue(
				"[ Difficulty ]",
				"Now: "..managers.localization:to_upper_text(difficulty_data[self.Last_Difficulty].name_id),
				difficulty_data[self.Last_Difficulty].icon_id
			)
		end
		if Net:IsHost() then
			Net:SendToPeersExcept(1, "RNDDSync", tweak_data:difficulty_to_index(Global.game_settings.difficulty))
		end
	end
end

if Net:IsHost() or Global.game_settings.single_player then
	Hooks:Add("GameSetupUpdate", "LoopTimer2RandomizeDifficulty", function(t, dt)
		if not Utils:IsInHeist() then
			return
		end

		if not managers.hud or not managers.hud._hud_assault_corner then
			return
		end
		
		if RandomizeDifficulty.Main_Delay then
			RandomizeDifficulty.Main_Delay = RandomizeDifficulty.Main_Delay - dt
			if RandomizeDifficulty.Main_Delay <= 0 then
				RandomizeDifficulty.Main_Delay = nil
			end
			return
		end
		
		RandomizeDifficulty.Main_Delay = 30 + math.random()*60
		
		if not RandomizeDifficulty.Difficulty_Ready2Change and RandomizeDifficulty.Last_Difficulty == Global.game_settings.difficulty then
			RandomizeDifficulty.Difficulty_Ready2Change = true
			RandomizeDifficulty.Last_Difficulty = table.random({
				"hard",
				"hard",
				"hard",
				"overkill",
				"overkill",
				"overkill",
				"overkill",
				"overkill_145",
				"overkill_145",
				"overkill_145",
				"overkill_145",
				"overkill_145",
				"easy_wish",
				"easy_wish",
				"easy_wish",
				"easy_wish",
				"easy_wish",
				"easy_wish",
				"overkill_290",
				"overkill_290",
				"overkill_290",
				"overkill_290",
				"overkill_290",
				"overkill_290",
				"sm_wish",
				"sm_wish",
				"sm_wish"
			})
			return
		end
		
		RandomizeDifficulty:ChanageDifficulty()
	end)
else
	Hooks:Add("NetworkReceivedData", "NetReceived_RNDDSync", function(sender, sync_asked, data)
		if sync_asked == "RNDDSync" and sender and sender == 1 then
			local NewD = tweak_data:index_to_difficulty(tonumber(tostring(data)))
			if NewD then
				RandomizeDifficulty.Last_Difficulty = NewD
				RandomizeDifficulty.Difficulty_Ready2Change = true
				RandomizeDifficulty:ChanageDifficulty()
			end
		end
	end)
end

tweak_data.hud_icons.icon_difficulty_hard = {
	texture = "guis/textures/pd2/blackmarket/icons/masks/skullveryhard",
	texture_rect = {
		0,
		0,
		128,
		128
	}
}
tweak_data.hud_icons.icon_difficulty_overkill = {
	texture = "guis/textures/pd2/blackmarket/icons/masks/skullveryhard",
	texture_rect = {
		0,
		0,
		128,
		128
	}
}
tweak_data.hud_icons.icon_difficulty_overkill_145 = {
	texture = "guis/textures/pd2/blackmarket/icons/masks/skulloverkill",
	texture_rect = {
		0,
		0,
		128,
		128
	}
}
tweak_data.hud_icons.icon_difficulty_easy_wish = {
	texture = "guis/dlcs/gitgud/textures/pd2/blackmarket/icons/masks/gitgud_e_wish",
	texture_rect = {
		0,
		0,
		128,
		128
	}
}
tweak_data.hud_icons.icon_difficulty_overkill_290 = {
	texture = "guis/textures/pd2/blackmarket/icons/masks/skulloverkillplus",
	texture_rect = {
		0,
		0,
		128,
		128
	}
}
tweak_data.hud_icons.icon_difficulty_sm_wish = {
	texture = "guis/dlcs/gitgud/textures/pd2/blackmarket/icons/masks/gitgud_sm_wish",
	texture_rect = {
		0,
		0,
		128,
		128
	}
}

if not PackageManager:loaded("packages/sm_wish") then
	PackageManager:load("packages/sm_wish")
end