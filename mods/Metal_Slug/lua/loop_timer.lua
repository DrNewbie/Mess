local ThisModMain = _G.MetalSlugGameModeMIds
_G[ThisModMain] = _G[ThisModMain] or {}
local M_Func = _G[ThisModMain]

Hooks:PostHook(PlayerManager, "update", M_Func.NameIds("PlayerManager::touch_event"), function(self, __t, __dt)
	if M_Func.Is_Running then
		if type(_G[ThisModMain].UnitsToCheck) == "table" and self:player_unit() then
			for __key, __data in pairs(_G[ThisModMain].UnitsToCheck) do
				if type(__data.touch_dis) == "number" and type(__data.touch_func) == "function" then
					if __data.unit and type(__data.unit) == "userdata" then
						if __data.touch_dis >= mvector3.distance(self:player_unit():position(), __data.unit:position()) then
							__data.event = 2
							__data.touch_func()
						end
					end
				end
			end
		end
	end
end)

Hooks:PostHook(PlayerManager, "update", _G[ThisModMain].NameIds("PlayerManager::update"), function(self, __t, __dt)
	if M_Func.Is_Running then
		if type(_G[ThisModMain].UnitsToCheck) == "table" and self:player_unit() then
			for __key, __data in pairs(_G[ThisModMain].UnitsToCheck) do
				if type(__data) == "table" then
					if type(__data.event) == "number" then
						if __data.event == 1 then	--Left time running
							if type(__data.t) ~= "number" or __data.t <= 0 then
								__data.event = 2
							end
							__data.t = __data.t - __dt
						elseif __data.event == 2 then	--Remove Unit
							__data.event = nil
							if type(__data.unit) ~= "userdata" or __data.unit then
								if alive(__data.unit) then
									World:delete_unit(__data.unit)
								end
								if alive(__data.unit) then
									__data.unit:set_slot(0)
								end
							end
							if type(__data.sub_units) == "table" then
								for _, sub_key in pairs(__data.sub_units) do
									if sub_key then
										_G[ThisModMain].UnitsToCheck[sub_key].event = 2
									end
								end
							end
							__data.unit = nil
						end
						_G[ThisModMain].UnitsToCheck[__key] = __data
					else
						_G[ThisModMain].UnitsToCheck[__key] = nil
					end			
				end
			end
		end
	end
end)