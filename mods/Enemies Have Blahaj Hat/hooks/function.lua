local ThisModPath = ModPath

local __Name = function(__id)
	return "EEE_"..Idstring(tostring(__id).."::"..ThisModPath):key()
end


local ThisModUnit = "units/blahaj/blahaj"
local ThisModUnitIds = Idstring(ThisModUnit)
local UnitIds = Idstring("unit")

local MaskUnit = __Name("MaskUnit")

local function __RemovMaskFromThis(them)
	if them._unit or not alive(them._unit) then
		return
	end
	if them[MaskUnit] then
		if alive(them[MaskUnit]) then
			them[MaskUnit]:set_slot(0)
		end
		if alive(them[MaskUnit]) then
			World:delete_unit(them[MaskUnit])
		end
	end
	them[MaskUnit] = nil
	return
end

local function __ApplyMaskToThis(them)
	if not DB:has(UnitIds, ThisModUnitIds) then
		return
	end
	if not them._unit or not alive(them._unit) then
		return
	end
	if CopDamage.is_civilian(them._unit:base()._tweak_table) then
		return
	end
	local mask_align = them._obj_head
	if not mask_align or not mask_align.position or not mask_align.rotation then
		return
	end
	local mask_unit = World:spawn_unit(ThisModUnitIds, mask_align:position(), mask_align:rotation())
	if not mask_unit or not alive(mask_unit) then
		return
	end
	them._unit:link(Idstring("Head"), mask_unit, mask_unit:orientation_object():name())
	them[MaskUnit] = mask_unit
	mask_unit:set_local_rotation(Rotation(90, -90, 0))
	return
end

if CopMovement then
	Hooks:PostHook(CopMovement, "set_character_anim_variables", __Name(1), function(self, ...)
		pcall(__RemovMaskFromThis, self)
		pcall(__ApplyMaskToThis, self)
	end)
end

if HuskCopMovement then
	Hooks:PostHook(HuskCopMovement, "set_character_anim_variables", __Name(2), function(self, ...)
		pcall(__RemovMaskFromThis, self)
		pcall(__ApplyMaskToThis, self)
	end)
end

if CopDamage then
	Hooks:PreHook(CopDamage, "destroy", __Name(3), function(self, ...)
		pcall(__RemovMaskFromThis, self)
	end)
end

if HuskCopDamage then
	Hooks:PreHook(HuskCopDamage, "destroy", __Name(4), function(self, ...)
		pcall(__RemovMaskFromThis, self)
	end)
end