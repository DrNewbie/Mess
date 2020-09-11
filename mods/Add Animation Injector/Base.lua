local __self_unit = "units/pd2_dlc_ssm/weapons/wpn_fps_mel_fear/wpn_fps_mel_fear"
local __dummy_unit = "units/pd2_dlc_ssm/weapons/wpn_fps_mel_fear/wpn_third_mel_fear"

if BlackMarketTweakData then
	Hooks:PostHook(BlackMarketTweakData, "_init_projectiles", "F_"..Idstring("Add Animation:chico_injector:_init_projectiles:"):key(), function(self)
		self.projectiles["chico_injector"].unit = __self_unit
		self.projectiles["chico_injector"].unit_dummy = __dummy_unit
		self.projectiles["chico_injector"].sprint_unit = __dummy_unit
		self.projectiles["chico_injector"].animation = "throw_dada"
		self.projectiles["chico_injector"].anim_global_param = "projectile_dada"
		self.projectiles["chico_injector"].throw_allowed_expire_t = 0.1
		self.projectiles["chico_injector"].expire_t = 2
		self.projectiles["chico_injector"].repeat_expire_t = 2.5
		self.projectiles["chico_injector"].is_a_grenade = true
	end)
end

if PlayerEquipment then
	Hooks:PostHook(PlayerEquipment, "init", "F_"..Idstring("Add Animation:chico_injector:init:"):key(), function(self)
		if not managers.dyn_resource:is_resource_ready(Idstring("unit"), Idstring(__self_unit), managers.dyn_resource.DYN_RESOURCES_PACKAGE) then
			managers.dyn_resource:load(Idstring("unit"), Idstring(__self_unit), managers.dyn_resource.DYN_RESOURCES_PACKAGE)
		end
		if not managers.dyn_resource:is_resource_ready(Idstring("unit"), Idstring(__dummy_unit), managers.dyn_resource.DYN_RESOURCES_PACKAGE) then
			managers.dyn_resource:load(Idstring("unit"), Idstring(__dummy_unit), managers.dyn_resource.DYN_RESOURCES_PACKAGE)
		end
	end)
	local __old_throw_grenade = PlayerEquipment.throw_grenade
	function PlayerEquipment:throw_grenade(...)
		local grenade_name = managers.blackmarket:equipped_grenade()
		local grenade_tweak = tweak_data.blackmarket.projectiles[grenade_name]
		if type(grenade_tweak) == "table" and grenade_tweak.ability then
			managers.player:on_throw_grenade()
			managers.player:local_player():sound():play("pickup_fak_skill")
			return
		end
		return __old_throw_grenade(self, ...)
	end
end