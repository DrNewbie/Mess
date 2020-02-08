local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local shd_original_sentrygunbase_postsetup = SentryGunBase.post_setup
function SentryGunBase:post_setup()
	shd_original_sentrygunbase_postsetup(self)

	if self:is_owner() then
		self.shd_label_id = self._unit:character_damage():shd_create_label()
		self._unit:weapon().shd_display_info = true
		self._unit:weapon():shd_update_label()
	end
end

local shd_original_sentrygunbase_oninteraction = SentryGunBase.on_interaction
function SentryGunBase:on_interaction()
	managers.hud:_remove_name_label(self.shd_label_id)
	shd_original_sentrygunbase_oninteraction(self)
end
