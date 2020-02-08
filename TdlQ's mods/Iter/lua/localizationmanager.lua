DelayedCalls:Add('DelayedMod_LocalizationManager_recur_text', 0, function()
	local itr_localizationmanager_text = LocalizationManager.text
	function LocalizationManager:text(str, macros)
		local result = itr_localizationmanager_text(self, str, macros)

		if self._custom_localizations[str] then
			local ms = {}
			for m in result:gmatch('%$([%w_-]+)') do
				if self._custom_localizations[m] or Localizer:exists(Idstring(m)) then
					table.insert(ms, m)
				end
			end

			table.sort(ms, function(a, b)
				return a:len() > b:len()
			end)

			for _, m in ipairs(ms) do
				result = result:gsub('$' .. m, self:text(m))
			end
		end

		return result
	end
end)
