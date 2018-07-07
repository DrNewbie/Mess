_G.JokerMask = _G.JokerMask or {}
JokerMask.ModPath = ModPath
JokerMask.Mask = JokerMask.Mask or {Nope = "Nope"}

function JokerMask:Load()
	local save_files = io.open(self.ModPath.."/Masks.json", "r")
	if save_files then
		self.Mask = json.decode(save_files:read("*all"))
		save_files:close()
		JokerMask.Mask.Nope = nil
	else
		self.Mask = self.Mask or {Nope = "Nope"}
		self:Save()
	end
end

function JokerMask:Save()
	local save_files = io.open(self.ModPath.."/Masks.json", "w+")
	if save_files then
		save_files:write(json.encode(self.Mask))
		save_files:close()
	end
	self:Load()
end

Hooks:Add("LocalizationManagerPostInit", "JokerMask_Loc", function(loc)
	LocalizationManager:add_localized_strings({
		["JokerMask_apply2jokermask"] = "Apply to Joker",
		["JokerMask_remove4jokermask"] = "Remove from Joker"
	})
end)

Hooks:PostHook(BlackMarketGui, "_setup", "JokerMask_SetMask", function(self)
	self.JokerMask_apply2jokermask_callback = function(self, data)
		if data and data.slot then
			local crafted = Global.blackmarket_manager.crafted_items.masks[data.slot]
			if not crafted then
				return
			end
			JokerMask.Mask["slot: "..data.slot] = {mask_id = crafted.mask_id, blueprint = crafted.blueprint}
			JokerMask:Save()
			managers.system_menu:show({
				title = "[Joker Masks]",
				text = managers.localization:text("JokerMask_apply2jokermask"),
				button_list = {{text = "END", is_cancel_button = true}},
				id = tostring(math.random(0,0xFFFFFFFF))
			})
		end
	end
	self.JokerMask_remove4jokermask_callback = function(self, data)
		if data and data.slot and JokerMask.Mask["slot: "..data.slot] then
			JokerMask.Mask["slot: "..data.slot] = nil
			JokerMask:Save()
			managers.system_menu:show({
				title = "[Joker Masks]",
				text = managers.localization:text("JokerMask_remove4jokermask"),
				button_list = {{text = "END", is_cancel_button = true}},
				id = tostring(math.random(0,0xFFFFFFFF))
			})
		end
	end
	local m_mask2joker = {
		prio = 999,
		btn = "BTN_A",
		pc_btn = nil,
		name = "JokerMask_apply2jokermask",
		callback = callback(self, self, "JokerMask_apply2jokermask_callback")
	}
	local m_mask3joker = {
		prio = 999,
		btn = "BTN_A",
		pc_btn = nil,
		name = "JokerMask_remove4jokermask",
		callback = callback(self, self, "JokerMask_remove4jokermask_callback")
	}
	self._btns["m_mask2joker"] = BlackMarketGuiButtonItem:new(self._buttons, m_mask2joker, 10)
	self._btns["m_mask3joker"] = BlackMarketGuiButtonItem:new(self._buttons, m_mask3joker, 10)
end)


Hooks:PostHook(BlackMarketGui, "populate_masks_new", "JokerMask_populate_masks_new", function(self, data)
	for i, datas in pairs(data) do
		if data[i] and type(datas) == "table" and datas.unlocked then
			for ii, i_datas in pairs(datas) do
				if type(ii) == "number" and type(i_datas) == "string" and i_datas == "m_preview" then
					table.insert(data[i], "m_mask2joker")
					table.insert(data[i], "m_mask3joker")
					break
				end
			end
		end
	end
end)

JokerMask:Load()