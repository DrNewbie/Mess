core:module("CoreManagerBase")

ManagerBase = ManagerBase or class()

local _block_post = {
	[Idstring("post_SSAO"):key()] = Idstring("empty"),
	[Idstring("video_anti_alias"):key()] = Idstring("AA_off"),
	[Idstring("light_adaption"):key()] = Idstring("no_light_adaption"),
	[Idstring("post_LEX_composite"):key()] = Idstring("empty"),
	[Idstring("post_DOF"):key()] = Idstring("empty"),
	[Idstring("depth_projection"):key()] = Idstring("depth_project_empty"),
	[Idstring("shadow_slice_depths"):key()] = Vector3(0, 0, 0),
	[Idstring("shadow_slice_overlap"):key()] = Vector3(0, 0, 0),
	[Idstring("deferred_lighting"):key()] = Idstring("empty"),
	[Idstring("apply_ambient"):key()] = Idstring("empty"),
	[Idstring("color_grading_post"):key()] = Idstring("empty"),
	[Idstring("reflection_visualization"):key()] = Idstring("empty"),
	[Idstring("glossiness_visualization"):key()] = Idstring("empty"),
	[Idstring("specular_visualization"):key()] = Idstring("empty"),
	[Idstring("rain_post_processor"):key()] = Idstring("rain_off"),
	[Idstring("snow_post_processor"):key()] = Idstring("snow_off"),
	[Idstring("hdr_post_processor"):key()] = Idstring("default")
}

Hooks:PostHook(ManagerBase, "_prioritize_and_activate", "F_"..Idstring("PostHook:ManagerBase:_prioritize_and_activate:No Post Processing (Post Hook Function):OwO"):key(), function(self)
	if type(self.__aos) ~= "table" then
	
	else
		for _, vp in pairs(self.__really_active) do
			if vp and vp.vp then
				local vp_exp = getmetatable(vp:vp())
				if vp_exp.set_post_processor_effect then
					vp_exp._old_set_post_processor_effect = vp_exp._old_set_post_processor_effect or vp_exp.set_post_processor_effect
					local function new_set(self, v1, v2, v3, ...)
						if type(v1) == type("World") and type(v2) == type(Idstring("type")) then 
							if _block_post[v2:key()] then
								v3 = _block_post[v2:key()]
							end
						end
						self:_old_set_post_processor_effect(v1, v2, v3, ...)
					end
					vp_exp.set_post_processor_effect = new_set
				end
			end
		end
	end
end)