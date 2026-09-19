local ThisModPath = ModPath

if not MutatorHelper or not MutatorCG22 then
	return
end

MutatorCG22Alt = MutatorCG22Alt or class(MutatorCG22)

MutatorCG22Alt.categories = {
	"gameplay"
}

MutatorCG22Alt.texture = {
    path = "guis/dlcs/trk/textures/pd2/achievements_atlas6",
	x = 261,
	y = 87,
	w = 85,
	h = 85
}

pcall(function()
	if not _G[Idstring("MutatorCG22Alt")] then
		_G[Idstring("MutatorCG22Alt")] = true
		MutatorHelper:AddMutator(MutatorCG22Alt, ThisModPath)
	end
end)

function MutatorCG22:spawn_network_units()
	if Network:is_server() and not self._sync_listener_key then
		self._tree = World:spawn_unit(Idstring(MutatorCG22.tree), self._position, self._rotation)
		self._sled = World:spawn_unit(Idstring(MutatorCG22.sled), self._sled_position, self._sled_rotation)
		local direction = Vector3(math.cos(self._sled_rotation:yaw()), math.sin(self._sled_rotation:yaw()), 0)
		local santa_rotation = Rotation(self._sled:rotation():yaw() + 180, self._sled:rotation():pitch(), self._sled:rotation():roll())
		self._santa = World:spawn_unit(Idstring(MutatorCG22.santa), self._sled:position() + Vector3(math.cos(self._sled:rotation():yaw() + 90) * -115, math.sin(self._sled:rotation():yaw() + 90) * -115, 0) + Vector3(0, 0, 30), santa_rotation)
		--self._santa:movement():set_team(managers.groupai:state():team_data("non_combatant"))
		self._santa:movement():play_redirect("cm_so_pilot_drunk_idle")
		self._shredder = World:spawn_unit(Idstring(MutatorCG22.shredder), self._shredder_position, self._shredder_rotation)
		self._tree:damage().external_spawn_unit_callback = self.damage_on_present_spawned
		self._tree:damage():add_trigger_callback("interact_tree_clbk", callback(self, self, "_on_tree_interacted", self._tree))
		if managers.navigation:is_data_ready() then
			managers.navigation:add_pos_reservation({
				radius = 350,
				position = self._position
			})
			managers.navigation:add_obstacle(self._tree, Idstring("c_convex_01"))
			managers.navigation:add_pos_reservation({
				radius = 350,
				position = self._sled_position,
				rotation = self._sled_rotation
			})
			managers.navigation:add_obstacle(self._sled, Idstring("c_box_10"))
			managers.navigation:add_pos_reservation({
				radius = 350,
				position = self._shredder_position
			})
			managers.navigation:add_obstacle(self._shredder, Idstring("c_box_01"))
		end
		self._sync_listener_key = "MutatorCG22"
		managers.network:add_event_listener(self._sync_listener_key, "session_peer_sync_complete", callback(self, self, "on_peer_sync_complete"))
		managers.network:session():send_to_peers_synched("sync_cg22_spawned_units", self._tree, self._sled, self._shredder, self._santa)
	end
end