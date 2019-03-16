if RandomGFSFW2FF then
	return
end

_G.RandomGFSFW2FF = {}

RandomGFSFW2FF.ModPath = ModPath

RandomGFSFW2FF.PaintingPaths = {
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

RandomGFSFW2FF.PaintingPathsSize = #RandomGFSFW2FF.PaintingPaths

function RandomGFSFW2FF:Reload()
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

function RandomGFSFW2FF:SavePICFromWebNow2Path(id, painting)
	DelayedCalls:Add(Idstring('RandomGFSFW2FF:SavePICFromWebNow2Path()'..painting):key(), 1 * id, function()
		self:_SavePICFromWebNow2Path(id, painting)
	end)
end

function RandomGFSFW2FF:_SavePICFromWebNow2Path(id, painting)
	local rndweb = table.random(self.PictureList)
	dohttpreq(rndweb, 
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

function RandomGFSFW2FF:RunInitNow(reTry)
	if not reTry then
		self.PictureList = {}
		for i = 0, 10 do
			DelayedCalls:Add(Idstring('RandomGFSFW2FF:PictureList:CC_'..i):key(), 2 + i * 0.3, function()
				local uurl = "http://safebooru.org/index.php?page=dapi&s=post&q=index&pid="..math.random(0, 100).."&tags=girls_frontline"
				dohttpreq(uurl, 
					function (uurl_page)
						uurl_page = tostring(uurl_page):lower()
						for k, v in string.gmatch(uurl_page, 'sample_url="([^"]+)') do
							local urrl = tostring(k)
							if urrl ~= "nil" then
								table.insert(self.PictureList, "http:"..tostring(k))
							end
						end
					end
				)
			end)
		end
		DelayedCalls:Add(Idstring('RandomGFSFW2FF:PictureList:OKAY'):key(), 35, function()
			if table.size(self.PictureList) > 0 then
				for id, painting in pairs(self.PaintingPaths) do
					self:SavePICFromWebNow2Path(id, painting)
				end
			end
		end)
	end
	DelayedCalls:Add(Idstring('RandomGFSFW2FF:OkayNow???'):key(), 10, function()
		for id, painting in pairs(self.PaintingPaths) do
			local ccddspath = self.ModPath..'cache/'..painting..'.texture'
			local ccddss = io.open(ccddspath, 'r')
			if not ccddss then
				QuickMenu:new(
					"[DL-Picture]",
					"Nowloading...["..id.."/"..RandomGFSFW2FF.PaintingPathsSize.."]",
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

Hooks:Add("MenuManagerSetupCustomMenus", "MenuManagerSetupCustomMenus_RandomGFSFW2FF", function()
	MenuHelper:NewMenu("RandomGFSFW2FFMenuID")
end)

Hooks:Add("MenuManagerPopulateCustomMenus", "MenuManagerPopulateCustomMenus_RandomGFSFW2FF", function()
	MenuCallbackHandler.RandomGFSFW2FFNow = function()
		RandomGFSFW2FF:RunInitNow()
		QuickMenu:new(
			"[DL-Picture]",
			"Nowloading...",
			{{"Ok", is_cancel_button = true}},
			true
		):Show()
	end
	MenuHelper:AddButton({
		id = "RandomGFSFW2FFNow",
		title = "menu_RandomGFSFW2FFNow_name",
		desc = "menu_RandomGFSFW2FFNow_desc",
		callback = "RandomGFSFW2FFNow",
		menu_id = "RandomGFSFW2FFMenuID",
	})
	MenuCallbackHandler.RandomGFSFW2FFreload = function()
		RandomGFSFW2FF:Reload()
	end
	MenuHelper:AddButton({
		id = "RandomGFSFW2FFreload",
		title = "menu_RandomGFSFW2FFreload_name",
		desc = "menu_RandomGFSFW2FFreload_desc",
		callback = "RandomGFSFW2FFreload",
		menu_id = "RandomGFSFW2FFMenuID",
	})
end)

Hooks:Add("MenuManagerBuildCustomMenus", "MenuManagerBuildCustomMenus_RandomGFSFW2FF", function(menu_manager, nodes)
	nodes["RandomGFSFW2FFMenuID"] = MenuHelper:BuildMenu("RandomGFSFW2FFMenuID")
	MenuHelper:AddMenuItem(nodes["blt_options"], "RandomGFSFW2FFMenuID", "menu_RandomGFSFW2FFMain_name", "menu_RandomGFSFW2FFMain_desc")
end)