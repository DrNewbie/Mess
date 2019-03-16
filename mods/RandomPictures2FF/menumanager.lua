if RandomPicture2FF then
	return
end

_G.RandomPicture2FF = {}

RandomPicture2FF.ModPath = ModPath

RandomPicture2FF.PaintingPaths = {
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_large_annabelle_1_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_large_annabelle_2_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_large_annabelle_3_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_large_annabelle_4_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_large_annabelle_5_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_large_annabelle_6_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_large_annabelle_7_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_large_annabelle_8_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_small_annabelle_1_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_large_ben_qwek_1_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_large_ben_qwek_2_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_large_ben_qwek_3_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_large_ben_qwek_4_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_large_ben_qwek_5_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_large_ben_qwek_6_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_large_ben_qwek_7_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_large_ben_qwek_8_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_large_ben_qwek_9_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_large_ben_qwek_10_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_large_ben_qwek_11_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_large_ben_qwek_12_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_large_ben_qwek_13_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_large_ben_qwek_14_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_large_ben_qwek_15_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_large_ben_qwek_16_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_medium_ben_qwek_1_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_medium_ben_qwek_2_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_medium_ben_qwek_3_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_medium_ben_qwek_4_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_small_ben_qwek_1_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_small_ben_qwek_2_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_small_ben_qwek_3_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_small_ben_qwek_4_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_small_ben_qwek_5_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_small_ben_qwek_6_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_small_ben_qwek_7_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_small_ben_qwek_8_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_small_ben_qwek_9_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_small_ben_qwek_10_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_small_ben_qwek_11_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_large_darius_1_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_large_darius_2_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_large_darius_3_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_large_darius_4_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_large_darius_5_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_large_darius_6_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_medium_darius_1_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_medium_darius_2_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_medium_darius_3_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_medium_darius_4_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_medium_darius_5_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_medium_darius_6_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_medium_darius_7_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_medium_darius_8_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_medium_darius_9_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_medium_darius_10_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_medium_darius_11_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_medium_darius_12_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_medium_darius_13_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_large_ray_1_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_large_ray_2_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_large_ray_3_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_large_ray_4_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_large_ray_5_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_large_ray_6_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_large_ray_7_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_large_ray_8_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_large_ray_9_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_large_ray_10_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_large_ray_11_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_medium_ray_1_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_medium_ray_2_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_medium_ray_3_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_medium_ray_4_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_medium_ray_5_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_medium_ray_6_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_medium_ray_7_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_medium_ray_8_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_medium_ray_9_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_medium_ray_10_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_medium_ray_11_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_medium_ray_12_df",
	"units/payday2/props/shared_textures/com_int_gallery_wall_painting_medium_ray_13_df"
}

function RandomPicture2FF:Reload()
	local _Directory, _Config = self.ModPath.."cache/", {}
	for id, painting in pairs(self.PaintingPaths) do
		table.insert(_Config, {
			_meta = "texture",
			path = painting,
			force = true
		})
	end
	CustomPackageManager:LoadPackageConfig(_Directory, _Config)
	QuickMenu:new(
		"[DL-Picture]",
		"Reloaded.",
		{{"Ok", is_cancel_button = true}},
		true
	):Show()
end

function RandomPicture2FF:SavePICFromWebNow2Path(id, painting)
	DelayedCalls:Add(Idstring('RandomPicture2FF:RunInitNow()'..painting):key(), 1 * id, function()
		self:_SavePICFromWebNow2Path(id, painting)
	end)
end

