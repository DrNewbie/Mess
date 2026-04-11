local ThisModPath = tostring(ModPath)
local ThisModIds = Idstring(ThisModPath):key()

local __Name = function(__id)
	return "Q_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end

local ThisBannerPath = ThisModPath.."/".."99.dds"
local ThisBannerName = __Name(ThisBannerPath)

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

--https://store.steampowered.com/app/3847540/
local is_pd2_subscription_installed = __Name("is_pd2_subscription_installed")
local pd2_subscription_cheat_death_times = __Name("pd2_subscription_cheat_death_times")

local AllowTimesDefault = 1
local AllowTimesNow = nil

local ProtectDuration = 8
local ProtectStart = 0

Hooks:PostHook(PlayerMovement, "post_init", __Name(1), function(self, ...)
	if (Network and Network:is_server()) or Global.game_settings.single_player then

	else
		return
	end
	self[is_pd2_subscription_installed] = Steam:is_product_installed("3847540")
	if self[is_pd2_subscription_installed] then
		AllowTimesNow = AllowTimesDefault
	end
end)

Hooks:PostHook(PlayerMovement, "is_taser_attack_allowed", __Name(2), function(self, ...)	
	local __ans = Hooks:GetReturn()
	
	if not __ans or ProtectStart >= managers.player:player_timer():time() then
		return false
	end
	
	if self[is_pd2_subscription_installed] and AllowTimesNow and AllowTimesNow > 0 then
		AllowTimesNow = AllowTimesNow - 1
		ProtectStart = managers.player:player_timer():time() + ProtectDuration
		__ply_img()
		return false
	end
	
	return __ans
end)

Hooks:PostHook(PlayerMovement, "is_SPOOC_attack_allowed", __Name(3), function(self, ...)
	local __ans = Hooks:GetReturn()
	
	if not __ans or ProtectStart >= managers.player:player_timer():time() then
		return false
	end
	
	if self[is_pd2_subscription_installed] and AllowTimesNow and AllowTimesNow > 0 then
		AllowTimesNow = AllowTimesNow - 1
		ProtectStart = managers.player:player_timer():time() + ProtectDuration
		__ply_img()
		return false
	end
	
	return __ans
end)