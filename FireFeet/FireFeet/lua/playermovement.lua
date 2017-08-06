local _f_PlayerMovement_update = PlayerMovement.update

local _last_t = 0
local _id = 0

function PlayerMovement:update(unit, t, dt)
	_f_PlayerMovement_update(self, unit, t, dt)
	if self._current_state_name == "standard" and self._m_pos and t > _last_t then
		_last_t = t + 0.2
		local params = {}
		params.effect = Idstring("effects/payday2/particles/explosions/molotov_grenade")
		params.position = self._m_pos
		params.rotation = Rotation(0, 0, 0)
		params.base_time = 15
		params.random_time = 3
		params.max_amount = 10
		_id = _id + 1
		if _id > 10 then
			_id = 1
		end
		local _idx = self._unit:id() .. "_" .._id
		managers.environment_effects:spawn_mission_effect(_idx, params)
	end
end