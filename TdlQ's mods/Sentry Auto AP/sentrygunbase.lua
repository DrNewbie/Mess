local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local sap_original_sentrygunbase_postsetup = SentryGunBase.post_setup
function SentryGunBase:post_setup()
	sap_original_sentrygunbase_postsetup(self)

	if self._owner_id == managers.network:session():local_peer():id() then
		if PlayerSkill.has_skill('sentry_gun', 'ap_bullets') then
			if not self._unit:weapon()._use_armor_piercing then
				self._unit:weapon():switch_fire_mode()
			end
		end
	end
end
