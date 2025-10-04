local ThisModPath = tostring(ModPath)
local ThisModIds = Idstring(ThisModPath):key()

if (Network and Network:is_server()) or Global.game_settings.single_player then

else
	return
end

local __Name = function(__id)
	return "Q_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end

--https://store.steampowered.com/app/3847540/
local is_pd2_subscription_installed = __Name("is_pd2_subscription_installed")
local pd2_subscription_cheat_death_times = __Name("pd2_subscription_cheat_death_times")

Hooks:PostHook(PlayerDamage, "init", __Name(1), function(self, ...)
	self[is_pd2_subscription_installed] = Steam:is_product_installed("3847540")
	if self[is_pd2_subscription_installed] then
		self[pd2_subscription_cheat_death_times] = 1
	end
end)

Hooks:PostHook(PlayerDamage, "_chk_cheat_death", __Name(2), function(self, __ignore_reduce_revive, ...)
	if not self[is_pd2_subscription_installed] or type(self[pd2_subscription_cheat_death_times]) ~= "number" then
		return
	end
	if self[pd2_subscription_cheat_death_times] <= 0 then
		return
	end
	if type(self._auto_revive_timer) == "number" and self._auto_revive_timer <= 0 then
		return
	end
	self[pd2_subscription_cheat_death_times] = self[pd2_subscription_cheat_death_times] - 1
	self._auto_revive_timer = 0.1
	self._revives = Application:digest_value(Application:digest_value(self._revives, false) + 1, true)
	call_on_next_update(function()
		pcall(function ()
			self._next_allowed_dmg_t = Application:digest_value(managers.player:player_timer():time() + 8, true)
		end)
	end)
end)