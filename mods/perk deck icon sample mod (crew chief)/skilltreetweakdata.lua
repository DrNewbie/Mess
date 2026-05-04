local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local __Name = function(__id)
	return "PDI_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end
local __LoadOnce = __Name("TweakdataLoadOnce")

if SkillTreeTweakData and not SkillTreeTweakData[__LoadOnce] then
	SkillTreeTweakData[__LoadOnce] = true
	
	Hooks:PostHook(SkillTreeTweakData, "init", __Name(1), function(self)
		--self.specializations[1] <-- Crew Chief
		self.specializations[1][1].texture_bundle_folder = "this_is_sample_for_crew_chief"
		self.specializations[1][1].icon_xy = {0, 0}
		
		self.specializations[1][3].texture_bundle_folder = "this_is_sample_for_crew_chief"
		self.specializations[1][3].icon_xy = {1, 0}
		
		self.specializations[1][5].texture_bundle_folder = "this_is_sample_for_crew_chief"
		self.specializations[1][5].icon_xy = {2, 0}
		
		self.specializations[1][7].texture_bundle_folder = "this_is_sample_for_crew_chief"
		self.specializations[1][7].icon_xy = {3, 0}
		
		self.specializations[1][9].texture_bundle_folder = "this_is_sample_for_crew_chief"
		self.specializations[1][9].icon_xy = {4, 0}
	end)
end