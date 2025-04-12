local ThisModPath = tostring(ModPath)
local ThisModIds = Idstring(ThisModPath):key()

local __Name = function(__id)
	return "K_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end

Hooks:PostHook(ExplosionManager, "units_to_push", __Name(300), function(self, units_to_push, hit_pos, range)
	if type(BulletDecapitations) == "table" and type(BulletDecapitations.BD_ToApplyBody) == "function" then
		for u_key, unit in pairs(units_to_push) do
			if alive(unit) then
				local is_character = unit:character_damage() and unit:character_damage().damage_explosion
				if is_character and unit:character_damage():dead() then
					BulletDecapitations:BD_ToApplyBody(
						unit:character_damage(),
						{},
						true
					)
				end
			end
		end
	end
end)