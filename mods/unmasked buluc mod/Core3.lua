local function __unmasked_buluc_mod(them)
	if managers.job and managers.job:current_job_id() == "fex" then
		local __g_mask = them._unit:get_object(Idstring("g_mask"))
		if type(__g_mask) == "userdata" and type(__g_mask.set_visibility) == "function" then
			__g_mask:set_visibility(false)
		end
		local __g_backside = them._unit:get_object(Idstring("g_backside"))
		if type(__g_backside) == "userdata" and type(__g_backside.set_visibility) == "function" then
			__g_backside:set_visibility(false)
		end
			local __g_hat = them._unit:get_object(Idstring("g_hat"))
		if type(__g_hat) == "userdata" and type(__g_hat.set_visibility) == "function" then
			__g_hat:set_visibility(false)
		end
	end
end

if CivilianBrain then
	Hooks:PostHook(CivilianBrain, "init", "F_"..Idstring("Unmasked Buluc Mod::1"):key(), function(self)
		__unmasked_buluc_mod(self)
	end)
end

if CopBrain then
	Hooks:PostHook(CopBrain, "init", "F_"..Idstring("Unmasked Buluc Mod::2"):key(), function(self)
		__unmasked_buluc_mod(self)
	end)
end

if AnimatedVehicleBase then
	Hooks:PostHook(AnimatedVehicleBase, "init", "F_"..Idstring("Unmasked Buluc Mod::3"):key(), function(self)
		__unmasked_buluc_mod(self)
	end)
end