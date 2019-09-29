local function Add_Random_Carry_to_Unit(them)
	local visual_unit_name = {}
	for _, data in pairs(tweak_data.carry) do
		if data.visual_unit_name then
			visual_unit_name[Idstring(data.visual_unit_name)] = true
		end
	end
	local carry_visual = table.random_key(visual_unit_name)
	while not PackageManager:unit_data(carry_visual) do
		carry_visual = table.random_key(visual_unit_name)
	end
	if carry_visual then
		local s_unit = safe_spawn_unit(carry_visual, them._unit:position())
		local objects = {
			"Spine",
			"Spine1",
			"Spine2",
			"LeftShoulder",
			"RightShoulder",
			"LeftUpLeg",
			"RightUpLeg"
		}
		them._unit:link(Idstring("Hips"), s_unit, s_unit:orientation_object():name())
		for _, o_name in ipairs(objects) do
			s_unit:get_object(Idstring(o_name)):link(them._unit:get_object(Idstring(o_name)))
			s_unit:get_object(Idstring(o_name)):set_position(them._unit:get_object(Idstring(o_name)):position())
			s_unit:get_object(Idstring(o_name)):set_rotation(them._unit:get_object(Idstring(o_name)):rotation())
		end
	end
	return them
end
if RequiredScript == "lib/units/player_team/teamaimovement" then	
	Hooks:PostHook(TeamAIMovement, "_post_init", "F_"..Idstring("PostHook:TeamAIMovement:_post_init:Giving random carry to people"):key(), function(self)
		if self._unit and alive(self._unit) then
			self = Add_Random_Carry_to_Unit(self)
		end
	end)
elseif RequiredScript == "lib/units/player_team/huskteamaimovement" then
	Hooks:PostHook(HuskTeamAIMovement, "_post_init", "F_"..Idstring("PostHook:HuskTeamAIMovement:_post_init:Giving random carry to people"):key(), function(self)
		if self._unit and alive(self._unit) then
			self = Add_Random_Carry_to_Unit(self)
		end
	end)
elseif RequiredScript == "lib/units/beings/player/huskplayermovement" then
	Hooks:PostHook(HuskPlayerMovement, "post_init", "F_"..Idstring("PostHook:HuskPlayerMovement:post_init:Giving random carry to people"):key(), function(self)
		if self._unit and alive(self._unit) then
			self = Add_Random_Carry_to_Unit(self)
		end
	end)
elseif RequiredScript == "lib/units/enemies/cop/copmovement" then
	Hooks:PostHook(CopMovement, "post_init", "F_"..Idstring("PostHook:CopMovement:post_init:Giving random carry to people"):key(), function(self)
		if self._unit and alive(self._unit) then
			self = Add_Random_Carry_to_Unit(self)
		end
	end)
elseif RequiredScript == "lib/units/enemies/cop/huskcopmovement" then
	Hooks:PostHook(HuskCopMovement, "post_init", "F_"..Idstring("PostHook:HuskCopMovement:post_init:Giving random carry to people"):key(), function(self)
		if self._unit and alive(self._unit) then
			self = Add_Random_Carry_to_Unit(self)
		end
	end)
end