function RandomPicture2FF:_SavePICFromWebNow2Path(id, painting)
	local uurl = "https://gelbooru.com/index.php?page=post&s=random&tags=-animated"
	dohttpreq(uurl, 
		function (uurl_page)
			uurl_page = tostring(uurl_page):lower()
			uurl_page = tostring(string.match(uurl_page, '<a href=\"([^"]+)" style="font%-weight: bold;">original image<'))
			self.PICFromWebNow = uurl_page ~= "nil" and uurl_page or nil
			dohttpreq(self.PICFromWebNow, 
				function (PICFromWebNow_page)
					local basepath = Application:base_path()
					basepath = basepath:gsub('\\PAYDAY 2\\', '\\PAYDAY 2')
					local img2dds = self.ModPath..'img2dds/'
					local picpath = self.ModPath..'cache/'..painting..'.png'
					local ddspath = self.ModPath..'cache/'..painting..'.texture'
					local ppic = io.open(picpath, 'wb+')
					if ppic then
						ppic:write(PICFromWebNow_page)
						ppic:close()
						DelayedCalls:Add(Idstring('LoadRandPicture2FFPainting_'..painting):key(), 0.15, function()
							img2dds = Application:nice_path(img2dds, true) .. "img2dds.exe"
							picpath = Application:nice_path(basepath .. "/" .. picpath, false)											
							ddspath = Application:nice_path(basepath .. "/" .. ddspath, false)
							os.execute(tostring(string.format('%s -c "%s" "%s" & del "%s"', img2dds, picpath, ddspath, picpath)))
							local ddss = io.open(ddspath, 'r')
							if not ddss then
								log("[reTry]:\t"..painting)
								self:SavePICFromWebNow2Path(id + 90, painting)
							else
								ddss:close()
							end
						end)
					else
						log("[reTry]:\t"..painting)
						self:SavePICFromWebNow2Path(id + 90, painting)
					end
				end
			)
		end
	)
end

function RandomPicture2FF:RunInitNow(reTry)
	if not reTry then
		for id, painting in pairs(self.PaintingPaths) do
			self:SavePICFromWebNow2Path(id, painting)
		end
	end
	DelayedCalls:Add(Idstring('RandomPicture2FF:OkayNow???'):key(), 10, function()
		for id, painting in pairs(self.PaintingPaths) do
			local ccddspath = self.ModPath..'cache/'..painting..'.texture'
			local ccddss = io.open(ccddspath, 'r')
			if not ccddss then
				QuickMenu:new(
					"[DL-Picture]",
					"Nowloading...",
					{{"Ok", is_cancel_button = true}},
					true
				):Show()
				self:RunInitNow(true)
				break				
			else
				ccddss:close()
			end
		end
	end)
end

Hooks:Add("MenuManagerSetupCustomMenus", "MenuManagerSetupCustomMenus_RandomDD2FF", function(menu_manager, nodes)
	MenuHelper:NewMenu("RandomDD2FFMenuID")
end)

Hooks:Add("MenuManagerPopulateCustomMenus", "MenuManagerPopulateCustomMenus_RandomDD2FF", function(menu_manager, nodes)
	MenuCallbackHandler.RandomDD2FFNow = function()
		RandomPicture2FF:RunInitNow()
		QuickMenu:new(
			"[DL-Picture]",
			"Nowloading...",
			{{"Ok", is_cancel_button = true}},
			true
		):Show()
	end
	MenuHelper:AddButton({
		id = "RandomDD2FFNow",
		title = "menu_RandomDD2FFNow_name",
		desc = "menu_RandomDD2FFNow_desc",
		callback = "RandomDD2FFNow",
		menu_id = "RandomDD2FFMenuID",
	})
	MenuCallbackHandler.RandomDD2FFreload = function()
		RandomPicture2FF:Reload()
	end
	MenuHelper:AddButton({
		id = "RandomDD2FFreload",
		title = "menu_RandomDD2FFreload_name",
		desc = "menu_RandomDD2FFreload_desc",
		callback = "RandomDD2FFreload",
		menu_id = "RandomDD2FFMenuID",
	})
end)

Hooks:Add("MenuManagerBuildCustomMenus", "MenuManagerBuildCustomMenus_RandomDD2FF", function(menu_manager, nodes)
	nodes["RandomDD2FFMenuID"] = MenuHelper:BuildMenu("RandomDD2FFMenuID")
	MenuHelper:AddMenuItem(nodes["blt_options"], "RandomDD2FFMenuID", "menu_RandomDD2FFMain_name", "menu_RandomDD2FFMain_desc")
end)