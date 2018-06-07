if not Global.game_settings then
	return
end

_G.DifficultyGoUP = _G.DifficultyGoUP or {}
DifficultyGoUP.ModPath = ModPath
if ModCore then
	ModCore:new(DifficultyGoUP.ModPath .. "Config.xml", true, true)
end
DifficultyGoUP.Last_Difficulty = Global.game_settings.difficulty
DifficultyGoUP.Difficulty_Ready2Change = false
DifficultyGoUP.Main_Delay = nil
DifficultyGoUP.Start_Heist_Time = nil
DifficultyGoUP.SM_WISH_PLUS = 0
DifficultyGoUP.SM_WISH_PLUS_LAST = DifficultyGoUP.SM_WISH_PLUS_LAST or 0
DifficultyGoUP.Difficulty2KeyPoint = {
	500,
	1500,
	3000,
	7000,
	14000,
	25000,
	37000,
	50000,
	50000
}

local Net = _G.LuaNetworking

function DifficultyGoUP:ChanageDifficulty()
	if self.Difficulty_Ready2Change then
		Global.game_settings.difficulty = self.Last_Difficulty
		self.Difficulty_Ready2Change = false
	
		if managers.hud._hud_assault_corner._set_hostage_offseted then
			managers.hud._hud_assault_corner:_set_hostage_offseted(true)
		end
		
		if tweak_data.character then
			tweak_data.character:init(tweak_data)
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
		local SM_WISH_PLUS = self.SM_WISH_PLUS and self.SM_WISH_PLUS > 1 and true or false
		if HudChallengeNotification and difficulty_data[self.Last_Difficulty] then
			if SM_WISH_PLUS then
				HudChallengeNotification.queue(
					"[ Difficulty ]",
					managers.localization:to_upper_text(difficulty_data[self.Last_Difficulty].name_id).." - "..managers.experience:rank_string(self.SM_WISH_PLUS).."",
					difficulty_data[self.Last_Difficulty].icon_id
				)
			else
				HudChallengeNotification.queue(
					"[ Difficulty ]",
					"Now: "..managers.localization:to_upper_text(difficulty_data[self.Last_Difficulty].name_id),
					difficulty_data[self.Last_Difficulty].icon_id
				)
			end
		end
		if SM_WISH_PLUS then
			--HP +20% ea
			tweak_data.character:_multiply_all_hp((1+ 0.2*self.SM_WISH_PLUS), 1)
			--Dmg +10% ea
			for i, d in pairs(tweak_data.character) do
				if type(d) == "table" and type(d.weapon) == "table" then
					for ii, dd in pairs(d.weapon) do
						if type(dd) == "table" and type(dd.FALLOFF) == "table" then
							for iii, ddd in pairs(dd.FALLOFF) do
								if type(ddd) == "table" and type(ddd.dmg_mul) == "number" then
									ddd.dmg_mul = ddd.dmg_mul * (1 + 0.1*self.SM_WISH_PLUS)
								end
							end
						end
					end
				end
			end
		end
		if Net:IsHost() then
			Net:SendToPeersExcept(1, "RNDDSync", tweak_data:difficulty_to_index(Global.game_settings.difficulty)..",,,"..self.SM_WISH_PLUS)
		end
	end
end

if Net:IsHost() or Global.game_settings.single_player then
	Hooks:Add("GameSetupUpdate", "LoopTimer2DifficultyGoUP", function(t, dt)
		if not Utils:IsInHeist() or not TimerManager or not TimerManager:game() or not managers.hud or not managers.hud._hud_assault_corner then
			return
		end
		
		t = TimerManager:game():time()
		
		if not DifficultyGoUP.Start_Heist_Time then
			DifficultyGoUP.Start_Heist_Time = t - 0.01
		end
		
		local during = t - DifficultyGoUP.Start_Heist_Time
		local total_civilian_kills = managers.statistics:session_total_civilian_kills()
		local total_kills = managers.statistics:session_total_kills()
		local total_specials_kills = managers.statistics:session_total_specials_kills()
		local total_downed = managers.statistics:total_downed()
		
		local key_lv = tweak_data:difficulty_to_index(Global.game_settings.difficulty)
		local key_point = DifficultyGoUP.Difficulty2KeyPoint[key_lv + 1] or 1
		local now_point = DifficultyGoUP.Difficulty2KeyPoint[key_lv]
		now_point = now_point + total_civilian_kills * 1000
		now_point = now_point + total_kills * 30
		now_point = now_point + total_specials_kills * 100
		now_point = now_point - total_downed * 250
		now_point = now_point + math.round(during * 5)
		
		if key_point > now_point then
			return
		end
		
		if Global.game_settings.difficulty == "sm_wish" then
			DifficultyGoUP.SM_WISH_PLUS = now_point - DifficultyGoUP.Difficulty2KeyPoint[tweak_data:difficulty_to_index("sm_wish")]
			DifficultyGoUP.SM_WISH_PLUS = math.round(DifficultyGoUP.SM_WISH_PLUS / 1500) + 1
			if DifficultyGoUP.SM_WISH_PLUS_LAST ~= DifficultyGoUP.SM_WISH_PLUS then
				DifficultyGoUP.SM_WISH_PLUS_LAST = DifficultyGoUP.SM_WISH_PLUS
				DifficultyGoUP.Difficulty_Ready2Change = true
				DifficultyGoUP:ChanageDifficulty()
			end
		else
			if not DifficultyGoUP.Difficulty_Ready2Change then
				local LVUP = {
					easy = "normal",
					normal = "hard",
					hard = "overkill",
					overkill = "overkill_145",
					overkill_145 = "easy_wish",
					easy_wish = "overkill_290",
					overkill_290 = "sm_wish"
				}
				DifficultyGoUP.SM_WISH_PLUS = 0
				DifficultyGoUP.Last_Difficulty = LVUP[Global.game_settings.difficulty] or "normal"
				DifficultyGoUP.Difficulty_Ready2Change = true
				DifficultyGoUP:ChanageDifficulty()
			end
		end
	end)
else
	Hooks:Add("NetworkReceivedData", "NetReceived_RNDDSync", function(sender, sync_asked, data)
		if sync_asked == "RNDDSync" and sender and sender == 1 then
			local data_array = string.split(tostring(data), ",,,")
			if data_array and data_array[1] and data_array[2] then
				data_array[1] = tonumber(data_array[1]) or 0
				data_array[2] = tonumber(data_array[2]) or 0
				local NewD = tweak_data:index_to_difficulty(data_array[1])
				if NewD then
					DifficultyGoUP.Last_Difficulty = NewD
					DifficultyGoUP.SM_WISH_PLUS = data_array[2]
					DifficultyGoUP.Difficulty_Ready2Change = true
					DifficultyGoUP:ChanageDifficulty()
				end			
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