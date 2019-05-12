Hooks:PostHook(PlayerStandard, "update", "RoFBuffUpdateLoop",function(self, t, dt)
	if self._equipped_unit and self._equipped_unit:base() then
		local weap_base = self._equipped_unit:base()
		if weap_base.RofB_time and weap_base.RofB_Min and weap_base.RofB_Max then
			if self._shooting then
				self._rof_buff_t = math.min(self._rof_buff_t + dt, weap_base.RofB_time)
				local rng_rof = weap_base.RofB_Max - weap_base.RofB_Min
				local x_num = (self._rof_buff_t / weap_base.RofB_time)
				local func_rat = 33.132*math.pow(x_num, 6) - 88.048*math.pow(x_num, 5) + 83.984*math.pow(x_num, 4) - 34.344*math.pow(x_num, 3) + 5.7412*math.pow(x_num, 2) + 0.5372*x_num + 0.0025
				func_rat = math.round(func_rat * 100) / 100
				local add_rof = weap_base.RofB_Min + math.min(func_rat, 1) * rng_rof
				add_rof = math.round(add_rof * 100) / 100
				managers.player:Set_Rof_Buff_Addon(add_rof)
				if not weap_base._old_rof_func then
					weap_base._old_rof_func = weap_base.fire_rate_multiplier
					local function new_rof_func(self, ...)
						return self:_old_rof_func(...) * managers.player:Get_Rof_Buff_Addon()
					end
					weap_base.fire_rate_multiplier = new_rof_func			
				end
			elseif self._rof_buff_t and self._rof_buff_t > 0 then
				self._rof_buff_t = 0
				managers.player:Set_Rof_Buff_Addon(weap_base.RofB_Min)
			end
		end
	end
end)