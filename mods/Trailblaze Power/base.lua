local ThisModPath = ModPath or tostring(math.random())
local ThisModIds = Idstring(ThisModPath):key()
local __Name = function(__id)
	return "HSR_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end

local BarPanel = __Name("BarPanel::")
local BarPaneBoxl = __Name("BarPaneBoxl::")
local BarLine = __Name("BarLine::")
local BarLineBackground = __Name("BarLineBackground::")
local BarText = __Name("BarText::")
local BarRateText = __Name("BarRateText::")
local Bar_x_offset = 10
local Bar100 = __Name("Bar100::")
local LOGOICONBOX = __Name("LOGOICONBOX::")
local LOGOICONPANEL = __Name("LOGOICONPANEL::")
local TBPOWER_COLOR = Color(241/255, 174/255, 165/255)
local TBPOWER_TEXT_SIZE = 20
local TBPOWER_NUMBER_NAME = __Name("TBPOWER_NUMBER")
local TBPOWER_NUMBER_NEXT_RECOVER_NAME = __Name("TBPOWER_NUMBER_NEXT_RECOVER")

local TBPOWER_RUN_OUT_MESSAGE = false

local TBPOWER_MAX_NUMBER = 360

local TBPOWER_NEXT_RECOVER_TIME = 6 * 60

local TBPOWER_CONSUME_NUMBER = 60

_G[TBPOWER_NUMBER_NAME] = _G[TBPOWER_NUMBER_NAME] or 0
_G[TBPOWER_NUMBER_NEXT_RECOVER_NAME] = _G[TBPOWER_NUMBER_NEXT_RECOVER_NAME] or 0

local function __Save()
	pcall(function()
		io.save_as_json({
			TBPOWER_NUMBER = _G[TBPOWER_NUMBER_NAME],
			TBPOWER_NUMBER_NEXT_RECOVER = _G[TBPOWER_NUMBER_NEXT_RECOVER_NAME]
		}, ThisModPath.."__savefile.txt")
	end)
end

local function __Load()
	pcall(function()
		local __data = io.load_as_json(ThisModPath.."__savefile.txt")
		if type(__data) == "table" then
			if type(__data.TBPOWER_NUMBER) == "number" then
				_G[TBPOWER_NUMBER_NAME] = math.min(__data.TBPOWER_NUMBER, TBPOWER_MAX_NUMBER)
			end
			if type(__data.TBPOWER_NUMBER_NEXT_RECOVER) == "number" then
				_G[TBPOWER_NUMBER_NEXT_RECOVER_NAME] = __data.TBPOWER_NUMBER_NEXT_RECOVER
			end
		else
			_G[TBPOWER_NUMBER_NAME] = TBPOWER_MAX_NUMBER
			_G[TBPOWER_NUMBER_NEXT_RECOVER_NAME] = os.time()
		end
	end)
	__Save()
end

__Load()

local function __Is_Not_Init(__ClassFunc, __RequiredScript)
	if __ClassFunc and not _G[__Name(__RequiredScript)] then
		_G[__Name(__RequiredScript)] = true
		return true
	end
	return false
end

local function HIDE_TBPOWER_BAR(them)
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
	if them[LOGOICONPANEL] then
		them[LOGOICONPANEL]:set_visible(false)
	end
	return
end

