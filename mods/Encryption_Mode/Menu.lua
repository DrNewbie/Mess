local old_build_mods_list = MenuCallbackHandler.build_mods_list

function MenuCallbackHandler:build_mods_list(...)
    local __ans_mod = old_build_mods_list(self, ...)
	if self:is_modded_client() then
		for __key, __data in pairs(__ans_mod) do
			__ans_mod[__key] = {
				Idstring(mod:GetName().."#"..tostring(math.random()).."#"..tostring(os.time())):key(),
				Idstring(mod:GetId().."#"..tostring(math.random()).."#"..tostring(os.time())):key()
			}
		end
	end
	return __ans_mod
end