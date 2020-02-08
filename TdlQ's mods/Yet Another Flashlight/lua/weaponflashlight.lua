local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local mvec3_add = mvector3.add
local mvec3_mul = mvector3.multiply
local mvec3_neg = mvector3.negate
local mvec3_set = mvector3.set

local mvec1 = Vector3()
local mvec2 = Vector3()
local mvec_l_dir = Vector3()

local yaf_original_weaponflashlight_init = WeaponFlashLight.init
function WeaponFlashLight:init(...)
	yaf_original_weaponflashlight_init(self, ...)

	if self.liwl_is_local_player then
		self._light:set_far_range(10000)
		self._light:set_spot_angle_end(25)

		local texture = self:is_haunted() and 'units/lights/spot_light_projection_textures/spotprojection_22_flashlight_df' or 'units/lights/spot_light_projection_textures/spotprojection_11_flashlight_df'
		self.yaf_light = World:create_light('spot|specular|plane_projection', texture)
		self.yaf_light:set_spot_angle_end(80)
		self.yaf_light:set_far_range(2000)
		self.yaf_light:set_multiplier(0.3)
		local obj = self._a_flashlight_obj
		local rot = obj:rotation()
		self.yaf_light:link(obj)
		self.yaf_light:set_rotation(Rotation(rot:z(), -rot:x(), -rot:y()))
		self.yaf_light:set_enable(false)
	end
end

local yaf_original_weaponflashlight_destroy = WeaponFlashLight.destroy
function WeaponFlashLight:destroy(unit)
	WeaponFlashLight.super.destroy(self, unit)

	if alive(self.yaf_light) then
		World:delete_light(self.yaf_light)
	end
end

local yaf_original_weaponflashlight_update = WeaponFlashLight.update
function WeaponFlashLight:update(unit, t, dt)
	yaf_original_weaponflashlight_update(self, unit, t, dt)

	if self.liwl_is_local_player then
		local player_unit = managers.player:player_unit()
		local camera = player_unit and player_unit:camera()
		if camera then
			mrotation.y(self._a_flashlight_obj:rotation(), mvec_l_dir)

			local from = mvec1
			mvec3_set(from, mvec_l_dir)
			mvec3_mul(from, 40)
			mvec3_add(from, self.liwl_previous_raycast_from)
			mvec3_set(self.liwl_previous_raycast_from, camera:position())

			local to = mvec2
			mvec3_set(to, mvec_l_dir)
			mvec3_mul(to, 20000)
			mvec3_add(to, from)

			local ray = self._unit:raycast('ray', from, to)
			if ray then
				local distance = ray.distance
				self.yaf_light:set_position(ray.position)
				self.yaf_light:set_final_position(from)
				self._light:set_position(ray.position)
				self._light:set_final_position(from)
				self._light:set_multiplier(math.clamp(1000 / distance, 1.2, 2))
			end
		end
	end
end

local yaf_original_weaponflashlight_checkstate = WeaponFlashLight._check_state
function WeaponFlashLight:_check_state(current_state)
	yaf_original_weaponflashlight_checkstate(self, current_state)

	if self.liwl_is_local_player then
		if self._on and not self._is_haunted then
			local original_opacity = WeaponFlashLight.EFFECT_OPACITY_MAX
			WeaponFlashLight.EFFECT_OPACITY_MAX = 1
			self:set_color(self:color())
			WeaponFlashLight.EFFECT_OPACITY_MAX = original_opacity
		end

		self.yaf_light:set_enable(self._on)
	end
end
