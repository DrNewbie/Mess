local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

if Network:is_server() then

	local fs_original_coplogicattack_update = CopLogicAttack.update
	function CopActionShoot:update(t)
		if not self._attention then
			local attention_obj = self._ext_brain and self._ext_brain._logic_data and self._ext_brain._logic_data.attention_obj
			if attention_obj and attention_obj.reaction >= AIAttentionObject.REACT_SHOOT then
				self:on_attention(attention_obj)
			end
		end

		fs_original_coplogicattack_update(self, t)
	end

end
