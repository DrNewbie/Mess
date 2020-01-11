Hooks:PostHook(LevelsTweakData, "init", "F_"..Idstring("PostHook:LevelsTweakData:init:Hoxton Breakout Xmas Lite"):key(), function(self)
	self.hox_1.world_name = "narratives/dentist/hox/stage_1_xmn"
	self.hox_1.load_screen = "guis/dlcs/xmn/textures/loading/job_hox_1_xmn_df"
	self.hox_1.music_overrides = {
		track_20 = "track_66"
	}
end)