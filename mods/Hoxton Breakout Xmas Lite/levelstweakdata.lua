Hooks:PostHook(LevelsTweakData, "init", "F_"..Idstring("PostHook:LevelsTweakData:init:Hoxton Breakout Xmas Lite"):key(), function(self)
	self.hox_1.world_name = "narratives/dentist/hox/stage_1_xmn"
	self.hox_1.load_screen = "guis/dlcs/xmn/textures/loading/job_hox_1_xmn_df"
	self.hox_1.music_overrides = {
		track_20 = "track_66"
	}	
	self.hox_2.load_screen = "guis/dlcs/pic/textures/loading/job_breakout_02"
	self.hox_2.world_name = "narratives/dentist/hox/stage_2_xmn"
	self.hox_2.load_screen = "guis/dlcs/xmn/textures/loading/job_hox_2_xmn_df"
	self.hox_2.music_overrides = {
		track_21 = "track_67"
	}
end)