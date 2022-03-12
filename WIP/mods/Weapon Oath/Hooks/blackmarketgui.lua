local ThisModPath = ModPath or tostring(math.random())
local ThisModIds = Idstring(ThisModPath):key()
local __Name = function(__id)
	return "WOATH_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end
local Hook1 = __Name("_setup::")
local Hook2 = __Name("show_stats::")
local Hook3 = __Name("_update_borders::")
local Hook4 = __Name("destroy::")
local BarPanel = __Name("BarPanel::")
local BarPaneBoxl = __Name("BarPaneBoxl::")
local BarLine = __Name("BarLine::")
local BarLineBackground = __Name("BarLineBackground::")
local BarText = __Name("BarText::")
local BarRateText = __Name("BarRateText::")
local Bar_x_offset = 10
local Bar100 = __Name("Bar100::")
local OATH_COLOR = Color(241/255, 174/255, 165/255)
local OATH_TEXT_SIZE = 20

local function HIDE_OATH_BAR(them)
	if them[BarPaneBoxl] then
		them[BarPaneBoxl]:set_visible(false)
	end
	if them[BarLineBackground] then
		them[BarLineBackground]:set_visible(false)
	end
	if them[BarText] then
		them[BarText]:set_visible(false)
	end
	if them[BarRateText] then
		them[BarRateText]:set_visible(false)
	end
	if them[BarLine] then
		them[BarLine]:set_visible(false)
	end
end

local function SET_OATH_PERCENT(them, __rate)
	if type(them[Bar100]) == "number" then
		if them[BarPaneBoxl] then
			them[BarPaneBoxl]:set_visible(true)	
		end
		if them[BarRateText] then
			them[BarRateText]:set_visible(true)
		end
		if them[BarLine] then
			them[BarLine]:set_visible(true)
			them[BarLine]:set_w(0)
			local function animate_loading(o)
				over(1, function (p)
					if p < __rate then
						o:set_w(them[Bar100] * p)
						them[BarRateText]:set_text(''..math.round(p*100)..' / 100')
					else
						__rate = math.min(__rate, 1)
						o:set_w(them[Bar100] * __rate)						
						them[BarRateText]:set_text(''..math.round(__rate*100)..' / 100')
					end
				end)
			end
			them[BarLine]:animate(animate_loading)
		end
		if them[BarLineBackground] then
			them[BarLineBackground]:set_visible(true)
		end
		if them[BarText] then
			them[BarText]:set_visible(true)
		end
	end
end

local function Get_Slot_Data(them)
	local now_slot_data = them._slot_data
	local __allow_category = {
		["primaries"] = true,
		["secondaries"] = true
	}
	if now_slot_data.category and __allow_category[now_slot_data.category] and Global.blackmarket_manager.crafted_items[now_slot_data.category] then
		return Global.blackmarket_manager.crafted_items[now_slot_data.category][now_slot_data.slot]
	end
	return
end

local function GOTO_OATH_LINK(them, is_click)
	local now_slot_data = Get_Slot_Data(them)
	if now_slot_data and them[BarLine] then
		local weapon_tweak_data = tweak_data.weapon[now_slot_data.weapon_id]
		if weapon_tweak_data and type(weapon_tweak_data.__oath_data) == "table" then
			if type(weapon_tweak_data.__oath_data.__oath_link) == "function" then
				local __rate = math.min(them[BarLine]:w()/them[Bar100], 1)
				__rate = __rate * 100
				weapon_tweak_data.__oath_data.__oath_link(is_click, __rate)
			end
		end
		return true
	end
	return false
end

local function UPDATE_OATH_STATS(them)
	HIDE_OATH_BAR(them)	
	if not them._slot_data or not them._weapon_info_panel or not them._panel then

	else
		local now_slot_data = Get_Slot_Data(them)
		if type(now_slot_data) == "table" and type(now_slot_data.__oath_now) == "number" and type(now_slot_data.__oath_req) == "number" and now_slot_data.__oath_now >= 0 and now_slot_data.__oath_req > 0 then
			SET_OATH_PERCENT(them, now_slot_data.__oath_now/now_slot_data.__oath_req)
		else
			SET_OATH_PERCENT(them, 0)
		end
	end
end

