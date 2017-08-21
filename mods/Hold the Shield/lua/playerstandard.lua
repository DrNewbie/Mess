local _hts_PlayerStandard_init = PlayerStandard.init

function PlayerStandard:init(...)
	_hts_PlayerStandard_init(self, ...)
	self._melee_hts_t = 0
end

local _hts_PlayerStandard_check_action_melee = PlayerStandard._check_action_melee

function PlayerStandard:_check_action_melee(t, input)
	if not self._unit:inventory():is_this_able_to_shield() then
		return
	end
	local _btn_melee_release = input.btn_melee_release
	local _btn_melee_press = input.btn_melee_press
	if _btn_melee_press then
		self._unit:inventory():hide_shield()
		self._melee_hts_t = 0
	end
	if _btn_melee_release and self._melee_hts_t == 0 then
		self._melee_hts_t = t + 1
	end
	_hts_PlayerStandard_check_action_melee(self, t, input)
end

local _hts_PlayerStandard_update = PlayerStandard.update

function PlayerStandard:update(t, dt)
	_hts_PlayerStandard_update(self, t, dt)
	if not self._unit:inventory():is_this_able_to_shield() then
		return
	end
	if self._melee_hts_t > 0 and t > self._melee_hts_t then
		self._melee_hts_t = 0
		self._unit:inventory():give_shield()
	end
end