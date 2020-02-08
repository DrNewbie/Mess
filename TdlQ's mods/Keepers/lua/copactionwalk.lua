local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local kpr_original_copactionwalk_chkcorrectpose = CopActionWalk._chk_correct_pose
function CopActionWalk:_chk_correct_pose()
	if self._expired and self._action_desc.kpr_so_expiration then
		if self._ext_anim.interact then
			self._expired = false
			return
		end
	end

	kpr_original_copactionwalk_chkcorrectpose(self)
end
