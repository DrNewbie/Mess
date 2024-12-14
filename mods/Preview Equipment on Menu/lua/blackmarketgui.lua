local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local __Name = function(__id)
	return "B_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end

function BlackMarketGui:preview_ZXF1AXBTZW50_callback(data)
	managers.menu:open_node("blackmarket_preview_node", {})
	managers.menu_scene:spawn_ZXF1AXBTZW50(data.name)
end

Hooks:PostHook(BlackMarketGui, "_setup", __Name(1), function(self, ...)
	if self._btns and type(self._btns) == "table" then
		self._btns[__Name(2)] = BlackMarketGuiButtonItem:new(self._buttons, {
			btn = "BTN_STICK_R",
			name = "bm_menu_btn_preview",
			prio = 2,
			pc_btn = "menu_preview_item",
			callback = callback(self, self, "preview_ZXF1AXBTZW50_callback")
		}, 10)
	end
end)

Hooks:PostHook(BlackMarketGui, "populate_deployables", __Name(3), function(self, data, ...)
	for __k, __v in pairs(data) do
		if data[__k] and type(__v) == "table" and __v["unlocked"] then
			table.insert(data[__k], __Name(2))
		end
	end
end)