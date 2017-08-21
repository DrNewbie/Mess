_G.EXPRewardLater = _G.EXPRewardLater or {}
EXPRewardLater.options_menu = "EXPRewardLater_menu"
EXPRewardLater.ModPath = ModPath
EXPRewardLater.Save_file = EXPRewardLater.Save_file or SavePath .. "EXPRewardLater.txt"
EXPRewardLater.settings = EXPRewardLater.settings or {}
EXPRewardLater.settings = {
	SaveThisTime = 0,
	XP_Saved = 0,
	Total_Saved = 0
}

function EXPRewardLater:Reset()
	self.settings = {
		SaveThisTime = 0,
		XP_Saved = 0,
		Total_Saved = 0
	}
	self:Save()
end

function EXPRewardLater:Load()
	local _file = io.open(self.Save_file, "r")
	if _file then
		for key, value in pairs(json.decode(_file:read("*all"))) do
			self.settings[key] = value
		end
		_file:close()
	else
		self:Reset()
	end
end

function EXPRewardLater:Save()
	local _file = io.open(self.Save_file, "w+")
	if _file then
		_file:write(json.encode(self.settings))
		_file:close()
	end
end

function EXPRewardLater:Announce()
	if self.settings.SaveThisTime == 1 then
		QuickMenu:new(
			"Reward Later",
			"Function is [ ON ]\nYour Reward will be hold.",
			{{"Ok", is_cancel_button = true}},
			true
		):Show()
	else
		QuickMenu:new(
			"Reward Later",
			"Function is [ OFF ]\nYour will gain Reward.",
			{{"Ok", is_cancel_button = true}},
			true
		):Show()
	end
end

EXPRewardLater:Load()