local function SET_TBPOWER_PERCENT(them, __var, __rate)
	if type(them[Bar100]) == "number" then
		if them[BarPaneBoxl] then
			them[BarPaneBoxl]:set_visible(true)	
		end
		if them[BarRateText] then
			them[BarRateText]:set_visible(true)
		end
		if them[LOGOICONPANEL] then
			them[LOGOICONPANEL]:set_visible(true)
		end
		if them[BarLine] then
			them[BarLine]:set_visible(true)
			them[BarLine]:set_w(0)
			local function animate_loading(o)
				over(1, function (p)
					if p < __rate then
						o:set_w(them[Bar100] * p)
						them[BarRateText]:set_text(''..math.round(__var)..' / '..math.round(TBPOWER_MAX_NUMBER)..'')
					else
						__rate = math.min(__rate, 1)
						o:set_w(them[Bar100] * __rate)						
						them[BarRateText]:set_text(''..math.round(__var)..' / '..math.round(TBPOWER_MAX_NUMBER)..'')
					end
					if __var < TBPOWER_CONSUME_NUMBER then
						them[BarRateText]:set_color(Color.red)
					else
						them[BarRateText]:set_color(Color.white)
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
	return
end

local function Set_TBPOWER(them, __var)
	if type(__var) ~= "number" then
		__var = 0
	end
	if type(_G[TBPOWER_NUMBER_NAME]) ~= "number" then
		_G[TBPOWER_NUMBER_NAME] = TBPOWER_MAX_NUMBER
	end
	_G[TBPOWER_NUMBER_NAME] = __var
	__Save()
	return
end

local function Get_TBPOWER(them)
	if type(_G[TBPOWER_NUMBER_NAME]) ~= "number" then
		_G[TBPOWER_NUMBER_NAME] = TBPOWER_MAX_NUMBER
	end
	return _G[TBPOWER_NUMBER_NAME]
end

local function Get_TBPOWER_FIXED(them)
	if type(_G[TBPOWER_NUMBER_NAME]) ~= "number" then
		_G[TBPOWER_NUMBER_NAME] = 0
	end
	_G[TBPOWER_NUMBER_NAME] = math.clamp(_G[TBPOWER_NUMBER_NAME], 0, TBPOWER_MAX_NUMBER)
	return _G[TBPOWER_NUMBER_NAME]
end

local function Increase_TBPOWER(them, __var)
	if type(__var) ~= "number" then
		return
	end
	Set_TBPOWER(them, Get_TBPOWER(them) + __var)
	return
end

local function Get_TBPOWER_RATIO(them)
	local __TBPOWER_NUMBER = Get_TBPOWER_FIXED(them)
	return __TBPOWER_NUMBER / TBPOWER_MAX_NUMBER
end

local function UPDATE_TBPOWER_STATS(them)
	HIDE_TBPOWER_BAR(them)	
	local __TBPOWER_NUMBER = Get_TBPOWER_FIXED(them)
	local __TBPOWER_NUMBER_RATIO = Get_TBPOWER_RATIO(them)
	SET_TBPOWER_PERCENT(them, __TBPOWER_NUMBER, __TBPOWER_NUMBER_RATIO)
	return
end

if __Is_Not_Init(PlayerInventoryGui, RequiredScript) then
	require("lib/managers/menu/WalletGuiObject")
	require("lib/utils/InventoryDescription")

	Hooks:PostHook(PlayerInventoryGui, "init", __Name("_setup::"), function(self)
		if not self._panel then

		else
			self[BarPanel] = self[BarPanel] or self._panel:panel({
				x = self._panel:w() * 0.40,
				y = self._panel:h() * 0.01,
				w = self._panel:w() * 0.20,
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
				color = TBPOWER_COLOR,
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
				w = self[Bar100] * 1.03,
				color = Color.black,
				layer = 199,
				visible = false
			})
			self[BarLineBackground]:set_center(self[BarPanel]:center_x(), self[BarPanel]:center_y() + 10)
			self[BarLineBackground]:set_left(self[BarPanel]:x() + Bar_x_offset - 3)
			--
			self[BarText] = self._panel:text({
				h = TBPOWER_TEXT_SIZE,
				w = self[Bar100],
				font = tweak_data.menu.pd2_small_font,
				font_size = TBPOWER_TEXT_SIZE,
				color = TBPOWER_COLOR,
				layer = 198,
				text = "Trailblaze Power",
				visible = false
			})
			self[BarText]:set_center(self[BarPanel]:center_x(), self[BarPanel]:center_y() - 8)
			self[BarText]:set_left(self[BarPanel]:x() + Bar_x_offset)
			--
			self[BarRateText] = self._panel:text({
				h = TBPOWER_TEXT_SIZE,
				w = self[Bar100],
				font = tweak_data.menu.pd2_small_font,
				font_size = TBPOWER_TEXT_SIZE,
				color = Color.white,
				layer = 197,
				text = "",
				visible = false
			})
			self[BarRateText]:set_center_y(self[BarText]:center_y())
			self[BarRateText]:set_left(self[BarText]:center_x() + 3)

			self[LOGOICONPANEL], self[LOGOICONBOX] = self:create_box({
				alpha = 1,
				name = LOGOICONBOX,
				bg_blend_mode = "normal",
				w = 64,
				h = 64,
				text = '',
				image = __Name("Item_Trailblaze_Power.dds"),
				visible = false
			})
			
			self[LOGOICONPANEL]:set_center_y(self[BarPanel]:center_y())
			self[LOGOICONPANEL]:set_right(self[BarPanel]:x())
		end
		
		UPDATE_TBPOWER_STATS(self)
	end)

	Hooks:PreHook(PlayerInventoryGui, "destroy", __Name("destroy::"), function(self)
		if self[BarLine] then
			pcall(function() self._panel:panel():remove(self[BarLine]) end)
			self[BarLine] = nil
		end
		if self[BarLineBackground] then
			pcall(function() self._panel:panel():remove(self[BarLineBackground]) end)
			self[BarLineBackground] = nil
		end
		if self[BarText] then
			pcall(function() self._panel:panel():remove(self[BarText]) end)
			self[BarText] = nil
		end
		if self[BarRateText] then
			pcall(function() self._panel:panel():remove(self[BarRateText]) end)
			self[BarRateText] = nil
		end
		if self[BarPaneBoxl] then
			self[BarPaneBoxl] = nil
		end
		if self[BarPanel] then
			pcall(function() self._panel:panel():remove(self[BarPanel]) end)
			self[BarPanel] = nil
		end
		if self[LOGOICONBOX] then
			self[LOGOICONBOX] = nil
		end
		if self[LOGOICONPANEL] then
			pcall(function() self._panel:panel():remove(self[LOGOICONPANEL]) end)
			self[LOGOICONPANEL] = nil
		end
	end)
end

if __Is_Not_Init(GameOverState, RequiredScript) then
	require("lib/states/GameState")
	Hooks:PostHook(GameOverState, "at_enter", __Name("GameOverState::at_enter"), function(...)
		Increase_TBPOWER(nil, -TBPOWER_CONSUME_NUMBER)
	end)
end

if __Is_Not_Init(VictoryState, RequiredScript) then
	require("lib/states/GameState")
	require("lib/utils/accelbyte/TelemetryConst")
	VictoryState = VictoryState or class(MissionEndState)
	Hooks:PostHook(VictoryState, "at_enter", __Name("VictoryState::at_enter"), function(...)
		Increase_TBPOWER(nil, -TBPOWER_CONSUME_NUMBER)
	end)
end

local __delay_check_dt = 0

local __delay_save_dt = 0

Hooks:Add("MenuUpdate", __Name("MenuUpdate::"), function(__t, __dt)
	if __delay_check_dt < 0 then
		__delay_check_dt = 2
		local __os_time = os.time()
		local __d_tbpower = (__os_time - _G[TBPOWER_NUMBER_NEXT_RECOVER_NAME])
		if __d_tbpower > TBPOWER_NEXT_RECOVER_TIME then
			_G[TBPOWER_NUMBER_NEXT_RECOVER_NAME] = __os_time + TBPOWER_NEXT_RECOVER_TIME
			Increase_TBPOWER(nil, math.round(__d_tbpower / TBPOWER_NEXT_RECOVER_TIME))
		end
	else
		__delay_check_dt = __delay_check_dt - __dt
	end
	if __delay_save_dt < 0 then
		__delay_save_dt = 6
		__Save()
	else
		__delay_save_dt = __delay_save_dt - __dt
	end
end)

local __delay_check_run_out_dt = 0

Hooks:Add("GameSetupUpdate", __Name("GameSetupUpdate::"), function(__t, __dt)
	if __delay_check_run_out_dt < 0 then
		__delay_check_run_out_dt = 2
		if Get_TBPOWER_FIXED() < TBPOWER_CONSUME_NUMBER and not Global.TBPOWER_RUN_OUT_MESSAGE then
			Global.TBPOWER_RUN_OUT_MESSAGE = true
			if Global.game_settings.single_player then
				MenuCallbackHandler:_dialog_end_game_yes()
			else
				setup:load_start_menu()
			end
		end
	else
		__delay_check_run_out_dt = __delay_check_run_out_dt - __dt
	end
end)

Hooks:Add("MenuManagerOnOpenMenu", __Name("MenuManagerOnOpenMenu::"), function(self, menu)
	if (menu == "menu_main" or menu == "lobby") and Global.TBPOWER_RUN_OUT_MESSAGE then
		DelayedCalls:Add(__Name("DelayedCalls::TBPOWER_RUN_OUT_MESSAGE"), 1, function()
			QuickMenu:new(
				"[System]",
				"You Run Out Of Trailblaze Power",
				{{text = "ok", is_cancel_button = true}},
				true
			)
		end)
	end
	Global.TBPOWER_RUN_OUT_MESSAGE = false
end)

pcall(function()
	BLTAssetManager:CreateEntry( 
		__Name("Item_Trailblaze_Power.dds"), 
		"texture", 
		ThisModPath.."Item_Trailblaze_Power.dds", 
		nil 
	)
end)