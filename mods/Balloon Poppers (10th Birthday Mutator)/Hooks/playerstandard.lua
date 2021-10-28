local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local Hook0 = "F_"..Idstring("PlayerStandard:_check_action_primary_attack:"..ThisModIds):key()
local Old0 = "F_"..Idstring("birthday_multiplier:trigger_pressed:"..ThisModIds):key()
local Old1 = "F_"..Idstring("birthday_multiplier:trigger_released:"..ThisModIds):key()
local Old2 = "F_"..Idstring("birthday_multiplier:trigger_held:"..ThisModIds):key()

Hooks:PreHook(PlayerStandard, "_check_action_primary_attack", Hook0, function(self)
	local weap_base = self._equipped_unit:base()
	if weap_base then
		if not weap_base[Old0] and type(weap_base["trigger_pressed"]) == "function" then
			weap_base[Old0] = weap_base.trigger_pressed
			weap_base.trigger_pressed = function (self, pos, dir, dmg_mul, ...)
				dmg_mul = dmg_mul * managers.player:get_temporary_property("birthday_multiplier", 1)
				return self[Old0](self, pos, dir, dmg_mul, ...)
			end
		end
		if not weap_base[Old1] and type(weap_base["trigger_released"]) == "function" then
			weap_base[Old1] = weap_base.trigger_released
			weap_base.trigger_pressed = function (self, pos, dir, dmg_mul, ...)
				dmg_mul = dmg_mul * managers.player:get_temporary_property("birthday_multiplier", 1)
				return self[Old1](self, pos, dir, dmg_mul, ...)
			end
		end
		if not weap_base[Old2] and type(weap_base["trigger_held"]) == "function" then
			weap_base[Old2] = weap_base.trigger_held
			weap_base.trigger_pressed = function (self, pos, dir, dmg_mul, ...)
				dmg_mul = dmg_mul * managers.player:get_temporary_property("birthday_multiplier", 1)
				return self[Old2](self, pos, dir, dmg_mul, ...)
			end
		end
	end
end)