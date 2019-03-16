_G.SentryGunModeFUN = _G.SentryGunModeFUN or {}
SentryGunModeFUN = _G.SentryGunModeFUN or {}
SentryGunModeFUN.Record = SentryGunModeFUN.Record or {}

local function RecordThisSentryGunBase(them)
	local u_key = them._unit:key()
	SentryGunModeFUN.Record[u_key] = SentryGunModeFUN.Record[u_key] or {}
	SentryGunModeFUN.Record[u_key] = them._unit
	them._switch_mode = 0
	them._switch_mode_dt = 0
end

Hooks:PostHook(SentryGunBase, "set_owner_id", "SentryGunBase_RecordIt1", function(self)
	if self:is_owner() then
		RecordThisSentryGunBase(self)
	end
end)

Hooks:PostHook(SentryGunBase, "setup", "SentryGunBase_RecordIt2", function(self, owner)
	if owner and managers.network:session():local_peer() == managers.network:session():peer_by_unit(owner) then
		RecordThisSentryGunBase(self)
	end
end)

function SentryGunBase:Switch_Mode()
	self._switch_mode_dt = 1
	self._switch_mode = self._switch_mode + 1
	if self._switch_mode > 1 then
		self._switch_mode = 0
	end
	managers.hud:show_hint({
		text = managers.localization:to_upper_text("switch_sentry_mode_"..self._switch_mode),
		event = Idstring("SentryGunBase:Switch_Mode()"):key(),
		time = 3
	})
end

function SentryGunBase.Try_Switch_Mode()
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
	for u_key, s_unit in pairs(SentryGunModeFUN.Record) do
		if s_unit and alive(s_unit) then
			local s_pos = s_unit:position()
			local vec = s_pos - ply_unit:position()
			local dis = mvector3.normalize(vec)
			local max_angle = math.max(8, math.lerp(10, 30, dis / 1200))
			local angle = vec:angle(cam_fwd)					
			if angle < max_angle or math.abs(max_angle-angle) < 10 then
				s_unit:base():Switch_Mode()
				
				local cmd = "cmd_gogo"
				local voc = "g18"
				if s_unit:base()._switch_mode == 0 then
					cmd = "cmd_gogo"
					voc = "g18"
				elseif s_unit:base()._switch_mode == 1 then
					cmd = "cmd_stop"
					voc = "f48x_any"
				end
				PlyStandard:_do_action_intimidate(TimerManager:game():time(), cmd, voc, true)
			end
		else
			SentryGunModeFUN.Record[u_key] = nil
		end
	end
end