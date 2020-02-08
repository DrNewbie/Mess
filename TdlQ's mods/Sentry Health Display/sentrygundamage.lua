local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

function SentryGunDamage:shd_create_label()
	local unit = self._unit
	if unit:unit_data().name_label_id then
		return
	end

	local label_data = { unit = unit, name = '' }
	local panel_id = managers.hud:_add_name_label(label_data)
	unit:unit_data().name_label_id = panel_id

	local name_label = managers.hud:_get_name_label(panel_id)
	if not name_label then
		return
	end

	local previous_icon = name_label.panel:child('bag')
	if previous_icon then
		name_label.panel:remove(previous_icon)
		previous_icon = nil
	end

	local radial_health = name_label.panel:bitmap({
		name = 'bag',
		texture = 'guis/textures/pd2/hud_health',
		texture_rect = {
			128,
			0,
			-128,
			128
		},
		render_template = 'VertexColorTexturedRadial',
		blend_mode = 'add',
		alpha = 1,
		w = 16,
		h = 16,
		layer = 0,
	})
	name_label.bag = radial_health

	local txt = name_label.panel:child('text')
	radial_health:set_center_y(txt:center_y())
	local l, r, w, h = txt:text_rect()
	radial_health:set_left(txt:left() + w + 2)

	self.shd_radial_health = radial_health
	return panel_id
end

function SentryGunDamage:update_sentry_radial(ratio)
	local rd = self.shd_radial_health
	if alive(rd) then
		rd:set_color(Color(1, ratio, 1, 1))
	else
		self._radial_health = nil
	end
end

local shd_original_sentrygundamage_synchealth = SentryGunDamage.sync_health
function SentryGunDamage:sync_health(...)
	shd_original_sentrygundamage_synchealth(self, ...)
	self:update_sentry_radial(self._health_ratio * 100)
end

local shd_original_sentrygundamage_applydamage = SentryGunDamage._apply_damage
function SentryGunDamage:_apply_damage(...)
	local result = shd_original_sentrygundamage_applydamage(self, ...)
	self:update_sentry_radial(self._health / self._HEALTH_INIT)
	return result
end
