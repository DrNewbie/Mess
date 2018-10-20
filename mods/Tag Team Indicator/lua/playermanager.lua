Hooks:PostHook(PlayerManager, "add_coroutine", "TagTeamActiveHook", function(self, name, func, tagged, player)
	if name and func and name == "tag_team" and tagged ~= player and tagged ~= managers.player:player_unit() then
		self:RemoveTaggedUnit(self._tagged)
		self._tagged = tagged
		self._tagged:contour():add("TagTeamRGB")
	end
end)

Hooks:PostHook(PlayerManager, "update", "TagTeamLoopHook", function(self, t)
	if self._tagged and alive(self._tagged) then
		local red = math.sin(135 * t) / 2 + 0.5
		local green = math.sin(140 * t + 60) / 2 + 0.5
		local blue = math.sin(145 * t + 120) / 2 + 0.5
		ContourExt._types.TagTeamRGB.color = Color(red, green, blue, 0)
		self._tagged:contour():remove("TagTeamRGB")
		self._tagged:contour():add("TagTeamRGB")		
	end
end)

function PlayerManager:RemoveTaggedUnit(tagged)
	if self._tagged and self._tagged == tagged then
		self._tagged:contour():remove("TagTeamRGB")
		self._tagged = nil
	end
end

Hooks:PostHook(PlayerManager, "end_tag_team", "TagTeamEndP3Hook", function(self, tagged)
	self:RemoveTaggedUnit(tagged)
end)