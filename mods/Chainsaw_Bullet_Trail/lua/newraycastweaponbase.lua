function NewRaycastWeaponBase:SpawnChainSawBulletTrail(from_pos, direction)
	local mvec_to = Vector3()		

	mvector3.set(mvec_to, direction)
	mvector3.multiply(mvec_to, 20000)
	mvector3.add(mvec_to, from_pos)
	
	local factory_weapon = tweak_data.weapon.factory["wpn_fps_saw"]
	local ids_unit_name = Idstring(factory_weapon.unit)
	
	if not managers.dyn_resource:is_resource_ready(Idstring("unit"), ids_unit_name, managers.dyn_resource.DYN_RESOURCES_PACKAGE) then
		managers.dyn_resource:load(Idstring("unit"), ids_unit_name, managers.dyn_resource.DYN_RESOURCES_PACKAGE, nil)
		return
	end
	
	local throw_gun = World:spawn_unit(ids_unit_name, from_pos, Rotation())
	if throw_gun then
		throw_gun:base():set_factory_data("wpn_fps_saw")
		throw_gun:base():assemble("wpn_fps_saw")
		throw_gun:base():check_npc()
		throw_gun:base():setup({
			user_unit = managers.player:local_player(),
			ignore_units = {
				managers.player:local_player(),
				throw_gun
			}
		})
		throw_gun:base():set_visibility_state(true)
		throw_gun:base():on_enabled()
		managers.player:set_throw_gun_data({
			__dead_t = TimerManager:game():time() + 5,
			__to_pos = mvec_to,
			__from_pos = from_pos,
			__unit = throw_gun
		})
	end
end

local HookAddBulletTrail = NewRaycastWeaponBase.fire

function NewRaycastWeaponBase:fire(from_pos, direction, ...)
	self:SpawnChainSawBulletTrail(from_pos, direction)
	return HookAddBulletTrail(self, from_pos, direction, ...)
end