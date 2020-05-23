local __ids_key = Idstring("keybind_RemoteStickybomb_BoomIt_keybind_id"):key()
_G[__ids_key] = _G[__ids_key] or {}
for _, them in pairs(_G[__ids_key]) do
	if them and type(them.__stickbomb_unit) == "table" then
		for _, __bomb in pairs(them.__stickbomb_unit) do
			if __bomb and alive(__bomb) then
				__bomb:base():explode()
			end
		end
	end
end