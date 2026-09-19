function PlayerManager:__is_smoke_screen_grenade()
	return managers.blackmarket:equipped_grenade() == "smoke_screen_grenade" and self.__smoke_screen_grenade_init and self.__is_smoke_screen_grenade_ok
end

function PlayerManager:__smoke_screen_grenade_unit_nmae()
	return self.__smoke_screen_grenade
end

function PlayerManager:__clbk_smoke_screen_grenade_unit_loaded()
	self.__is_smoke_screen_grenade_ok = true
	if self:__is_smoke_screen_grenade() then
		self:register_message(Message.OnEnemyKilled, "__"..Idstring("Sicario Perk Deck Buff: Speed it Up!!"):key(), function ()
			managers.player:speed_up_grenade_cooldown(5)
		end) 
	end
end

Hooks:PostHook(PlayerManager, "spawned_player", "F_"..Idstring("PostHook:PlayerManager:spawned_player:Sicario Perk Deck Buff"):key(), function(self)
	if not self.__smoke_screen_grenade_init then
		self.__smoke_screen_grenade_init = true
		self.__smoke_screen_grenade = Idstring("units/pd2_dlc_max/weapons/wpn_fps_smoke_screen_grenade/wpn_fps_smoke_screen_grenade_husk")
		if not managers.dyn_resource:is_resource_ready(Idstring("unit"), self.__smoke_screen_grenade, managers.dyn_resource.DYN_RESOURCES_PACKAGE) then
			managers.dyn_resource:load(Idstring("unit"), self.__smoke_screen_grenade, managers.dyn_resource.DYN_RESOURCES_PACKAGE, callback(self, self, "__clbk_smoke_screen_grenade_unit_loaded"))
		else
			self:__clbk_smoke_screen_grenade_unit_loaded()
		end
	end
end)

function PlayerManager:QuickSmokeRun()
	if managers.blackmarket:equipped_grenade() ~= "smoke_screen_grenade" then
		return
	end
	if self:get_timer_remaining("replenish_grenades") then
		return
	end
	self:on_throw_grenade()
	if self.__QuickSmokeHusk and self.__QuickSmokeHusk._timer then
		self.__QuickSmokeHusk._timer = -1
		self.__QuickSmokeHusk:update(TimerManager:game():time(), 0.1)
		self.__QuickSmokeHusk = nil
	end
	local __time = tweak_data.projectiles.smoke_screen_grenade.duration
	if self:has_category_upgrade("player", "sicario_multiplier") then
		__time = __time * self:upgrade_value("player", "sicario_multiplier", 1)
	end
	self.__QuickSmokeHusk = SmokeScreenEffectAlt:new(self:player_unit():position(), math.UP, __time, true, self:player_unit())
	if self.__QuickSmokeHusk then
		self._smoke_screen_effects = self._smoke_screen_effects or {}
		table.insert(self._smoke_screen_effects, self.__QuickSmokeHusk)
	end
end

Hooks:PostHook(PlayerManager, "update", "F_"..Idstring("PostHook:PlayerManager:update:Sicario Perk Deck Buff"):key(), function(self, t, dt)
	if self.__QuickSmokeHusk and self.__QuickSmokeHusk.update then
		self.__QuickSmokeHusk:update(t, dt)
	end
end)