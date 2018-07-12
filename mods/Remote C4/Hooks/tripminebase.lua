_G.RemoteC4FUN = _G.RemoteC4FUN or {}
RemoteC4FUN = _G.RemoteC4FUN or {}
RemoteC4FUN.Record = RemoteC4FUN.Record or {}

Hooks:PostHook(TripMineBase, "set_active", "RemoteC4_RecordIt", function(self)
	if self._active and self._unit and alive(self._unit) and type(self._owner_peer_id) == "number" then
		local peer_id = self._owner_peer_id
		local peer = managers.network:session():peer(peer_id)
		if peer then
			RemoteC4FUN.Record[peer_id] = RemoteC4FUN.Record[peer_id] or {}
			if not RemoteC4FUN.Record[peer_id].user_id or RemoteC4FUN.Record[peer_id].user_id ~= peer:user_id() then
				RemoteC4FUN.Record[peer_id] = {
					user_id = peer:user_id(),
					units = {}
				}
			end
			table.insert(RemoteC4FUN.Record[peer_id].units, self._unit)
		end
	end
end)

function TripMineBase.RemoteC4_Boom()
	local weapon_unit = managers.player:equipped_weapon_unit()
	if not weapon_unit or not alive(weapon_unit) then
		return
	end
	local ply_unit = managers.player:player_unit()
	if not ply_unit or not alive(ply_unit) then
		return
	end
	local PlyStandard = ply_unit:movement() and ply_unit:movement()._states.standard
	if not PlyStandard then
		return
	end
	local cam_fwd = ply_unit:camera():forward()
	local peer = managers.network:session():local_peer()
	if peer then
		local peer_id = peer:id()
		RemoteC4FUN.Record[peer_id] = RemoteC4FUN.Record[peer_id] or {}
		if type(RemoteC4FUN.Record[peer_id].units) == "table" then
			for i, c4_unit in pairs(RemoteC4FUN.Record[peer_id].units) do
				if alive(c4_unit) then
					local c4_pos = c4_unit:position()
					local vec = c4_pos - ply_unit:position()
					local dis = mvector3.normalize(vec)
					local max_angle = math.max(8, math.lerp(10, 30, dis / 1200))
					local angle = vec:angle(cam_fwd)					
					if angle < max_angle or math.abs(max_angle-angle) < 10 then
						c4_unit:base()._active = true
						c4_unit:base():explode()
						RemoteC4FUN.Record[peer_id].units[i] = nil
						PlyStandard:_do_action_intimidate(TimerManager:game():time(), "cmd_gogo", "g18", true)
						break
					end
				else
					RemoteC4FUN.Record[peer_id].units[i] = nil
				end
			end
		end
	end
end