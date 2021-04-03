local SAMPLE_TYPE = 1

local mod_ids = Idstring("Fake Aimbots"):key()
local func2 = "F_"..Idstring("func2::"..mod_ids):key()
local func3 = "F_"..Idstring("func3::"..mod_ids):key()
local func4 = "F_"..Idstring("func4::"..mod_ids):key()

Hooks:PostHook(PlayerStandard, "init", func3, function (self)
	self[func4] = false
end)

Hooks:PostHook(PlayerStandard, "update", func2, function (self, t, dt)
	if tweak_data.network and self._unit and self._unit:camera() then
		if SAMPLE_TYPE == 1 then
			local self_camera = self._unit:camera()
			local sync_dt = t
			local sync_dir_yaw = 0
			local sync_yaw = (math.random()*1000)%255
			if type(self_camera._last_sync_t) == "number" then
				sync_dt = sync_dt - self._unit:camera()._last_sync_t
			end
			if type(self_camera._sync_dir) == "table" and type(self_camera._sync_dir.yaw) == "number" then
				sync_dir_yaw = self_camera._sync_dir.yaw
			end
			local angle_delta = math.abs(sync_dir_yaw - sync_yaw)
			local update_network = tweak_data.network.camera.network_sync_delta_t < sync_dt and angle_delta > 0 or tweak_data.network.camera.network_angle_delta < angle_delta
			if update_network then
				self._unit:network():send("set_look_dir", sync_yaw, 90)
				self._unit:camera()._last_sync_t = t
			end
		end
	end
end)