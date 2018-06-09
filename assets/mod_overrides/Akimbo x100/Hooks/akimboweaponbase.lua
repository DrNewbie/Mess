function AkimboWeaponBase:_create_second_gun_alt(id)
	local factory_weapon = tweak_data.weapon.factory[self._factory_id]
	local ids_unit_name = Idstring(factory_weapon.unit)
	local new_unit = World:spawn_unit(ids_unit_name, Vector3(), Rotation())

	new_unit:base():set_factory_data(self._factory_id)

	if self._cosmetics_id then
		new_unit:base():set_cosmetics_data({
			id = self._cosmetics_id,
			quality = self._cosmetics_quality,
			bonus = self._cosmetics_bonus
		})
	end

	if self._blueprint then
		new_unit:base():assemble_from_blueprint(self._factory_id, self._blueprint)
	elseif not unit_name then
		new_unit:base():assemble(self._factory_id)
	end

	self._second_gun_alt[id] = new_unit
	self._second_gun_alt[id]:base().SKIP_AMMO = true
	self._second_gun_alt[id]:base().parent_weapon = self._unit

	if self:fire_mode() == "auto" then
		self._second_gun_alt[id]:base():mute_firing()
	end

	new_unit:base():setup(self._setup)

	self.akimbo = true
	
	if self._enabled then
		self._second_gun_alt[id]:base():on_enabled()
	else
		self._second_gun_alt[id]:base():on_disabled()
	end
end

Hooks:PostHook(AkimboWeaponBase, "init", "AkimboWTF_gun_init", function(self)
	self._second_gun_alt = self._second_gun_alt or {}
end)

Hooks:PostHook(AkimboWeaponBase, "_create_second_gun", "AkimboWTF_create_second_gun", function(self)
	if self._second_gun and self._unit and self._unit.base and self._unit:base()._AkimboWTF then
		local _AkimboWTF = self._unit:base()._AkimboWTF
		local _AkimboWTFLink = self._unit:base()._AkimboWTFLink
		self:_create_second_gun_alt(1)
		self:_create_second_gun_alt(2)
		if self._second_gun_alt and self._second_gun_alt[1] and self._second_gun_alt[2] then
			self._second_gun:link(Idstring(_AkimboWTFLink), self._second_gun_alt[1], self._second_gun_alt[1]:orientation_object():name())
			self._unit:link(Idstring(_AkimboWTFLink), self._second_gun_alt[2], self._second_gun_alt[2]:orientation_object():name())
			_AkimboWTF = _AkimboWTF - 2
			for i = 3, _AkimboWTF do
				self:_create_second_gun_alt(i)
				self._second_gun_alt[i-2]:link(Idstring(_AkimboWTFLink), self._second_gun_alt[i], self._second_gun_alt[i]:orientation_object():name())
			end
		end
	end	
end)

Hooks:PostHook(AkimboWeaponBase, "on_enabled", "AkimboWTF_second_gun_on_enabled", function(self, ...)
	for _, d in pairs(self._second_gun_alt) do
		if d and alive(d) then
			d:base():on_enabled(...)
		end
	end
end)

Hooks:PostHook(AkimboWeaponBase, "on_disabled", "AkimboWTF_second_gun_on_disabled", function(self, ...)
	for _, d in pairs(self._second_gun_alt) do
		if d and alive(d) then
			d:base():on_disabled(...)
		end
	end
end)

function AkimboWeaponBase:create_second_gun(create_second_gun)
	self:_create_second_gun(create_second_gun)
	self._setup.user_unit:camera()._camera_unit:link(Idstring("a_weapon_left"), self._second_gun, self._second_gun:orientation_object():name())
end

local curret_alt_gun_unit = nil
local curret_alt_gun_fire = 1

function AkimboWeaponBase:_fire_alt(...)
	local weapon_base = self._unit:base()
	if weapon_base._AkimboWTF then
		if curret_alt_gun_unit ~= self._unit then
			curret_alt_gun_unit = self._unit
			curret_alt_gun_fire = 1
		end
		local d = self._second_gun_alt[curret_alt_gun_fire]
		curret_alt_gun_fire = curret_alt_gun_fire + 1
		if curret_alt_gun_fire > weapon_base._AkimboWTF then
			curret_alt_gun_fire = 1
		end	
		local data = {...}
		if data[1] then
			local ply_pos = data[1][1]
			local fir_dir = data[1][2]
			if ply_pos and fir_dir then
				local _pos_offset = function ()
					local ang = math.random() * 360 * math.pi
					local rad = math.random(20, 30)
					return Vector3(math.cos(ang)*rad, math.sin(ang)*rad, 0)
				end
				local camera = managers.player:player_unit():movement()._current_state._ext_camera
				local mvec_to = Vector3()
				local from_pos = camera:position()
				mvector3.set(mvec_to, camera:forward())
				mvector3.multiply(mvec_to, 20000)
				mvector3.add(mvec_to, from_pos)
				if d and alive(d) then
					local d_base = d:base()
					d_base:_spawn_muzzle_effect()
					if d_base._fire_sound then
						d_base:_fire_sound()
					end
					if d_base._trail_effect_table then
						d_base._trail_effect_table.position = d_base._unit:position() + _pos_offset()
						d_base._trail_effect_table.normal = mvec_to - d_base._trail_effect_table.position
						World:effect_manager():spawn(d_base._trail_effect_table)
					end
				end
			end
		end
	end
end

local AkimboWTF_weapon_fire = AkimboWeaponBase.fire
function AkimboWeaponBase:fire(...)
	local Ans = AkimboWTF_weapon_fire(self, ...)
	if Ans and self._unit and self._unit.base and self._unit:base()._AkimboWTF then
		local _AkimboWTF = self._unit:base()._AkimboWTF
		for i = 1, _AkimboWTF do
			table.insert(self._fire_callbacks, {
				t = self:get_fire_time() + math.random() * (1/_AkimboWTF) * math.cos(i),
				callback = callback(self, self, "_fire_alt", {...})
			})
		end
	end
	return Ans
end