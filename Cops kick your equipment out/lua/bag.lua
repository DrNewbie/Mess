_G.StealYourItem = _G.StealYourItem or {}

function StealYourItem:LoopCheckMain(bag, t)
	if bag._empty then
		return false, false
	end
	if bag._StealYourItem._t > t then
		return
	end
	local _Tcop = bag._StealYourItem._target_unit
	if _Tcop and alive(_Tcop) and not _Tcop:character_damage():dead() and not _Tcop:brain()._logic_data.is_converted then
		StealYourItem:RunNowSet(bag)
		return
	else
		bag._StealYourItem._target_unit = nil
	end
	bag._StealYourItem._t = t + 3
	for u_key, u_data in pairs(managers.groupai:state():all_char_criminals()) do
		if u_data and u_data.unit and alive(u_data.unit) then
			if mvector3.distance(bag._unit:position(), u_data.unit:position()) < 1000 then
				return
			end
		end
	end
	for _, data in pairs(managers.enemy:all_enemies()) do
		local _cop = data.unit
		if mvector3.distance(bag._unit:position(), _cop:position()) < 2000 then
			bag._StealYourItem._target_unit = _cop
			break
		end
	end
end

function StealYourItem:RunNowMain(bag)
	if bag._empty then
		return
	end
	local _cop = bag._StealYourItem._target_unit
	if _cop and alive(_cop) and not _cop:character_damage():dead() and not _cop:brain()._logic_data.is_converted then
		if mvector3.distance(bag._unit:position(), _cop:position()) < 1000 then
			managers.network:session():send_to_peers_synched(bag._StealYourItem._target_run, bag._unit, 999)
			bag:_set_empty()
		end
	end
end

function StealYourItem:RunNowFail(bag)
	bag._StealYourItem._target_unit = nil
end

function StealYourItem:RunNowSet(bag)
	local _Tcop = bag._StealYourItem._target_unit
	local followup_objective = {
		type = "act",
		scan = true,
		action = {type = "act", body_part = 1, variant = "crouch", 
					blocks = {action = -1, walk = -1, hurt = -1, heavy_hurt = -1, aim = -1}
				}
		}
	local objective = {
		type = "e_so_container_kick",
		follow_unit = _Tcop,
		called = true,
		destroy_clbk_key = false,
		nav_seg = _Tcop:movement():nav_tracker():nav_segment(),
		pos = bag._unit:position(),
		scan = true,
		action = {
			type = "act", variant = "e_so_container_kick", body_part = 1,
					blocks = {action = -1, walk = -1, hurt = -1, light_hurt = -1, heavy_hurt = -1, aim = -1},
					align_sync = true
				},
			action_duration = 3,
			followup_objective = followup_objective,
			complete_clbk = callback(bag, bag, "RunNowMain", {}),
			fail_clbk = callback(bag, bag, "RunNowFail", {})
		}
	_Tcop:brain():set_objective(objective)
end

if RequiredScript == "lib/units/equipment/ammo_bag/ammobagbase" then
	Hooks:PostHook(AmmoBagBase, "init", "StealYourItem_AmmoBagBaseInit", function(self, ...)
		self._StealYourItem = {
			_t = 0,
			_try = 0,
			_target_unit = nil,
			_target_run = "sync_ammo_bag_ammo_taken"
		}
	end)
	
	Hooks:PostHook(AmmoBagBase, "update", "StealYourItem_AmmoBagBaseUpdate", function(self, unit, t, dt)
		StealYourItem:LoopCheckMain(self, t)
	end)
	
	function AmmoBagBase:RunNowMain()
		StealYourItem:RunNowMain(self)
	end
	
	function AmmoBagBase:RunNowFail()
		StealYourItem:RunNowFail(self)
	end
end

if RequiredScript == "lib/units/equipment/doctor_bag/doctorbagbase" then
	Hooks:PostHook(DoctorBagBase, "init", "StealYourItem_DoctorBagBaseInit", function(self, ...)
		self._StealYourItem = {
			_t = 0,
			_try = 0,
			_target_unit = nil,
			_target_run = "sync_ammo_bag_ammo_taken"
		}
	end)
	
	Hooks:PostHook(DoctorBagBase, "update", "StealYourItem_DoctorBagBaseUpdate", function(self, unit, t, dt)
		StealYourItem:LoopCheckMain(self, t)
	end)
	
	function DoctorBagBase:RunNowMain()
		StealYourItem:RunNowMain(self)
	end
	
	function DoctorBagBase:RunNowFail()
		StealYourItem:RunNowFail(self)
	end
end