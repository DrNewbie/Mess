local ThisModPath = tostring(ModPath)
local ThisModIds = Idstring(ThisModPath):key()

local __Name = function(__id)
	return "Q_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end

local ThisBannerPath = ThisModPath.."/".."99.dds"
local ThisBannerName = __Name(ThisBannerPath)

--https://store.steampowered.com/app/3847540/
local is_pd2_subscription_installed = __Name("is_pd2_subscription_installed")
local pd2_subscription_cheat_death_times = __Name("pd2_subscription_cheat_death_times")

local AllowTimesDefault = 1
local AllowTimesNow = nil

Hooks:PostHook(PlayerDamage, "init", __Name(1), function(self, ...)
	if (Network and Network:is_server()) or Global.game_settings.single_player then

	else
		return
	end
	self[is_pd2_subscription_installed] = Steam:is_product_installed("3847540")
	if self[is_pd2_subscription_installed] then
		AllowTimesNow = AllowTimesDefault
	end
end)

local Undamageable_Time = 8
local ThisHUDPanel, ThisHUDBitmap
local texture_size = {543, 400}

Hooks:PostHook(PlayerDamage, "_chk_cheat_death", __Name(2), function(self, __ignore_reduce_revive, ...)
	if not self[is_pd2_subscription_installed] or not AllowTimesNow then
		return
	end
	if AllowTimesNow <= 0 then
		return
	end
	if type(self._auto_revive_timer) == "number" and self._auto_revive_timer <= 0 then
		return
	end
	AllowTimesNow = AllowTimesNow - 1
	self._auto_revive_timer = 0.1
	self._revives = Application:digest_value(Application:digest_value(self._revives, false) + 1, true)
	call_on_next_update(function()
		pcall(function ()
			self._next_allowed_dmg_t = Application:digest_value(managers.player:player_timer():time() + Undamageable_Time, true)
		end)
		pcall(function()
			local fullscreen_ws = managers.menu_component and managers.menu_component._fullscreen_ws
			if fullscreen_ws and alive(fullscreen_ws) and fullscreen_ws.panel and fullscreen_ws:panel() then
				ThisHUDPanel = ThisHUDPanel or fullscreen_ws:panel({name = __Name("ThisHUDPanel")})
				ThisHUDPanel:set_size(texture_size[1], texture_size[2])
				if ThisHUDBitmap and alive(ThisHUDBitmap) then
					ThisHUDPanel:remove(ThisHUDBitmap)
					ThisHUDBitmap = nil
				end
				ThisHUDBitmap = ThisHUDPanel:bitmap({
					texture = ThisBannerName,
					color = Color.white:with_alpha(1),
					layer = 1,
					visible = true
				})
				ThisHUDBitmap:set_center_x(0)
				ThisHUDPanel:set_center_x(0)
				ThisHUDPanel:set_center_y(fullscreen_ws:panel():h() + texture_size[1]*0.25)
				local __animate_move = function (panel, done_cb)
					local speed = 2000
					local target_w = panel:w()*0.40
					local TOTAL_T = target_w / speed
					local t = TOTAL_T
					while t > 0 do
						coroutine.yield()
						local dt = TimerManager:main():delta_time()
						t = t - dt
						panel:set_center_x((1 - t / TOTAL_T) * target_w)
					end
					panel:set_center_x(target_w)
					done_cb()
				end
				local __wait_global = function (seconds)
					local t = 0
					while seconds > t do
						coroutine.yield()
						local dt = TimerManager:main():delta_time()
						t = t + dt
					end
				end
				ThisHUDPanel:animate(__animate_move, function ()
					__wait_global(Undamageable_Time)
					ThisHUDPanel:remove(ThisHUDBitmap)
					ThisHUDBitmap = nil
				end)
			end
		end)
	end)
end)

pcall(
	function ()
		if io.file_is_readable(ThisBannerPath) then
			BLTAssetManager:CreateEntry( 
				ThisBannerName, 
				"texture", 
				ThisBannerPath, 
				nil 
			)
		end
		return
	end
)