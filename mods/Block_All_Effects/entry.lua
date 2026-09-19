local Wrld = getmetatable(World:effect_manager())

--[[
local Banned_Effect_List = {
	[Idstring('effects/payday2/particles/explosions/molotov_grenade'):key()] = true,
	[Idstring('effects/payday2/particles/weapons/big_762_auto_fps'):key()] = true,
	[Idstring('effects/particles/weapons/weapon_trail'):key()] = true,
	[Idstring('effects/payday2/particles/weapons/shells/shell_slug'):key()] = true
}
]]

if Wrld.spawn then
	Wrld._orgi_spawn = Wrld._orgi_spawn or Wrld.spawn
	local function effect_spawn(self, ...)
		--[[
		local data = {...}
		if data[1] and type(data[1].effect) == "userdata" then
			if Banned_Effect_List[data[1].effect:key()] then
				return nil
			end
		end
		return self:_orgi_spawn(...)
		]]
		return nil
	end
	Wrld.spawn = effect_spawn
end