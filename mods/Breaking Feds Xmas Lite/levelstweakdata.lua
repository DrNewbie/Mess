Hooks:PostHook(LevelsTweakData, "init", "F_"..Idstring("PostHook:LevelsTweakData:init:Breaking Feds Xmas Lite"):key(), function(self)
	self.tag.load_screen = "guis/dlcs/xmn/textures/loading/job_tag_xmn_df"
	self.tag.world_name = "narratives/locke/tag_xmn"
	self.tag.music_overrides = {
		music_tag = "music_xmn"
	}
end)