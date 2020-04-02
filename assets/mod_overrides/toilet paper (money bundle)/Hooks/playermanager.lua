--[[
local __ids_money = Idstring("units/world/props/bank/money_wrap/money_wrap_single_bundle"):key()
local __dt_money

Hooks:Add("GameSetupUpdate", "F_"..Idstring("GameSetupUpdate:"..__ids_money):key(), function(t, dt)
	if not __dt_money then
		__dt_money = 2
		local __units = World:find_units_quick("all")
		if __units then
			for _, __unit in pairs(__units) do
				if __unit and __unit:base() and not __unit:base()["F"..__ids_money] and __unit:name():key() == __ids_money then
					__unit:base()["F"..__ids_money] = true
					__unit:set_position(__unit:position() + Vector3(0, 0, 5))
					__unit:set_rotation(Rotation(0, 0, 90))
				end
			end
		end
	else
		__dt_money = __dt_money - dt
		if __dt_money < 0 then
			__dt_money = nil
		end
	end
end)
]]