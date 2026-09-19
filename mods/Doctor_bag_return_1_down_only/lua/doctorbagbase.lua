local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local __Name = function(__id)
	return "R1D_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end
local Hook1 = __Name("DoctorBagBase:_take")

DoctorBagBase[Hook1] = DoctorBagBase[Hook1] or DoctorBagBase._take

function DoctorBagBase:_take(__unit, ...)
	local ply_dmg = __unit:character_damage()
	local new_revives = Application:digest_value(ply_dmg._revives, false)
	new_revives = math.min(new_revives + 1, ply_dmg:get_revives_max())
	self[Hook1](self, __unit, ...)
	ply_dmg._revives = Application:digest_value(new_revives, true)
	managers.hud:set_player_health({
		current = ply_dmg:get_real_health(),
		total = ply_dmg:_max_health(),
		revives = new_revives
	})
	managers.environment_controller:set_last_life(new_revives <= 1)
	ply_dmg:_send_set_revives()
	return 1
end