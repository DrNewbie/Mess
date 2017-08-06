local UnnecessaryExplosion = {}

UnnecessaryExplosion.Timer_On = false

function UnnecessaryExplosion:_Main_Timer()
	if UnnecessaryExplosion.Timer_On and isPlaying() then
		local _r = math.random(1, 3)
		for i = 1, _r do
			UnnecessaryExplosion:Boom()
		end
		DelayedCalls:Add( "DelayedCalls_UnnecessaryExplosion_Timer_Main", 0.5, function()
			UnnecessaryExplosion:_Main_Timer()
		end )
	end
end

function UnnecessaryExplosion:Boom()
	if not UnnecessaryExplosion.Timer_On or not isPlaying() then
		return
	end
	local _pos = {}
	local z_offsett = {100, 100, 300, 400, 200, 500}
	for _, data in pairs(managers.groupai:state():all_player_criminals() or {}) do
		table.insert(_pos, data.unit:position())
	end
	if not _pos or not _pos[1] then
		return
	end
	local pos = _pos[math.random(#_pos)]
	pos = pos + Vector3(math.random(-800,800), math.random(-800,800), z_offsett[math.random(#z_offsett)])
	local custom_params = {sound_event = "rpg_explode",
		effect = "effects/payday2/particles/explosions/grenade_explosion",
		feedback_range = 1000,
		sound_muffle_effect = true,
		camera_shake_max_mul = 4
	}
	if managers and managers.explosion then
		managers.explosion:play_sound_and_effects(pos, Vector3(0, 0, 1), 1000, custom_params)
	end
	return
end

local _f_CopMovement_set_position = CopMovement.set_position
function CopMovement:set_position(...)
	if not UnnecessaryExplosion.Timer_On and isPlaying() then
		UnnecessaryExplosion.Timer_On = true
		DelayedCalls:Add( "DelayedCalls_UnnecessaryExplosion_Timer_Main", 1, function()
			UnnecessaryExplosion:_Main_Timer()
		end )
	end
	_f_CopMovement_set_position(self, ...)
end

function isPlaying()
	if not BaseNetworkHandler then return false end
	return BaseNetworkHandler._gamestate_filter.any_ingame_playing[ game_state_machine:last_queued_state_name() ]
end