Hooks:PreHook( CopMovement , "update" , "BulletDecapitationsPreCopMovementUpdate" , function( self , unit , t , dt )

	if not BulletDecapitations then return end
	
	for decap_unit, _ in pairs( BulletDecapitations.cop_decapitation.ragdoll ) do
		
		if decap_unit == unit then
			local bone_body = self._unit:get_object(Idstring("LeftUpLeg"))
			local bone_body2 = self._unit:get_object(Idstring("RightUpLeg"))
			local bone_body3 = self._unit:get_object(Idstring("LeftShoulder"))
			local bone_body4 = self._unit:get_object(Idstring("RightShoulder"))
			local bone_body5 = self._unit:get_object(Idstring("Spine1"))
			
			self._need_upd = false
			self._force_head_upd = nil
			
			self:upd_ground_ray()
			
			--[[self._unit:movement():enable_update()
			self._unit:movement()._frozen = nil
			if self._unit:movement()._active_actions[1] then
				self._unit:movement()._active_actions[1]:force_ragdoll()
			end]]
			
			for part , _ in pairs( BulletDecapitations.cop_decapitation.parts[unit] ) do
			
				if part == "Head" then
				
					self._unit:get_object(Idstring("Head")):m_position(bone_body5:position())
					self._unit:get_object(Idstring("Head")):set_position(bone_body5:position())
					self._unit:get_object(Idstring("Head")):set_rotation(bone_body5:rotation())
				
				elseif part == "LeftArm" then

					self._unit:get_object(Idstring("LeftArm")):m_position(bone_body3:position())
					self._unit:get_object(Idstring("LeftArm")):set_position(bone_body3:position())
					self._unit:get_object(Idstring("LeftArm")):set_rotation(bone_body3:rotation())
					self._unit:get_object(Idstring("LeftForeArm")):m_position(self._unit:get_object(Idstring("LeftArm")):position())
					self._unit:get_object(Idstring("LeftForeArm")):set_position(self._unit:get_object(Idstring("LeftArm")):position())
					self._unit:get_object(Idstring("LeftForeArm")):set_rotation(self._unit:get_object(Idstring("Spine1")):rotation())
					self._unit:get_object(Idstring("LeftHand")):m_position(self._unit:get_object(Idstring("Spine1")):position())
					self._unit:get_object(Idstring("LeftHand")):set_position(self._unit:get_object(Idstring("Spine1")):position())
					self._unit:get_object(Idstring("LeftHand")):set_rotation(self._unit:get_object(Idstring("Spine1")):rotation())
					
				end
			
				if part == "RightArm" then
			
					self._unit:get_object(Idstring("RightArm")):m_position(bone_body4:position())
					self._unit:get_object(Idstring("RightArm")):set_position(bone_body4:position())
					self._unit:get_object(Idstring("RightArm")):set_rotation(bone_body4:rotation())
					self._unit:get_object(Idstring("RightForeArm")):m_position(self._unit:get_object(Idstring("RightArm")):position())
					self._unit:get_object(Idstring("RightForeArm")):set_position(self._unit:get_object(Idstring("RightArm")):position())
					self._unit:get_object(Idstring("RightForeArm")):set_rotation(self._unit:get_object(Idstring("Spine1")):rotation())
					self._unit:get_object(Idstring("RightHand")):m_position(self._unit:get_object(Idstring("Spine1")):position())
					self._unit:get_object(Idstring("RightHand")):set_position(self._unit:get_object(Idstring("Spine1")):position())
					self._unit:get_object(Idstring("RightHand")):set_rotation(self._unit:get_object(Idstring("Spine1")):rotation())
					
				end
				
				if part == "LeftLeg" then
			
					self._unit:get_object(Idstring("LeftLeg")):m_position(bone_body:position())
					self._unit:get_object(Idstring("LeftLeg")):set_position(bone_body:position())
					self._unit:get_object(Idstring("LeftLeg")):set_rotation(bone_body:rotation())
					self._unit:get_object(Idstring("LeftFoot")):m_position(self._unit:get_object(Idstring("Hips")):position())
					self._unit:get_object(Idstring("LeftFoot")):set_position(self._unit:get_object(Idstring("Hips")):position())
					self._unit:get_object(Idstring("LeftFoot")):set_rotation(self._unit:get_object(Idstring("Hips")):rotation())
					
				end
				
				if part == "RightLeg" then
			
					self._unit:get_object(Idstring("RightLeg")):m_position(bone_body2:position())
					self._unit:get_object(Idstring("RightLeg")):set_position(bone_body2:position())
					self._unit:get_object(Idstring("RightLeg")):set_rotation(bone_body2:rotation())
					self._unit:get_object(Idstring("RightFoot")):m_position(self._unit:get_object(Idstring("Hips")):position())
					self._unit:get_object(Idstring("RightFoot")):set_position(self._unit:get_object(Idstring("Hips")):position())
					self._unit:get_object(Idstring("RightFoot")):set_rotation(self._unit:get_object(Idstring("Hips")):rotation())
					
				end
				
			end
			
		end
	
	end

end )