Hooks:PostHook(BlackMarketGui, "_setup", Hook1, function(self)
	if not self._weapon_info_panel or type(self._weapon_info_panel.x) ~= "function" or not self._panel then

	else
		self[BarPanel] = self[BarPanel] or self._panel:panel({
			x = self._weapon_info_panel:x(),
			y = self._weapon_info_panel:y() - 10 - tweak_data.menu.pd2_large_font_size,
			w = self._weapon_info_panel:w(),
			h = tweak_data.menu.pd2_large_font_size,
			visible = true
		})
		--
		self[BarPaneBoxl] = BoxGuiObject:new(self[BarPanel], {
			sides = {1, 1, 1, 1}
		})
		self[BarPaneBoxl]:set_visible(false)
		--
		self[Bar100] = self[BarPanel]:w() * 0.90
		--
		self[BarLine] = self._panel:rect({
			visible = true,
			vertical = "center",
			h = 6,
			align = "center",
			halign = "center",
			w = self[Bar100],
			color = OATH_COLOR,
			layer = 200,
			visible = false
		})
		self[BarLine]:set_center(self[BarPanel]:center_x(), self[BarPanel]:center_y() + 10)
		self[BarLine]:set_left(self[BarPanel]:x() + Bar_x_offset)
		--
		self[BarLineBackground] = self._panel:rect({
			visible = true,
			vertical = "center",
			h = 12,
			align = "center",
			halign = "center",
			w = self[Bar100] + 3,
			color = Color.black,
			layer = 199,
			visible = false
		})
		self[BarLineBackground]:set_center(self[BarPanel]:center_x(), self[BarPanel]:center_y() + 10)
		self[BarLineBackground]:set_left(self[BarPanel]:x() + Bar_x_offset - 3)
		--
		self[BarText] = self._panel:text({
			h = OATH_TEXT_SIZE,
			w = self[Bar100],
			font = tweak_data.menu.pd2_small_font,
			font_size = OATH_TEXT_SIZE,
			color = OATH_COLOR,
			layer = 198,
			text = "OATH",
			visible = false
		})
		self[BarText]:set_center(self[BarPanel]:center_x(), self[BarPanel]:center_y() - 8)
		self[BarText]:set_left(self[BarPanel]:x() + Bar_x_offset)
		--
		self[BarRateText] = self._panel:text({
			h = OATH_TEXT_SIZE,
			w = self[Bar100],
			font = tweak_data.menu.pd2_small_font,
			font_size = OATH_TEXT_SIZE,
			color = Color.white,
			layer = 197,
			text = "",
			visible = false
		})
		self[BarRateText]:set_center(self[BarPanel]:center_x(), self[BarPanel]:center_y() - 8)
		self[BarRateText]:set_left(self[BarPanel]:x() + 48)
	end
end)

Hooks:PostHook(BlackMarketGui, "show_stats", Hook2, function(self)
	UPDATE_OATH_STATS(self)
end)

Hooks:PostHook(BlackMarketGui, "_update_borders", Hook3, function(self)
	UPDATE_OATH_STATS(self)
end)

Hooks:PostHook(BlackMarketGui, "destroy", Hook4, function(self)
	if self[BarLine] then
		self[BarLine] = nil
	end
	if self[BarLineBackground] then
		self[BarLineBackground] = nil
	end
	if self[BarText] then
		self[BarText] = nil
	end
	if self[BarRateText] then
		self[BarRateText] = nil
	end
	if self[BarPaneBoxl] then
		self[BarPaneBoxl] = nil
	end
	if self[BarPanel] then
		self[BarPanel] = nil
	end
end)

local Is_Inside1 = BlackMarketGui.mouse_pressed
local Is_Inside2 = BlackMarketGui.mouse_moved

function BlackMarketGui:mouse_pressed(button, x, y, ...)
	local Ans = Is_Inside1(self, button, x, y, ...)
	if not Ans and button == Idstring("0") and self[BarPaneBoxl]:inside(x, y) then
		return GOTO_OATH_LINK(self, true)
	end
	return Ans
end

function BlackMarketGui:mouse_moved(o, x, y, ...)
	local Ans = Is_Inside2(self, o, x, y, ...)
	if not Ans and self[BarPaneBoxl]:inside(x, y) then
		if GOTO_OATH_LINK(self, false) then
			return true, "link"
		end
	end
	return Ans
end