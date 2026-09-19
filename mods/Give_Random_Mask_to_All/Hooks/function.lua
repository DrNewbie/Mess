GiveMask = GiveMask or {}

function GiveMask:__ApplyMaskToThis(them)
	if not managers.dyn_resource or not them or not them.__ids_mask or not them._unit or not alive(them._unit) or them._unit == managers.player:player_unit() or not them._unit.get_object then
		return
	end
	local mask_align = them._unit:get_object(Idstring("Head"))
	if not mask_align or not mask_align.position or not mask_align.rotation then
		return
	end
	if not managers.dyn_resource:is_resource_ready(Idstring("unit"), them.__ids_mask, managers.dyn_resource.DYN_RESOURCES_PACKAGE) then
		return
	end
	local mask_unit = safe_spawn_unit(them.__ids_mask, mask_align:position(), mask_align:rotation())
	if not mask_unit or not alive(mask_unit) then
		return
	end
	them._unit:link(mask_align:name(), mask_unit, mask_unit:orientation_object():name())
	them.__mask_unit = mask_unit
	return
end

function GiveMask:__GiveMaskToThis(them)
	if not managers.dyn_resource or not them._unit or not alive(them._unit) or them._unit == managers.player:player_unit() then
		return
	end
	local __mask_unit, __try = nil, 30
	while __try > 0 and (not __mask_unit or not DB:has(Idstring("unit"), Idstring(__mask_unit))) do
		__mask_unit = tweak_data.blackmarket.masks[table.random_key(tweak_data.blackmarket.masks)].unit
		__try = __try - 1
	end
	if not __mask_unit or not DB:has(Idstring("unit"), Idstring(__mask_unit)) then
		return
	end
	if them.__mask_unit and alive(them.__mask_unit) then
		for _, linked_unit in ipairs(them.__mask_unit:children()) do
			linked_unit:unlink()
			World:delete_unit(linked_unit)
		end
		them.__mask_unit:unlink()
		World:delete_unit(them.__mask_unit)
	end
	them.__mask_unit = nil
	them.__ids_mask = Idstring(__mask_unit)
	DelayedCalls:Add('F_'..Idstring('DelayedCalls:GiveMask:__ApplyMaskToThis:'..tostring(them._unit:key())):key(), math.random()*20 + math.random(), function()
		if not managers.dyn_resource:is_resource_ready(Idstring("unit"), Idstring(__mask_unit), managers.dyn_resource.DYN_RESOURCES_PACKAGE) then
			managers.dyn_resource:load(Idstring("unit"), Idstring(__mask_unit), managers.dyn_resource.DYN_RESOURCES_PACKAGE, callback(self, self, "__ApplyMaskToThis", them))
		else
			self:__ApplyMaskToThis(them)
		end
	end)
end

if CopMovement then
	Hooks:PostHook(CopMovement, "set_character_anim_variables", "F_"..Idstring("CopMovement:set_character_anim_variables:CopGetMask"):key(), function(self)
		GiveMask:__GiveMaskToThis(self)
	end)
end

if HuskCopMovement then
	Hooks:PostHook(HuskCopMovement, "set_character_anim_variables", "F_"..Idstring("HuskCopMovement:set_character_anim_variables:CopGetMask"):key(), function(self)
		GiveMask:__GiveMaskToThis(self)
	end)
end

if PlayerMovement then
	Hooks:PostHook(PlayerMovement, "set_character_anim_variables", "F_"..Idstring("PlayerMovement:set_character_anim_variables:CopGetMask"):key(), function(self)
		GiveMask:__GiveMaskToThis(self)
	end)
end

if HuskPlayerMovement then
	Hooks:PostHook(HuskPlayerMovement, "set_character_anim_variables", "F_"..Idstring("HuskPlayerMovement:set_character_anim_variables:CopGetMask"):key(), function(self)
		GiveMask:__GiveMaskToThis(self)
	end)
end

if TeamAIMovement then
	Hooks:PostHook(TeamAIMovement, "set_character_anim_variables", "F_"..Idstring("TeamAIMovement:set_character_anim_variables:CopGetMask"):key(), function(self)
		GiveMask:__GiveMaskToThis(self)
	end)
end

if HuskTeamAIMovement then
	Hooks:PostHook(HuskTeamAIMovement, "set_character_anim_variables", "F_"..Idstring("HuskTeamAIMovement:set_character_anim_variables:CopGetMask"):key(), function(self)
		GiveMask:__GiveMaskToThis(self)
	end)
end