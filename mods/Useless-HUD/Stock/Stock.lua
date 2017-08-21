_G.UselessHUD = _G.UselessHUD or {}
UselessHUD.Text = UselessHUD.Text or {}
Uselesshud_Stock = Uselesshud_Stock or class()
function Uselesshud_Stock:init(hud)
    self._full_hud = hud
    self._uselesshud_stock_panel = self._full_hud:panel({
		visible = true,
        name = "uselesshud_stock_panel",
        layer = 100,
        valign = "center", 
        halign = "center",
    })
    self._uselesshud_stock_text = self._uselesshud_stock_panel:text({
		visible = true,
        name = "uselesshud_stock_text",
        vertical = "center",
        align = "center",
        text = "0",
        font_size = 24,
        layer = 100,
        color = Color.black,
        font = "fonts/font_large_mf"
    })   
    self._uselesshud_stock_panel:rect({
		visible = true,
        name = "uselesshud_stock_bg",
        halign = "grow",
        valign = "grow",
        layer = 0,
        color = Color.black
    })     
    local x,y,w,h = self._uselesshud_stock_text:text_rect()
    self._uselesshud_stock_panel:set_size(w + 16, h + 9)
    self._uselesshud_stock_text:set_size(w, h)
    self._uselesshud_stock_panel:set_center(self._full_hud:center_x(), self._full_hud:center_y())
end

local file = io.open("mods/Useless-HUD/Stock/stock_list.txt", "r")
local txt
local _possible_stock = {}

if file then
	txt = json.decode(file:read("*all"))
	file:close()
	file = nil
	_possible_stock = txt
	txt = ""
end

math.randomseed(os.time())

function Uselesshud_Stock:GetData()
	if not _possible_stock or UselessHUD.settings.Stock ~= 1 then
		return
	end
	self._index_now = math.random(#_possible_stock)
	local _result = _possible_stock[self._index_now]
	local _url = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%22".. _result .."%22)&format=json&diagnostics=true&env=http%3A%2F%2Fdatatables.org%2Falltables.env&callback="
	dohttpreq(_url, function(data)
		if data and json then
			local _data = json.decode(data) or {}
			if _data and _data.query and _data.query.results and
				_data.query.results.quote and _data.query.results.quote.symbol then
				local _Name = _data.query.results.quote.Name
				local _Ask = _data.query.results.quote.Ask
				local _Change = _data.query.results.quote.Change
				local _ChangeinPercent = _data.query.results.quote.ChangeinPercent
				local _txt = "[".. _Name .."] "
				_txt = _txt .. "" .. _Ask .. " " .. _Change .. "(".. _ChangeinPercent ..")"
				if tonumber(_Change) < 0 then
					self._uselesshud_stock_text:set_color(Color(1, 0, 0))
				else
					self._uselesshud_stock_text:set_color(Color(0, 1, 0))
				end
				self:SetData({text = _txt})
			end
		end
	end)
	DelayedCalls:Add("DelayedCalls_Uselesshud_Stock_Update", math.random(4, 8), function()
		if UselessHUD and self and UselessHUD.settings.Stock == 1 then
			self:GetData()
		end
	end)
end

function Uselesshud_Stock:SetData(data)
	self._uselesshud_stock_text:set_text(tostring(data.text))
	local x, y, w, h = self._uselesshud_stock_text:text_rect()
    self._uselesshud_stock_text:set_font_size( 24 )
	self._uselesshud_stock_panel:set_size(w + 6,h + 4)
	self._uselesshud_stock_text:set_size(w,h)
	self._uselesshud_stock_panel:set_center(self._full_hud:center_x()*1.5, self._full_hud:center_y() - 150)    
	self._uselesshud_stock_panel:stop()
	if data.text and data.text ~= "" then
		self._uselesshud_stock_panel:animate(callback(self, self, "do_some_move"))
	end
end

function Uselesshud_Stock:do_some_move_animate_combo(text)
    local t = 0
    while t < 1 do
        t = t + coroutine.yield()
        local n = 1 - math.sin(t * 360)
        text:set_font_size(math.lerp( 24 + 6, 24 , n))
        local x,y,w,h = self._uselesshud_stock_text:text_rect()
        self._uselesshud_stock_panel:set_size(w + 6,h + 4)
        self._uselesshud_stock_text:set_size(w,h)   
        self._uselesshud_stock_panel:set_center(self._full_hud:center_x()*1.5, self._full_hud:center_y() - 150)
    end
    text:set_font_size( 24 )
    local x,y,w,h = self._uselesshud_stock_text:text_rect()
    self._uselesshud_stock_panel:set_size(w + 6,h + 4)
    self._uselesshud_stock_text:set_size(w,h)   
    self._uselesshud_stock_panel:set_center(self._full_hud:center_x()*1.5, self._full_hud:center_y() - 150)
end

function Uselesshud_Stock:do_some_move()
    local anim_t = 3
    local t = 5 - anim_t 
    if self._started then
        self._uselesshud_stock_text:animate(callback(self, self, "do_some_move_animate_combo"))
    end
    self._started = true
    while anim_t > 0 do
        anim_t = anim_t - coroutine.yield()
        local n = 1 - math.sin((anim_t / 2) * 400)       
        if self._uselesshud_stock_panel:alpha() < 0.99 then
            self._uselesshud_stock_panel:set_alpha(math.lerp(1, 0, n))
            self._uselesshud_stock_panel:set_center_x(math.lerp(self._full_hud:center_x()*1.5, self._full_hud:center_x()*1.5 - 120, n))
        end
    end
	while t > 0 do
		t = t - coroutine.yield()
	end
    while t < 0.5 do
        t = t + coroutine.yield()
        local n = 1 - math.sin((t / 2) * 350)       
        self._uselesshud_stock_panel:set_alpha(math.lerp(0, 1, n))
        self._uselesshud_stock_panel:set_center_x(math.lerp(self._full_hud:center_x()*1.5 - 120, self._full_hud:center_x()*1.5, n))
    end
    self._started = false
    self._uselesshud_stock_panel:set_alpha(0)
    self._uselesshud_stock_panel:set_x(self._full_hud:center_x()*1.5 - 120)
end
