core:module("CoreManagerBase")

ManagerBase = ManagerBase or class()

Hooks:PostHook(ManagerBase, "_prioritize_and_activate", "F_"..Idstring("PostHook:ManagerBase:_prioritize_and_activate:No Post Processing (Post Hook Function):OwO"):key(), function(self)
	if type(self.__aos) ~= "table" then
	
	else
		for _, vp in pairs(self.__really_active) do
			if vp and vp.vp then
				local vp_exp = getmetatable(vp:vp())
				if vp_exp.set_post_processor_effect then
					vp_exp._old_set_post_processor_effect = vp_exp._old_set_post_processor_effect or vp_exp.set_post_processor_effect
					local function new_set(self, ...)
						self:_old_set_post_processor_effect(...)
						self:_old_set_post_processor_effect("World", Idstring("post_SSAO"), Idstring("empty"))
						self:_old_set_post_processor_effect("World", Idstring("video_anti_alias"), Idstring("AA_off"))
						self:_old_set_post_processor_effect("World", Idstring("light_adaption"), Idstring("no_light_adaption"))
						self:_old_set_post_processor_effect("World", Idstring("post_LEX_composite"), Idstring("empty"))
						self:_old_set_post_processor_effect("World", Idstring("post_DOF"), Idstring("empty"))
						self:_old_set_post_processor_effect("World", Idstring("depth_projection"), Idstring("depth_project_empty"))
						self:_old_set_post_processor_effect("World", Idstring("shadow_slice_depths"), Vector3(0, 0, 0))
						self:_old_set_post_processor_effect("World", Idstring("shadow_slice_overlap"), Vector3(0, 0, 0))
						self:_old_set_post_processor_effect("World", Idstring("deferred_lighting"), Idstring("empty"))
						self:_old_set_post_processor_effect("World", Idstring("apply_ambient"), Idstring("empty"))
						self:_old_set_post_processor_effect("World", Idstring("color_grading_post"), Idstring("empty"))
						self:_old_set_post_processor_effect("World", Idstring("reflection_visualization"), Idstring("empty"))
						self:_old_set_post_processor_effect("World", Idstring("glossiness_visualization"), Idstring("empty"))
						self:_old_set_post_processor_effect("World", Idstring("specular_visualization"), Idstring("empty"))
						self:_old_set_post_processor_effect("World", Idstring("hdr_post_processor"), Idstring("empty"))
						self:_old_set_post_processor_effect("World", Idstring("bloom_combine_post_processor"), Idstring("bloom_combine_empty"))
						self:_old_set_post_processor_effect("World", Idstring("bloom_combine"), Idstring("bloom_combine_empty"))
						self:_old_set_post_processor_effect("World", Idstring("shadow_modifier"), Idstring("empty"))
						self:_old_set_post_processor_effect("World", Idstring("shadow_rendering"), Idstring("empty"))
					end
					vp_exp.set_post_processor_effect = new_set
				end
			end
		end
	end
end)