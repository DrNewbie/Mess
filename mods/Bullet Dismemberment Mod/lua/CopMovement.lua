Hooks:PreHook(CopMovement, "update", "BulletDecapitationsPreCopMovementUpdate", function(self, unit, t, dt)
	if not BulletDecapitations then
	
	else
		local __set_BD = function(__unit, __object, __body)
			if __unit and __unit:get_object(Idstring(__object)) then
				__unit:get_object(Idstring(__object)):m_position(__body:position())
				__unit:get_object(Idstring(__object)):m_rotation(__body:rotation())
				__unit:get_object(Idstring(__object)):set_position(__body:position())
				__unit:get_object(Idstring(__object)):set_rotation(__body:rotation())
				__unit:get_object(Idstring(__object)):set_visibility(false)
			end
			return
		end
		for decap_unit, _ in pairs(BulletDecapitations.cop_decapitation.ragdoll) do
			if decap_unit == self._unit then
				local bone_body = self._unit:get_object(Idstring("LeftUpLeg"))
				local bone_body2 = self._unit:get_object(Idstring("RightUpLeg"))
				local bone_body3 = self._unit:get_object(Idstring("LeftShoulder"))
				local bone_body4 = self._unit:get_object(Idstring("RightShoulder"))
				local bone_body5 = self._unit:get_object(Idstring("Spine1"))
				self._need_upd = false
				self._force_head_upd = nil
				self:upd_ground_ray()
				for part , _ in pairs(BulletDecapitations.cop_decapitation.parts[unit]) do
					if part == "Head" then
						__set_BD(self._unit, "Head", bone_body5)
					elseif part == "LeftArm" then
						__set_BD(self._unit, "LeftShoulder", bone_body3)
						__set_BD(self._unit, "LeftArm", bone_body3)
						__set_BD(self._unit, "LeftForeArm", bone_body3)
						__set_BD(self._unit, "LeftHand", bone_body3)
					elseif part == "LeftLeg" then
						__set_BD(self._unit, "LeftUpLeg", bone_body)
						__set_BD(self._unit, "LeftLeg", bone_body)
						__set_BD(self._unit, "LeftFoot", bone_body)
					elseif part == "RightArm" then
						__set_BD(self._unit, "RightShoulder", bone_body4)
						__set_BD(self._unit, "RightArm", bone_body4)
						__set_BD(self._unit, "RightForeArm", bone_body4)
						__set_BD(self._unit, "RightHand", bone_body4)
					elseif part == "RightLeg" then
						__set_BD(self._unit, "RightUpLeg", bone_body2)
						__set_BD(self._unit, "RightLeg", bone_body2)
						__set_BD(self._unit, "RightFoot", bone_body2)
					else
						
					end
				end
			end
		end
	end
end)