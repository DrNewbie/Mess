Hooks:PostHook(PlayerManager, "init", "F_"..Idstring("PlayerManager:init:BB"):key(), function(self)
	self._BB = 0
end)

function PlayerManager:Show_BB()
	if managers.hud and self:get_current_state() then
		local equipped_unit = self:get_current_state()._equipped_unit
		if equipped_unit and alive(equipped_unit) and equipped_unit:base()._is_beggars_bazooka then
			local _ammo_max_per_clip, _ammo_remaining_in_clip, _remaining_full_clips, _ammo_max = equipped_unit:base():ammo_info()
			managers.hud:set_ammo_amount(equipped_unit:base():selection_index(), _ammo_max_per_clip, self._BB, _remaining_full_clips, _ammo_max)
		end
	end
end

function PlayerManager:Set_BB(vvar)
	self._BB = vvar
	self:Show_BB()
end

function PlayerManager:Get_BB(vvar)
	return self._BB
end

function PlayerManager:Add_BB(vvar)
	self._BB = self._BB + vvar
	self:Show_BB()
end

function PlayerManager:Sub_BB(vvar)
	self._BB = self._BB - vvar
	self:Show_BB()
end