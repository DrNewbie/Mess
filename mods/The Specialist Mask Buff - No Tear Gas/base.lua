local ThisModPath = ModPath
local function __Name(__text)
	return "MMM_"..Idstring(tostring(__text)..ThisModPath):key()
end

local init1 = __Name("init1")
local hook1 = __Name("hook1")

local stamina_ratio = 0.25

local function is_mask_ok()
	if managers.blackmarket and managers.player and (not Utils:IsInGameState() or managers.player:current_state() ~= "mask_off") then
		local x_equipped_mask = managers.blackmarket:equipped_mask()
		x_mask_id = x_equipped_mask and x_equipped_mask.mask_id
		if x_mask_id and x_mask_id == "smoker" then
			return true
		end
	end
	return false
end

if KillzoneManager and not KillzoneManager[init1] then
	KillzoneManager[init1] = true
	KillzoneManager[hook1] = KillzoneManager[hook1] or KillzoneManager._deal_gas_damage
	function KillzoneManager:_deal_gas_damage(...)
		if is_mask_ok() then
			return
		end
		self[hook1](self, ...)
	end
end

if PlayerManager and not PlayerManager[init1] then
	PlayerManager[init1] = true
	PlayerManager[hook1] = PlayerManager[hook1] or PlayerManager.stamina_multiplier
	function PlayerManager:stamina_multiplier(...)
		local __ans = self[hook1](self, ...)
		if is_mask_ok() then
			__ans = __ans * stamina_ratio
		end
		return __ans
	end
end
