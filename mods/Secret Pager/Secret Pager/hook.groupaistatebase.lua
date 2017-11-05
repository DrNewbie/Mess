local MainPager_Civ_Req = 1
local MainPager_Cop_Req = 3
local MainPager_Record = {}
local MainPager_LastBool = -2

Hooks:PostHook(GroupAIStateBase, "update", "MainPager_update", function(self, t)
	if not self._whisper_mode or not Utils:IsInHeist() then
		return
	end
	if not self.MainPager then
		self.MainPager = {t = t + 10, bool = 0}
		return
	end
	if MainPager_LastBool ~= self.MainPager.bool then
		MainPager_LastBool = self.MainPager.bool
		if MainPager_LastBool == 1 then
			managers.chat:send_message(ChatManager.GAME, "", "[Secret Pager]: ON")
		else
			managers.chat:send_message(ChatManager.GAME, "", "[Secret Pager]: OFF")
		end
		if MainPager_LastBool ~= 1 and #MainPager_Record > 0 then
			for u_key, _ in pairs(MainPager_Record) do
				managers.enemy:all_enemies()[u_key].unit:unit_data().has_alarm_pager = true
			end
			MainPager_Record = {}
			return
		end
	end
	if self.MainPager.bool == -1 then
		return
	end
	if self.MainPager.t and t > self.MainPager.t and (not self.MainPager.Civ or not self.MainPager.Cop) then
		self.MainPager.t = t + 5
		local _all_enemies = managers.enemy:all_enemies() or {}
		local _all_civilians = managers.enemy:all_civilians() or {}
		local _all_enemies_unit = {}
		local _all_civilians_unit = {}
		local _all_enemies_size = 0
		local _all_civilians_size = 0
		for u_key, u_data in pairs(_all_civilians) do
			table.insert(_all_civilians_unit, u_data.unit)
			_all_civilians_size = _all_civilians_size + 1
		end
		for u_key, u_data in pairs(_all_enemies) do
			table.insert(_all_enemies_unit, u_data.unit)
			_all_enemies_size = _all_enemies_size + 1
		end
		if _all_enemies_size < MainPager_Cop_Req or _all_civilians_size < MainPager_Civ_Req then
			self.MainPager.bool = -1
			return
		end
		local _max = 100
		while _max > 0 do
			_max = _max - 1
			local pick = math.random(1, _all_civilians_size)
			self.MainPager.Civ = _all_civilians_unit[pick]
			if alive(self.MainPager.Civ) and not self.MainPager.Civ:character_damage():dead() then
				break
			end
			self.MainPager.Civ = nil
		end
		_max = 100
		while _max > 0 do
			_max = _max - 1
			local pick = math.random(1, _all_enemies_size)
			self.MainPager.Cop = _all_enemies_unit[pick]
			if alive(self.MainPager.Cop) and not self.MainPager.Cop:character_damage():dead() then
				break
			end
			self.MainPager.Cop = nil
		end
		if not self.MainPager.Civ or not alive(self.MainPager.Civ) or not self.MainPager.Cop or not alive(self.MainPager.Cop) then
			self.MainPager.bool = -1
			return
		end
	end
	if self.MainPager.t and t > self.MainPager.t and self.MainPager.Civ and self.MainPager.Cop then
		self.MainPager.t = t + 1
		if not alive(self.MainPager.Civ) or not alive(self.MainPager.Cop) then
			self.MainPager.bool = -1
			return
		end
		if self.MainPager.Civ:character_damage():dead() or self.MainPager.Cop:character_damage():dead() then
			self.MainPager.bool = -1
			return
		end
		if self.MainPager.Cop:brain():is_current_logic('intimidated') and self.MainPager.Civ:brain():is_current_logic('surrender') then
			self.MainPager.bool = 1
			MainPager_Record = {}
			for u_key, u_data in pairs(managers.enemy:all_enemies()) do
				if alive(u_data.unit) and u_data.unit:unit_data().has_alarm_pager then
					u_data.unit:unit_data().has_alarm_pager = nil
					MainPager_Record[u_key] = true
				end
			end
		else
			self.MainPager.bool = 0
		end
	end
end)