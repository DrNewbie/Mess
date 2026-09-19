local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()

local __Name = function(__id)
	return "B_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end

local is_bool = __Name(0)
local is_say = __Name(-1)

local __Say_line = function(__tweak_data, __user_unit)
	if _G[is_say] then
		return
	end
	if not __user_unit or not alive(__user_unit) then
		return
	end
	if type(__tweak_data) ~= "string" and type(__tweak_data) ~= "table" then
		return
	end
	_G[is_say] = true
	call_on_next_update(function()
		_G[is_say] = false
		pcall(function()
			__user_unit:sound():play("g43", nil, true)
		end)
	end)
	return
end

if WeaponUnderbarrelLauncher then
	Hooks:PostHook(WeaponUnderbarrelLauncher, "_fire_raycast", __Name("WeaponUnderbarrelLauncher"), function(self, weapon_base, user_unit, ...)
		call_on_next_update(function()
			__Say_line(self._launcher_projectile, user_unit)
		end)
	end)
end

if GrenadeLauncherBase then
	Hooks:PostHook(GrenadeLauncherBase, "_fire_raycast", __Name("GrenadeLauncherBase"), function(self, user_unit, ...)
		call_on_next_update(function()
			__Say_line(self._projectile_type, user_unit)
		end)
	end)
end