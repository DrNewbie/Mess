function NetworkMatchMakingSTEAM:forced_private()
	if self._lobby_attributes then
		if self._lobby_attributes.permission == 1 then
			local permissions = {
				"public",
				"friend",
				"private"
			}
			self._lobby_attributes.permission = 2
			self.lobby_handler:set_lobby_data(self._lobby_attributes)
			self.lobby_handler:set_lobby_type(permissions[2])
			managers.menu:show_warning_mod(1)
			managers.menu:show_warning_mod(2)
			managers.menu:show_warning_mod(3)
			managers.menu:show_warning_mod(4)
			managers.menu:show_warning_mod(5)
		end
	end
end

function NetworkMatchMakingSTEAM:get_lobby_attributes()
	if self._lobby_attributes then
		return tonumber(self._lobby_attributes.permission)
	end
	return 1
end

local _func_orig2 = NetworkMatchMakingSTEAM.set_attributes

function NetworkMatchMakingSTEAM:set_attributes(settings)
	_func_orig2(self, settings)
	self:forced_private()
end