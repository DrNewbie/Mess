_G.SkulldozerRPG = _G.SkulldozerRPG or {}

if Network:is_client() or not SkulldozerRPG then
	return
end

local _f_CopActionShoot__get_target_pos = CopActionShoot._get_target_pos

function CopActionShoot:_get_target_pos(shoot_from_pos, ...)
	local target_pos, target_vec, target_dis, autotarget
	local _time = math.floor(TimerManager:game():time())
	self._throw_projectile_time = self._throw_projectile_time or 0
	if self._unit and self._unit:name():key() == "bfd2c56d614d0228" and self._throw_projectile_time < _time then
		self._throw_projectile_time = _time + SkulldozerRPG.settings.Speed
		shoot_from_pos = shoot_from_pos + Vector3(50, 50, 0)
		target_pos, target_vec, target_dis, autotarget = _f_CopActionShoot__get_target_pos(self, shoot_from_pos, ...)
		throw_projectile2(shoot_from_pos, target_vec)
	else
		target_pos, target_vec, target_dis, autotarget = _f_CopActionShoot__get_target_pos(self, shoot_from_pos, ...)
	end
	return target_pos, target_vec, target_dis, autotarget
end

function throw_projectile2(shoot_from_pos, target_vec)
	local z_fix = {-0.05, -0.02, -0.05, -0.02, -0.07, -0.07, -0.1}
	local _UseWhatList = {"rocket_frag", "frag", "launcher_frag"}
	target_vec = target_vec + Vector3(0, 0, z_fix[math.random(7)])	
	local projectile_entry = _UseWhatList[SkulldozerRPG.settings.UseWhat]
	local projectile_data = tweak_data.blackmarket.projectiles[projectile_entry]
	local projectile_index = tweak_data.blackmarket:get_index_from_projectile_id(projectile_entry)
	if not projectile_data.client_authoritative then
		if Network:is_client() then
			managers.network:session():send_to_host("request_throw_projectile", projectile_index, shoot_from_pos, target_vec)
		else
			ProjectileBase.throw_projectile(projectile_index, shoot_from_pos, target_vec, 0)
		end
	else
		ProjectileBase.throw_projectile(projectile_index, shoot_from_pos, target_vec, 0)
	end
end