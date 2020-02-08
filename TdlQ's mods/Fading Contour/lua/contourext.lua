local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

FadingContour:UpdateHvtContourColors()

DelayedCalls:Add('DelayedModFC_enemyweaponshot', 0, function()
	if managers.groupai then
		managers.groupai:state():add_listener('FadingContour_enemyweaponshot', {'enemy_weapons_hot'}, callback(ContourExt, ContourExt, 'fc_on_enemy_weapons_hot'))
	end
end)

local _is_loud = false
function ContourExt:fc_on_enemy_weapons_hot()
	_is_loud = true
end

ContourExt.fc_last_ratio = 1

local fc_original_contourext_add = ContourExt.add
function ContourExt:add(...)
	local result = fc_original_contourext_add(self, ...)

	if result then
		local data = self._types[result.type]
		local fade_duration = _is_loud and data.fadeout or data.fadeout_silent
		if fade_duration then
			self:fade_color(1, result)
		end
	end

	return result
end

local fc_original_contourext_update = ContourExt.update
function ContourExt:update(unit, t, dt)
	fc_original_contourext_update(self, unit, t, dt)

	local contour_list = self._contour_list
	local contour = contour_list and contour_list[1]
	if contour and not contour.flash_t then
		local fadeout_t = contour.fadeout_t
		if fadeout_t and t < fadeout_t then
			local ctype = self._types[contour.type]
			local fade_duration = _is_loud and ctype.fadeout or ctype.fadeout_silent
			if fade_duration then
				local ratio = FadingContour:FadeModifier(fadeout_t, t, fade_duration)
				if ratio < 1 and self.fc_last_ratio - ratio > 0.01 or ctype.color_dmg then
					self:fade_color(ratio, contour)
				end
			end
		end
	end
end

local idstr_material = Idstring('material')
local idstr_contour_color = Idstring('contour_color')
local idstr_shadow_caster = Idstring('shadow_caster')
local color = Vector3()
local mvec3_dis = mvector3.distance
local mvec3_mul = mvector3.multiply
local mvec3_set = mvector3.set
function ContourExt:fade_color(ratio, contour)
	self.fc_last_ratio = ratio
	contour = contour or self._contour_list and self._contour_list[1]
	if contour then
		local ctype = self._types[contour.type]
		local base_color = ctype.color or contour.color

		if ctype.damage_bonus_distance and ctype.color_dmg and self._unit:slot() ~= 25 then
			local punit = managers.player:player_unit()
			if alive(punit) then
				local threshold = tweak_data.upgrades.values.player.marked_inc_dmg_distance[ctype.damage_bonus_distance][1]
				local dst = mvec3_dis(punit:position(), self._unit:position())
				if dst > threshold then
					base_color = ctype.color_dmg
				end
			end
		end

		mvec3_set(color, base_color)
		mvec3_mul(color, ratio)

		-- don't trust what's cached, might be outdated and fade won't occur
		local materials = self._unit:get_objects_by_type(idstr_material)
		self._materials = materials
		for _, material in ipairs(materials) do
			if alive(material) and material:name() ~= idstr_shadow_caster then
				material:set_variable(idstr_contour_color, color)
			end
		end
	end
end
