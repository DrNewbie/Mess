local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local __Name = function(__id)
	return "I4M_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end

if RequiredScript == "lib/managers/experiencemanager" then
	function ExperienceManager:set_current_prestige_xp(value)
		local b_rank = math.max(tweak_data.infamy.ranks - managers.experience:current_rank(), 1)
		self._global.prestige_xp_gained = Application:digest_value(math.min(value, self:get_max_prestige_xp() * b_rank), true)
	end
elseif RequiredScript == "lib/managers/menumanager" then
	local __C1 = 0
	local __C2 = 0
	Hooks:PreHook(MenuCallbackHandler, "_increase_infamous_with_prestige", __Name("Pre:_increase_infamous_with_prestige"), function(self, ...)
		__C1 = managers.experience:current_rank()
		__C2 = managers.experience:get_current_prestige_xp()
	end)
	Hooks:PostHook(MenuCallbackHandler, "_increase_infamous_with_prestige", __Name("Post:_increase_infamous_with_prestige"), function(self, ...)
		if __C1 > 0 and __C1 < managers.experience:current_rank() then
			if __C2 > 0 and __C2 > managers.experience:get_max_prestige_xp() then
				if managers.experience:get_current_prestige_xp() == 0 then
					managers.experience:set_current_prestige_xp(__C2 - managers.experience:get_max_prestige_xp())
				end
			end
		end
		__C1 = 0
		__C2 = 0
	end)
end
