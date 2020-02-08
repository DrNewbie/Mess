local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local ids_drill = Idstring('units/payday2/equipment/item_door_drill_small/item_door_drill_small')
local ids_bullet_hit_blood = Idstring("effects/payday2/particles/impacts/blood/blood_impact_a")
local ids_head = Idstring('Head')
local tmp_vec = Vector3()
local mvec3_set = mvector3.set

function _G.mtga_link_drill_to_bulldo(parent_unit, drill_unit)
	if not mtga_is_enabled then
		return
	end

	local head = parent_unit:get_object(ids_head)
	local head_rot = head:rotation()
	local rot = Rotation()
	mrotation.set_yaw_pitch_roll(rot, head_rot:yaw(), head_rot:pitch() - 130, head_rot:roll())
	local pos = head:position() + head_rot:y() * 7 + head_rot:z() * 24

	if not drill_unit then
		drill_unit = World:spawn_unit(ids_drill, pos, rot)
		drill_unit:timer_gui():set_can_jam(false)
		drill_unit:timer_gui():set_override_timer(6)
		drill_unit:base()._disable_upgrades = true
		drill_unit:interaction():interact()
		drill_unit:interaction():set_active(false, true)

		for peer_id, state in pairs(mtga_users) do
			if state and peer_id ~= 1 then
				local peer = managers.network:session():peer(peer_id)
				if peer and peer:synched() then
					managers.network:session():send_to_peer(peer, 'loot_link', drill_unit, parent_unit)
				end
			end
		end

	else
		drill_unit:base()._disable_upgrades = true
		DelayedCalls:Add('DelayedModMTGA_drillpos_' .. tostring(parent_unit:key()), 0.01, function()
			if alive(drill_unit) then
				drill_unit:set_position(pos)
				drill_unit:set_rotation(rot)
			end
		end)
	end

	parent_unit:interaction().has_been_pierced = true
	parent_unit:link(ids_head, drill_unit)

	return drill_unit
end

function _G.mtga_unlink_drill(drill_unit)
	mvec3_set(tmp_vec, drill_unit:parent():movement():m_head_rot():y() * -1)
	drill_unit:unlink()
	local body = drill_unit:body(0)
	body:set_enabled(true)
	body:set_dynamic()
	drill_unit:base():set_powered(false)
	drill_unit:push(50, tmp_vec * -600)

	if Network:is_server() then
		for peer_id, state in pairs(mtga_users) do
			if state and peer_id ~= 1 then
				local peer = managers.network:session():peer(peer_id)
				if peer and peer:synched() then
					managers.network:session():send_to_peer(peer, 'loot_link', drill_unit, drill_unit)
				end
			end
		end
	end
end

local mtga_original_intimitateinteractionext_init = IntimitateInteractionExt.init
function IntimitateInteractionExt:init(unit, ...)
	if alive(unit) then
		local ubase = unit:base()
		if ubase and ubase._tweak_table == 'tank' then
			self.is_tank = true
			self.tweak_data = 'drill_tank'
		end
	end
	mtga_original_intimitateinteractionext_init(self, unit, ...)
end

function IntimitateInteractionExt:save(data)
	IntimitateInteractionExt.super.save(self, data)
	if self.is_tank then
		data.InteractionExt.tweak_data = 'drill'
	end
end

function IntimitateInteractionExt:can_select(...)
	if self.is_tank then
		if not mtga_is_enabled then
			return false
		end
		if self._unit:id() == -1 then
			return false
		end
		if self.has_been_pierced then
			return false
		end
		if self.tweak_data ~= 'drill_tank' then
			self:set_tweak_data('drill_tank')
		end
	end
	return IntimitateInteractionExt.super.can_select(self, ...)
end

local mtga_original_intimitateinteractionext_caninteract = IntimitateInteractionExt.can_interact
function IntimitateInteractionExt:can_interact(...)
	if self.is_tank then
		return mtga_is_enabled
	end
	return IntimitateInteractionExt.super.can_interact(self, ...)
end

