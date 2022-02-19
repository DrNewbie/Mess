_G.MessageSoundsEventt = _G.MessageSoundsEventt or {}
local List1 = _G.MessageSoundsEventt.NameIds("skill base event table")
local Hook1 = _G.MessageSoundsEventt.NameIds("PostHook::PlayerManager:update")
local Time1 = _G.MessageSoundsEventt.NameIds("PostHook::PlayerManager:update::dt")

Hooks:PostHook(PlayerManager, "update", Hook1, function(self, __t, __dt)
	if not self[Time1] then
		self[Time1] = 0.25
		for __category, _ in pairs(self._temporary_upgrades) do
			for __upgrade, _ in pairs(self._temporary_upgrades[__category]) do
				local __name_ids = _G.MessageSoundsEventt.NameIds("temporary_upgrades::"..__category.."::"..__upgrade)
				self[List1] = self[List1] or {}
				self[List1][__name_ids] = self[List1][__name_ids] or false
				if self[List1][__name_ids] ~= self:has_activate_temporary_upgrade(__category, __upgrade) then
					if self[List1][__name_ids] then --ON -> OFF
						self[List1][__name_ids] = false
						managers.player:send_message_now(Message.on_temporary_upgrades_end, nil, __category, __upgrade)
					else --OFF -> ON
						self[List1][__name_ids] = true
						managers.player:send_message_now(Message.on_temporary_upgrades_start, nil, __category, __upgrade)
					end
				end
			end
		end
	else
		self[Time1] = self[Time1] - __dt
		if self[Time1] <= 0 then
			self[Time1] = nil
		end
	end
end)

--managers.player:has_activate_temporary_upgrade