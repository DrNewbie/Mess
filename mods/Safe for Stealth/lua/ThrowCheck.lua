if not Network:is_server() then
	return
end

_G.Safe4Stealth = _G.Safe4Stealth or {}

local PeerThrowCheck = UnitNetworkHandler.request_throw_projectile

function UnitNetworkHandler:request_throw_projectile(projectile_type_index, position, dir, sender)
	local peer = self._verify_sender(sender)
	if not self._verify_gamestate(self._gamestate_filter.any_ingame) or not peer then
		return
	end
	if peer:id() ~= 1 and managers.groupai:state():whisper_mode() then
		local projectile_entry = tostring(tweak_data.blackmarket:get_projectile_name_from_index(projectile_type_index))
		local projectile_tweak = tweak_data.blackmarket.projectiles[projectile_entry]
		local tweak_projectile = tweak_data.projectiles[projectile_entry]
		if (projectile_tweak and (projectile_tweak.is_explosive or projectile_tweak.is_a_grenade)) or (tweak_projectile and (tweak_projectile.bullet_class == "PoisonBulletBase" or tweak_projectile.bullet_class == "InstantExplosiveBulletBase" or tweak_projectile.bullet_class == "ProjectilesPoisonBulletBase")) then
			projectile_type_index = tweak_data.blackmarket:get_index_from_projectile_id("wpn_prj_ace")
			local identifier = "cheater_banned_" .. tostring(peer:id())
			managers.chat:feed_system_message(1, peer:name() .. " has been marked because throw loud noise thing ("..projectile_entry..")")
			dir = Vector3(0, 0, -1)
			position = Vector3(-9999, -9999, -9999)
			Safe4Stealth:Kick_Peer("throw", peer)
		end
	end
	PeerThrowCheck(self, projectile_type_index, position, dir, sender)
end