_G.BombThisLab = _G.BombThisLab or {}

local __mod_ids = Idstring("Cop Blow Up Meth Lab"):key()
local hook1 = "H_"..Idstring("hook1::"..__mod_ids):key()
local func1 = "F_"..Idstring("func1::"..__mod_ids):key()
local SOid1 = "S_"..Idstring("SOid1::"..__mod_ids):key()

BombThisLab.OkayToBomb = true

function BombThisLab:RunNowMain()
	if (Network and Network:is_server()) or Global.game_settings.single_player then
		if BombThisLab.OkayToBomb then
			for name, script in pairs(managers.mission:scripts()) do
				if script:element(101092) then
					script:element(101092):on_executed()
					BombThisLab.OkayToBomb = false
				end
			end
		end
	end
	return
end

function BombThisLab:RunNowFail()
	return
end

function BombThisLab:SO_verification(this_cop)
	if this_cop and alive(this_cop) and not this_cop:character_damage():dead() and not this_cop:brain()._logic_data.is_converted then
		return true
	end
	return
end

Hooks:PostHook(EnemyManager, "update", hook1, function(self, t, dt)
	if (Network and Network:is_server()) or Global.game_settings.single_player then
		if BombThisLab.OkayToBomb and Utils and Utils:IsInHeist() and (managers.job:current_level_id() == "rat" or managers.job:current_level_id() == "alex_1") then
			if not BombThisLab[func1] then
				BombThisLab[func1] = 5
				local __pick_pos = nil
				for _, v_unit in pairs(managers.interaction._interactive_units) do
					local __interaction = v_unit and v_unit:interaction()
					if __interaction and __interaction:active() and not __interaction:disabled() and (__interaction.tweak_data == "methlab_bubbling" or __interaction.tweak_data == "methlab_caustic_cooler" or __interaction.tweak_data == "methlab_gas_to_salt") then
						__pick_pos = __interaction:interact_position()
						break
					end
				end
				if __pick_pos then
					local objective = {
						type = "act",
						nav_seg = managers.navigation:get_nav_seg_from_pos(__pick_pos),
						search_pos = __pick_pos,
						pos = __pick_pos,
						scan = true,
						forced = true,
						action = {
							type = "act", variant = "e_so_container_kick", body_part = 1,
									blocks = {action = -1, walk = -1, hurt = -1, light_hurt = -1, heavy_hurt = -1, aim = -1},
									align_sync = true
								},
						action_duration = 3,
						complete_clbk = callback(BombThisLab, BombThisLab, "RunNowMain", {}),
						fail_clbk = callback(BombThisLab, BombThisLab, "RunNowFail", {})
					}
					local so_descriptor = {
						objective = objective,
						base_chance = 1,
						chance_inc = 0,
						interval = 10,
						search_dis_sq = 100000000,
						search_pos = __pick_pos,
						pos = __pick_pos,
						usage_amount = 10,
						AI_group = "enemies",
						verification_clbk = callback(BombThisLab, BombThisLab, "SO_verification")
					}				
					managers.groupai:state():remove_special_objective(SOid1)
					managers.groupai:state():add_special_objective(SOid1, so_descriptor)
				end
			else
				BombThisLab[func1] = BombThisLab[func1] - dt
				if BombThisLab[func1] <= 0 then
					BombThisLab[func1] = nil
				end
			end
		end
	end
end)