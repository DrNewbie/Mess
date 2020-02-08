local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local shd_original_sentrygunweapon_changeammo = SentryGunWeapon.change_ammo
function SentryGunWeapon:change_ammo(...)
	shd_original_sentrygunweapon_changeammo(self, ...)
	self:shd_update_label()
end

local shd_original_sentrygunweapon_fire = SentryGunWeapon.fire
function SentryGunWeapon:fire(...)
	local result = self._muzzle_effect_table and shd_original_sentrygunweapon_fire(self, ...)
	self:shd_update_label()
	return result
end

function SentryGunWeapon:shd_update_label()
	local name_label = managers.hud:_get_name_label(self._unit:unit_data().name_label_id)
	if name_label then
		local text = name_label.panel:child('text')
		if text then
			local ammo_ratio = Network:is_server() and self:ammo_ratio() or self:get_virtual_ammo_ratio()
			local str = managers.localization:text(self._unit:base():interaction_text_id(), {AMMO_LEFT = math.round(ammo_ratio * 100)})
			text:set_text(string.split(str, '\n')[2]:sub(2, -2))
			managers.hud:align_teammate_name_label(name_label.panel, name_label.interact)
		end
	end
end

local shd_original_sentrygunweapon_switchfiremode = SentryGunWeapon.switch_fire_mode
function SentryGunWeapon:switch_fire_mode()
	shd_original_sentrygunweapon_switchfiremode(self)
	local name_label = managers.hud:_get_name_label(self._unit:unit_data().name_label_id)
	if name_label then
		local text = name_label.panel:child('text')
		if text then
			local list = self._unit:contour()._contour_list
			local cur = list and list[1]
			if cur then
				local c = ContourExt._types[cur.type].color or cur.color
				if c then
					text:set_color(Color(c.x, c.y, c.z))
				end
			end
		end
	end
end
