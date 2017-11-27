core:import("CoreMissionScriptElement")

ElementAssetTrigger = ElementAssetTrigger or class(CoreMissionScriptElement.MissionScriptElement)

UAA_Allow = UAA_Allow or {}

function ElementAssetTrigger:on_executed(instigator)
	if not self._values.enabled then
		return
	end
	if not UAA_Allow.doctor_bag and self._values.id == "health_bag" then
		UAA_Allow.doctor_bag = true
	elseif not UAA_Allow.ammo_bag and self._values.id == "ammo_bag" then
		UAA_Allow.ammo_bag = true
	elseif not UAA_Allow.grenade_crate and self._values.id == "grenade_crate" then
		UAA_Allow.grenade_crate = true
	elseif not UAA_Allow.bodybags_bag and self._values.id == "bodybags_bag" then
		UAA_Allow.bodybags_bag = true
	end
	ElementAssetTrigger.super.on_executed(self, instigator)
end
