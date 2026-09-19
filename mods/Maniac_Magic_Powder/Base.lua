local __ManiacMagicPowde_ModPath = ModPath

_G.__ManiacMagicPowde = _G.__ManiacMagicPowde or {}

if PlayerManager then
	function PlayerManager:IsEquipManiacMagicPowde()
		if managers.blackmarket:equipped_grenade() ~= "magic_powder" then
			return false
		end
		return true
	end
	function PlayerManager:UseManiacMagicPowde()
		if self:IsEquipManiacMagicPowde() then
			local local_peer_id = managers.network:session() and managers.network:session():local_peer():id()
			if not local_peer_id or not self:has_category_upgrade("player", "cocaine_stacking") then
				return
			else
				self:update_synced_cocaine_stacks_to_peers(
					(tweak_data.upgrades.max_total_cocaine_stacks or 2047), 
					self:upgrade_value("player", "sync_cocaine_upgrade_level", 1), 
					self:upgrade_level("player", "cocaine_stack_absorption_multiplier", 0)
				)
			end
		end
		return
	end
	Hooks:PostHook(PlayerManager, "spawned_player", "F_"..Idstring("__ManiacMagicPowde_spawned_player"):key(), function(self)
		if self:IsEquipManiacMagicPowde() then
			self:register_message(Message.OnEnemyKilled, "__"..Idstring("Magic Powder (Maniac): Speed it Up!!"):key(), function ()
				managers.player:speed_up_grenade_cooldown(2)
			end)
		end
	end)
end

if BlackMarketTweakData then
	Hooks:PostHook(BlackMarketTweakData, "_init_projectiles", "F_"..Idstring("__ManiacMagicPowde_init_projectiles"):key(), function(self, tweak_data)
		self.projectiles.magic_powder = deep_clone(self.projectiles.concussion)		
		self.projectiles.magic_powder.name_id = "bm_grenade_magic_powder"
		self.projectiles.magic_powder.desc_id = "bm_grenade_magic_powder_desc"
		self.projectiles.magic_powder.icon = "pd2_power"
		self.projectiles.magic_powder.ability = true
		self.projectiles.magic_powder.throwable = nil
		self.projectiles.magic_powder.texture_bundle_folder = "magic_powder"
		self.projectiles.magic_powder.max_amount = 1
		self.projectiles.magic_powder.base_cooldown = 30
		self.projectiles.magic_powder.sounds = {cooldown = "perkdeck_cooldown_over"}		
	end)
end

if PlayerEquipment then
	local __ManiacMagicPowde_throw_grenade = PlayerEquipment.throw_grenade
	function PlayerEquipment:throw_grenade(...)
		if not managers.player:IsEquipManiacMagicPowde() then
		
		else
			managers.player:UseManiacMagicPowde()
			managers.player:on_throw_grenade()
			return
		end
		return __ManiacMagicPowde_throw_grenade(self, ...)
	end
end

if UpgradesTweakData then
	Hooks:PostHook(UpgradesTweakData, "_grenades_definitions", "F_"..Idstring("__ManiacMagicPowde_grenades_definitions"):key(), function(self)
		self.definitions.magic_powder = {category = "grenade"}
	end)
end

if SkillTreeTweakData then
	Hooks:PostHook(SkillTreeTweakData, "init", "F_"..Idstring("__ManiacMagicPowde__SkillTree_Init"):key(), function(self)
		table.insert(self.specializations[14][1].upgrades, "magic_powder")
	end)
end

if NetworkMatchMakingSTEAM then
	local Block_set_attributes_original = NetworkMatchMakingSTEAM.set_attributes
	function NetworkMatchMakingSTEAM:set_attributes(settings, ...)
		if settings.numbers[3] < 3 then
			settings.numbers[3] = 3
		end
		return Block_set_attributes_original(self, settings, ...)
	end

	local Block_is_server_ok_original = NetworkMatchMakingSTEAM.is_server_ok
	function NetworkMatchMakingSTEAM:is_server_ok(friends_only, room, attributes_list, is_invite)
		if attributes_list.numbers and attributes_list.numbers[3] < 3 then
			return false
		end
		return Block_is_server_ok_original(self, friends_only, room, attributes_list, is_invite)
	end
end