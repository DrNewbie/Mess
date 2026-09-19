local ThisModPath = ModPath
local function __Name(__text)
	return "SSS_"..Idstring(tostring(__text)..ThisModPath):key()
end

local modifier_name = Idstring("action_upper_body")

if EnemyManager and not EnemyManager[__Name(1)] then
	EnemyManager[__Name(1)] = true
	Hooks:PostHook(EnemyManager, "update", __Name(2), function (self, __t)
		if type(self._enemy_data) == "table" and type(self._enemy_data.unit_data) == "table" then
			local __enemies = self._enemy_data.unit_data
			for _, __data in pairs(__enemies) do
				if __data.unit and alive(__data.unit) and __data.unit:base() and __data.unit:movement() and __data.unit:base()._tweak_table == "sniper" then
					local modifier = __data.unit:movement()._machine:get_modifier(modifier_name)
					if modifier then
						__data.unit:movement()._machine:force_modifier(modifier_name)
						modifier:set_target_y(math.UP)
						__data.unit:set_local_rotation(Rotation:yaw_pitch_roll((__t * 1000) % 360, 0, 0))
					end
				end
			end
		end
	end)
end