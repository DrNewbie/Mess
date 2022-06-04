local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local __Name = function(__id)
	return "Px9_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end
local __idx = __Name("__idx")
local __enable = __Name("__enable")
local __name1 = __Name("__name1")
local __panel1 = __Name("__panel1")
local __bitmap1 = __Name("__bitmap1")
local __texture_size = {1912, 334}
local __scale = 1
local __png_list = {
	"____x9/Px9_001",	"____x9/Px9_002",	"____x9/Px9_003",	"____x9/Px9_004",	"____x9/Px9_005",
	"____x9/Px9_006",	"____x9/Px9_007",	"____x9/Px9_008",	"____x9/Px9_009",	"____x9/Px9_010",
	"____x9/Px9_011",	"____x9/Px9_012",	"____x9/Px9_013",	"____x9/Px9_014",	"____x9/Px9_015",
	"____x9/Px9_016",	"____x9/Px9_017",	"____x9/Px9_018",	"____x9/Px9_019",	"____x9/Px9_020",
	"____x9/Px9_021",	"____x9/Px9_022",	"____x9/Px9_023",	"____x9/Px9_024",	"____x9/Px9_025",
	"____x9/Px9_026",	"____x9/Px9_027",	"____x9/Px9_028",	"____x9/Px9_029",	"____x9/Px9_030",
	"____x9/Px9_031",	"____x9/Px9_032",	"____x9/Px9_033",	"____x9/Px9_034",	"____x9/Px9_035",
	"____x9/Px9_036",	"____x9/Px9_037",	"____x9/Px9_038",	"____x9/Px9_039",	"____x9/Px9_040",
	"____x9/Px9_041",	"____x9/Px9_042",	"____x9/Px9_043",	"____x9/Px9_044",	"____x9/Px9_045",
	"____x9/Px9_046",	"____x9/Px9_047",	"____x9/Px9_048",	"____x9/Px9_049",	"____x9/Px9_050",
	"____x9/Px9_051",	"____x9/Px9_052",	"____x9/Px9_053",	"____x9/Px9_054",	"____x9/Px9_055",
	"____x9/Px9_056",	"____x9/Px9_057",	"____x9/Px9_058",	"____x9/Px9_060"
}

Hooks:PostHook(HUDManager, "_player_hud_layout", __Name("_player_hud_layout"), function(self)
	local p_load = "packages/px9_cc_001"
	if PackageManager:package_exists(p_load) then
		if PackageManager:loaded(p_load) then
			PackageManager:unload(p_load)
		end
		PackageManager:load(p_load)
	end	
	local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2)
	self[__panel1] = self[__panel1] or hud and hud.panel or self._ws:panel({name = __name1})
	if __texture_size[1] > self[__panel1]:w() then
		__scale = self[__panel1]:w() / __texture_size[1]
	end
	self[__panel1]:set_size(__texture_size[1], __texture_size[2])
	self[__bitmap1] = self[__panel1]:bitmap({
		texture = "____x9/Px9_001",
		color = Color.white:with_alpha(1),
		align = "right",
		visible = false,
		layer = 1
	})
	self[__bitmap1]:set_size(self[__bitmap1]:w() * __scale, self[__bitmap1]:h() * __scale)
	self[__idx] = 1
	self[__enable] = false
end)

Hooks:PostHook(HUDManager, "update", __Name("update"), function(self, __t, __dt)
	if self[__panel1] and self[__bitmap1] then
		if __png_list[self[__idx]] and self[__enable] then
			self[__bitmap1]:set_image(__png_list[self[__idx]])
			self[__idx] = self[__idx] + 1
		else
			self[__bitmap1]:set_visible(false)
			self[__enable] = false
			self[__idx] = 1
		end
	end
end)

function HUDManager:____run_px9_cc_function()
	if self[__panel1] and self[__bitmap1] then
		self[__idx] = 1
		self[__bitmap1]:set_image(__png_list[self[__idx]])
		self[__bitmap1]:set_visible(true)
		self[__enable] = true
	end
end