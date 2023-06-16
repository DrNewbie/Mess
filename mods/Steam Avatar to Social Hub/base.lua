local ThisModPath = ModPath

local __Name = function(__id)
	return "EPIC_"..Idstring(tostring(__id).."::"..ThisModPath):key()
end

Hooks:PostHook(SocialHubUserItem, "setup_panel", __Name("setup_panel"), function(self)
	if type(Steam) == "userdata" and type(Steam.friend_avatar) == "function" then
		local left_y_placer = self.type_config.margin
		Steam:friend_avatar(Steam.SMALL_AVATAR, self.data.id, function(steam_avatar_texture)
			self._content_panel:bitmap({
				h = 32,
				w = 32,
				layer = 105,
				texture = steam_avatar_texture,
				x = left_y_placer,
				y = self._content_panel:h() / 2 - 16
			})
		end)
	end
end)