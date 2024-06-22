local ThisModPath = ModPath

local function __Name(__text)
	return "LCB_"..Idstring(tostring(__text)..ThisModPath):key()
end

local __io = io

pcall(function()
	local __List = {
		["sm_wish"] = "guis/06.dds",
		["overkill_290"] = "guis/05.dds",
		["easy_wish"] = "guis/04.dds",
		["overkill_145"] = "guis/03.dds",
		["overkill"] = "guis/02.dds",
		["hard"] = "guis/01.dds"
	}
	for __i, __d in pairs(__List) do
		if __io.file_is_readable(ThisModPath..__d) then
			local skull_path = "guis/lcb_difficulty_skulls_"..__i
			BLTAssetManager:CreateEntry( 
				Idstring(skull_path), 
				Idstring("texture"), 
				ThisModPath..__d, 
				nil 
			)
			tweak_data.gui.blackscreen_risk_textures[__i] = skull_path
		end
	end
	if __io.file_is_readable(ThisModPath.."guis/one_down.dds") then
		BLTAssetManager:CreateEntry( 
			Idstring("guis/lcb_difficulty_skulls_one_down"), 
			Idstring("texture"), 
			ThisModPath.."guis/one_down.dds", 
			nil 
		)
	end
	return
end)

Hooks:PostHook(HUDBlackScreen, "_set_job_data", __Name(1), function(self)
	if not Global.game_settings.one_down then
		return
	end
	if not managers.job:has_active_job() then
		return
	end
	if not __io.file_is_readable(ThisModPath.."guis/one_down.dds") then
		return
	end
	local one_down_panel = self._blackscreen_panel:panel({
		y = 0,
		name = "one_down_panel",
		halign = "grow",
		visible = true,
		layer = 10,
		valign = "grow"
	})
	local one_down_panel_bitmap = one_down_panel:bitmap({
		texture = "guis/lcb_difficulty_skulls_one_down",
		color = tweak_data.screen_colors.risk
	})
	one_down_panel_bitmap:set_center_x(one_down_panel:w() / 2)
	one_down_panel_bitmap:set_center_y(one_down_panel:h() / 1.45)
end)