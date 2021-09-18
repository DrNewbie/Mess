local mod_ids = Idstring(ModPath):key()
local __EBB_hook2 = "F_"..Idstring("__EBB_hook2:"..mod_ids):key()
local __using_dt = "F_"..Idstring("__using_dt:"..mod_ids):key()
local __using_ft = "F_"..Idstring("__using_ft:"..mod_ids):key()
local __eating_unit = "F_"..Idstring("__eating_unit:"..mod_ids):key()

local old_update_check_actions = PlayerStandard._update_check_actions

function PlayerStandard:_update_check_actions(...)
	if managers.player[__using_dt] then
		self:_update_ground_ray()
		self:_update_fwd_ray()
		self:_update_movement(...)
		return
	end
	return old_update_check_actions(self, ...)
end

local old_get_max_walk_speed = PlayerStandard._get_max_walk_speed

function PlayerStandard:_get_max_walk_speed(...)
	local __ans = old_get_max_walk_speed(self, ...)
	return managers.player[__using_dt] and __ans*0.05 or __ans
end

Hooks:PostHook(PlayerStandard , "_update_check_actions", __EBB_hook2, function(self, t, dt)
	if type(managers.player[__using_dt]) == "number" and managers.player[__eating_unit] then
		local current_state_name = self._unit:movement():current_state_name()
		if not alive(managers.player[__eating_unit]) or
			not managers.player:__is_look_at_bags_yes(self._unit) or
			current_state_name == "empty" or 
			current_state_name == "mask_off" or 
			current_state_name == "bleed_out" or 
			current_state_name == "fatal" or 
			current_state_name == "arrested" or 
			current_state_name == "incapacitated" or 
			self:_changing_weapon() or 
			self:_is_reloading() or 
			self:_interacting() or 
			self:_is_meleeing() or 
			self._use_item_expire_t or 
			self:_is_throwing_projectile() or 
			self:_on_zipline() or 
			self._is_jumping then
				managers.player[__using_dt] = nil
				managers.hud:set_EBB_visible(false)
				managers.player:__stop_eat_body_bag_ogg()
		else
			managers.player[__using_dt] = managers.player[__using_dt] - dt
			local totl = managers.player[__using_ft]
			local curr = totl - managers.player[__using_dt]
			managers.hud:set_EBB_visible(true)
			managers.hud:set_EBB(curr, totl, "Eating...")
			if managers.player[__using_dt] <= 0 then
				managers.player[__using_dt] = nil
				managers.hud:set_EBB_visible(false)
				World:delete_unit(managers.player[__eating_unit])
				managers.player[__eating_unit] = nil
			end
		end
	end
end)