local mtga_original_intimitateinteractionext_interact = IntimitateInteractionExt.interact
function IntimitateInteractionExt:interact(player)
	if not self:can_interact(player) then
		return
	end

	if self.tweak_data == 'drill_tank' then
		if self._tweak_data.sound_event then
			player:sound():play(self._tweak_data.sound_event)
		end

		if Network:is_server() then
			mtga_start_drilling(self)
		else
			LuaNetworking:SendToPeer(1, 'MTGA_drill', self._unit:id())
		end

		return
	end

	mtga_original_intimitateinteractionext_interact(self, player)
end

function _G.mtga_start_drilling(self)
	if self.has_been_pierced then
		return
	end

	local drill_unit = mtga_link_drill_to_bulldo(self._unit)
	if not drill_unit then
		return
	end
	self.mtga_drill = drill_unit

	DelayedCalls:Add('DelayedModMTGA1_' .. tostring(self._unit:key()), 2, function()
		mtga_step_1(self, player)
	end)
end

function _G.mtga_step_1(self, player)
	if not alive(self._unit) or self._unit:id() == -1 then
		mtga_step_4(self)
		return
	end

	mvec3_set(tmp_vec, self._unit:movement():m_head_rot():y() * -1)
	local body = self._unit:body('body_helmet_plate')
	local col_ray =	{
		body = body,
		unit = self._unit,
		ray = tmp_vec,
		normal = tmp_vec,
		position = self.mtga_drill:position()
	}
	local normal_vec_yaw, normal_vec_pitch = InstantBulletBase._get_vector_sync_yaw_pitch(col_ray.normal, 128, 64)
	local dir_vec_yaw, dir_vec_pitch = InstantBulletBase._get_vector_sync_yaw_pitch(col_ray.ray, 128, 64)
	managers.network:session():send_to_peers_synched('sync_body_damage_bullet', col_ray.body, self.mtga_drill, normal_vec_yaw, normal_vec_pitch, col_ray.position, dir_vec_yaw, dir_vec_pitch, 16384)

	self._unit:damage():run_sequence_simple('int_seq_helmet_plate')

	DelayedCalls:Add('DelayedModMTGA2_' .. tostring(self._unit:key()), 2, function()
		mtga_step_2(self, player)
	end)
end

function _G.mtga_step_2(self, player)
	mvec3_set(tmp_vec, self._unit:movement():m_head_rot():y() * -1)
	local body = self._unit:body('body_helmet_glass')
	local col_ray = {
		body = body,
		unit = self._unit,
		ray = tmp_vec,
		normal = tmp_vec,
		position = self.mtga_drill:position()
	}
	local normal_vec_yaw, normal_vec_pitch = InstantBulletBase._get_vector_sync_yaw_pitch(col_ray.normal, 128, 64)
	local dir_vec_yaw, dir_vec_pitch = InstantBulletBase._get_vector_sync_yaw_pitch(col_ray.ray, 128, 64)
	managers.network:session():send_to_peers_synched('sync_body_damage_bullet', col_ray.body, self.mtga_drill, normal_vec_yaw, normal_vec_pitch, col_ray.position, dir_vec_yaw, dir_vec_pitch, 16384)

	self._unit:damage():run_sequence_simple('int_seq_helmet_glass_02')

	DelayedCalls:Add('DelayedModMTGA3_' .. tostring(self._unit:key()), 2, function()
		mtga_step_3(self, player)
	end)
end

function _G.mtga_step_3(self, player)
	if not alive(self._unit) or self._unit:id() == -1 then
		mtga_step_4(self)
		return
	end

	mtga_unlink_drill(self.mtga_drill)

	mvec3_set(tmp_vec, self._unit:movement():m_head_rot():y() * -1)
	local damage_info = {
		attacker_unit = player,
		damage = self._unit:character_damage()._health,
		col_ray = {
			body = self._unit:body('body'),
			unit = self._unit,
			ray = tmp_vec,
			normal = tmp_vec,
			position = self.mtga_drill:position()
		}
	}
	self._unit:character_damage():damage_melee(damage_info)
	World:effect_manager():spawn({
		effect = ids_bullet_hit_blood,
		position = self.mtga_drill:position(),
		normal = tmp_vec
	})

	DelayedCalls:Add('DelayedModMTGA4_' .. tostring(self._unit:key()), 1, function()
		mtga_step_4(self)
	end)
end

function _G.mtga_step_4(self)
	if alive(self.mtga_drill) then
		World:delete_unit(self.mtga_drill)
	end
	self.mtga_drill = nil
end
