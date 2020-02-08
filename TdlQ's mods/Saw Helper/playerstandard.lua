local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local saw_draw_box = false -- else quad
local color_ok = Color(0.1, 0, 1, 0)
local color_nok = Color(0.1, 1, 0.2, 0)

local mvec3_add = mvector3.add
local mvec3_dis_sq = mvector3.distance_sq
local mvec3_len_sq = mvector3.length_sq
local mvec3_mul = mvector3.multiply
local mvec3_set = mvector3.set

local mvec_to = Vector3()
local mvec_spread_direction = Vector3()
local brush_ok = Draw:brush(color_ok)
local brush_nok = Draw:brush(color_nok)
local oobb_dims = {}

local saw_original_playerstandard_enter = PlayerStandard.enter
function PlayerStandard:enter(...)
	saw_original_playerstandard_enter(self, ...)

	local wbase = alive(self._equipped_unit) and self._equipped_unit:base()
	self.saw_check_hitboxes = wbase and wbase:is_category('saw')
end

local saw_original_playerstandard_startactionequipweapon = PlayerStandard._start_action_equip_weapon
function PlayerStandard:_start_action_equip_weapon(...)
	saw_original_playerstandard_startactionequipweapon(self, ...)

	local wbase = alive(self._equipped_unit) and self._equipped_unit:base()
	self.saw_check_hitboxes = wbase and wbase:is_category('saw')
end

local saw_original_playerstandard_update = PlayerStandard.update
function PlayerStandard:update(t, dt)
	saw_original_playerstandard_update(self, t, dt)

	if self.saw_check_hitboxes and alive(self._equipped_unit) then
		local wbase = self._equipped_unit:base()
		local from_pos = wbase._obj_fire:position()
		local direction = wbase._obj_fire:rotation():y()
		mvec3_add(from_pos, direction * -30)
		mvec3_set(mvec_spread_direction, direction)
		mvec3_set(mvec_to, mvec_spread_direction)
		mvec3_mul(mvec_to, 100)
		mvec3_add(mvec_to, from_pos)
		local ray = World:raycast('ray', from_pos, mvec_to, 'slot_mask', wbase._bullet_slotmask, 'ignore_unit', wbase._setup.ignore_units, 'ray_type', 'body lock')
		local body_aimed = ray and ray.body

		local my_pos = self._unit:position()
		local bodies = World:find_bodies('intersect', 'sphere', self._equipped_unit:position(), 200, wbase._bullet_slotmask)
		for _, body in ipairs(bodies) do
			local ext = body:extension()
			local extdmg = ext and ext.damage
			if extdmg and extdmg._endurance and extdmg._endurance.lock then
				local brush = body == body_aimed and brush_ok or brush_nok
				local oobb = body:oobb()

				if saw_draw_box then
					brush:box(oobb:center(), oobb:x(), oobb:y(), oobb:z())
				else
					oobb_dims[1] = { mvec3_len_sq(oobb:x()), oobb:x() }
					oobb_dims[2] = { mvec3_len_sq(oobb:y()), oobb:y() }
					oobb_dims[3] = { mvec3_len_sq(oobb:z()), oobb:z() }
					table.sort(oobb_dims, function(a, b) return a[1] > b[1] end)
					local corner = oobb:corner()
					local corner2 = corner + oobb_dims[3][2]
					if mvec3_dis_sq(corner, my_pos) > mvec3_dis_sq(corner2, my_pos) then
						corner = corner2
					end
					corner = corner - direction * 2
					local a = oobb_dims[1][2] * 2
					local b = oobb_dims[2][2] * 2
					brush:quad(corner, corner + a, corner + a + b, corner + b)
				end
			end
		end
	end
end
