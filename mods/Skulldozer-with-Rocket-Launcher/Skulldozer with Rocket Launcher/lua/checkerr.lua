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
			managers.menu:show_warning_SkulldozerRPGmod()
		end
	end
end

local _func_orig2 = NetworkMatchMakingSTEAM.set_attributes

function NetworkMatchMakingSTEAM:set_attributes(settings)
	_func_orig2(self, settings)
	self:forced_private()
end