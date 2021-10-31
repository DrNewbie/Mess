require("lib/managers/menu/NewHeistsGui")

NewHeistsGuiInGameAD = NewHeistsGuiInGameAD or class(NewHeistsGui)

local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()

local Hook1 = "F_"..Idstring("Hook1::"..ThisModIds):key()
local Hook2 = "F_"..Idstring("Hook2::"..ThisModIds):key()
local Bool1 = "F_"..Idstring("get_assault_mode::"..ThisModIds):key()
local Func1 = "F_"..Idstring("create_new_heists_gui::"..ThisModIds):key()
local Func2 = "F_"..Idstring("close_new_heists_gui::"..ThisModIds):key()

local is_IGAdsB = type(IGAdsB) == "table" and type(IGAdsB.Options) == "table" and type(IGAdsB.Options.GetValue) == "function"

function NewHeistsGuiInGameAD:try_get_dummy()

end

function NewHeistsGuiInGameAD:mouse_pressed(button, x, y)

end

function NewHeistsGuiInGameAD:mouse_moved(button, x, y)

end

local TIME_PER_PAGE = 12
local BAR_W = 32

function NewHeistsGuiInGameAD:update(t, dt)
	if self._page_count <= 1 then
		return
	end
	self._next_time = self._next_time or t + TIME_PER_PAGE
	if self._block_change then
		self._next_time = t + TIME_PER_PAGE
	else
		if self._next_time <= t then
			self:_next_page()
			self._next_time = t + TIME_PER_PAGE
		end
		self:set_bar_width(BAR_W * (1 - (self._next_time - t) / TIME_PER_PAGE))
	end
	if not animating and self._queued_page then
		self:_move_to_page(self._queued_page)
		self._queued_page = nil
	end
end

Hooks:PostHook(HUDManager, "_player_hud_layout", Hook1, function(self)
	self[Bool1] = false
end)

HUDManager[Func1] = function(self)
	local __fullscreen_ws = self._fullscreen_ws or managers.gui_data:create_fullscreen_16_9_workspace()
	local __ws = self._ws or managers.gui_data:create_fullscreen_workspace()
	if NewHeistsGuiInGameAD and __ws and __fullscreen_ws then
		self.__new_heists_gui_ad = self.__new_heists_gui_ad or NewHeistsGuiInGameAD:new(__ws, __fullscreen_ws)
		if is_IGAdsB then
			IGAdsB.AdsGui = self.__new_heists_gui_ad
			IGAdsB:OptChanged()
		end
	end
end

HUDManager[Func2] = function(self)
	if self.__new_heists_gui_ad then
		self.__new_heists_gui_ad:close()
		self.__new_heists_gui_ad = nil
		if is_IGAdsB then
			IGAdsB.AdsGui = nil
		end
	end
end

Hooks:PostHook(HUDManager, "update", Hook2, function(self, t, dt)
	if type(self[Bool1]) ~= type(managers.groupai:state():get_assault_mode()) or 
		self[Bool1] ~= managers.groupai:state():get_assault_mode() then
		
		self[Bool1] = managers.groupai:state():get_assault_mode()
		if self[Bool1] then
			self[Func1](self)
		else
			self[Func2](self)
		end
	else
		if self.__new_heists_gui_ad and type(self.__new_heists_gui_ad.update) == "function" then
			self.__new_heists_gui_ad:update(t, dt)
		end
	end
end)