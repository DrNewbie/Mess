local mod_ids = Idstring("Fake Aimbots"):key()
local func1 = "F_"..Idstring("func1::"..mod_ids):key()

local mvec1 = Vector3()
local camera_mvec = Vector3()
local reticle_mvec = Vector3()

PlayerCamera[func1] = PlayerCamera[func1] or PlayerCamera.set_rotation

function PlayerCamera:set_rotation(rot, ...)
	if _G.IS_VR then
		self[func1](self, rot, ...)
	else
		mrotation.y(rot, mvec1)
		mvector3.multiply(mvec1, 100000)
		mvector3.add(mvec1, self._m_cam_pos)
		self._camera_controller:set_target(mvec1)
		mrotation.z(rot, mvec1)
		self._camera_controller:set_default_up(mvec1)
		mrotation.set_yaw_pitch_roll(self._m_cam_rot, rot:yaw(), rot:pitch(), rot:roll())
		mrotation.y(self._m_cam_rot, self._m_cam_fwd)
		local t = TimerManager:game():time()
		local sync_dt = t - self._last_sync_t
		local sync_yaw = rot:yaw()
		sync_yaw = sync_yaw % 360
		if sync_yaw < 0 then
			sync_yaw = 360 - sync_yaw
		end
		sync_yaw = math.floor(255 * sync_yaw / 360)
		local sync_pitch = nil
		sync_pitch = math.clamp(rot:pitch(), -85, 85) + 85
		sync_pitch = math.floor(127 * sync_pitch / 170)
		local angle_delta = math.abs(self._sync_dir.yaw - sync_yaw) + math.abs(self._sync_dir.pitch - sync_pitch)
		if tweak_data.network then
			local update_network = tweak_data.network.camera.network_sync_delta_t < sync_dt and angle_delta > 0 or tweak_data.network.camera.network_angle_delta < angle_delta
			local locked_look_dir = self._locked_look_dir_t and t < self._locked_look_dir_t
			if update_network then
				self._sync_dir.yaw = sync_yaw
				self._sync_dir.pitch = sync_pitch
				self._last_sync_t = t
			end
		end		
	end
end