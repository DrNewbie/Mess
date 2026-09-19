_G.FakeOpenSafeF = _G.FakeOpenSafeF or {}

local _old_create_raffle_panel = MenuNodeEconomySafe._create_raffle_panel

Hooks:PreHook(MenuNodeEconomySafe, "init", "FakeOpenSafeFMenuNodeInit", function(self, node)
	if FakeOpenSafeF._MenuNodeEconomySafe_Ready then
		node:parameters().safe_entry = "fake_safe_1"
	end
end)

Hooks:PostHook(MenuNodeEconomySafe, "_build_result_panel", "FakeOpenSafeFMenuNodeChangeAnsText", function(self)
	if FakeOpenSafeF._MenuNodeEconomySafe_Ready then
		local _data = FakeOpenSafeF:Get_Ans_Data()
		if _data and _data.name_id then
			if self._result_panel:child("name") then
				self._result_panel:child("name"):set_text(managers.localization:text(_data.name_id))
			end
			if self._result_panel:child("bonus") then
			self._result_panel:child("bonus"):set_visible(false)
			end
			if self._result_panel:child("bonus_text") then
			self._result_panel:child("bonus_text"):set_visible(false)
			end
		end
		FakeOpenSafeF._MenuNodeEconomySafe_Ready = nil
	end
end)

Hooks:PostHook(MenuNodeEconomySafe, "_replace_raffle_panel_at", "FakeOpenSafeFMenuNodeEnd", function(self, x, data, index)
	if FakeOpenSafeF._MenuNodeEconomySafe_Ready then
		if not data.ans_replace then
			data.ans_replace = true
			self:_replace_raffle_panel_at(x, data, index)
		end
	end
end)

function MenuNodeEconomySafe:_create_raffle_panel(x, data, index, ...)
	if not FakeOpenSafeF._MenuNodeEconomySafe_Ready then
		return _old_create_raffle_panel(self, x, data, index, ...)
	end
	local p = self._raffle_panel:panel({h = 108, y = 24, x = x, w = self._raffle_panel_width})
	local image_panel = p:panel({x = 0, y = 0, w = p:w(), h = p:h() - 24})
	image_panel:bitmap({texture = "guis/dlcs/cash/textures/pd2/safe_raffle/bg_black", name = "bg_black", layer = -1, w = image_panel:w(), h = image_panel:h()})
	index = index or #self._raffle_panels + 1
	table.insert(self._raffle_panels, index, p)

	local texture_name = "guis/fake_safe_1/loot_cards_cash"
	local name_id = "bm_none"
	local rarity_color = Color.white
	local texture_rarity_name = "guis/dlcs/cash/textures/pd2/safe_raffle/header_col_common"
	local bonuses = nil
	
	local _data = FakeOpenSafeF._RewardFunction_Ready.All_Safe_Addon_Data
	
	if _data and _data.addon_safe_ans then
		local _rnd_data_key = table.random_key(_data.addon_safe_ans)
		if data.ans_replace then
			_rnd_data_key = FakeOpenSafeF._RewardFunction_Ready.Ans_Data_Key
		end
		local _new_data = _data.addon_safe_ans[_rnd_data_key]
		if _new_data then
			name_id = _new_data.name_id or name_id
			texture_name = _new_data.texture or texture_name
		end
	end
	
	local name = managers.localization:text(name_id)

	p:text({halign = "left", vertical = "top", name = "number", align = "center", visible = false, layer = 10, text = "" .. index, font_size = self.font_size, font = self.font})
	p:bitmap({name = "", h = 24, texture = texture_rarity_name, y = p:h() - 24, w = p:w()})
	p:text({halign = "left", vertical = "center", h = 24, name = "name", font_size = 20, align = "left", x = 8, layer = 10, text = name, y = p:h() - 24, font = self.font})

	if bonuses then
		local x = p:w() - 4
		for _, texture_path in ipairs(bonuses) do
			local bonus_bitmap = p:bitmap({
				name = "bonus",
				h = 16,
				w = 16,
				layer = 1,
				texture = texture_path,
				x = p:w() - 24,
				y = p:h() - 24
			})
			bonus_bitmap:set_right(x)
			bonus_bitmap:set_center_y(p:h() - 12)
			x = bonus_bitmap:left() - 1
		end
	end

	self:request_texture(texture_name, image_panel, true)
end