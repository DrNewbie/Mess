if RandomPicture2FF then
	return
end

_G.RandomPicture2FF = {}

RandomPicture2FF.ModPath = ModPath

RandomPicture2FF.Debug = false

RandomPicture2FF.DebugForce = "https://cdn4.iconfinder.com/data/icons/new-google-logo-2015/400/new-google-favicon-512.png"

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

RandomPicture2FF.PaintingPaths_Size = 0

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
end

function RandomPicture2FF:RunInitNow()
	if DelayedCalls and dohttpreq then			
		os.execute('mkdir "'..self.ModPath..'cache/units/payday2/props/shared_textures/"')
		for id, painting in pairs(self.PaintingPaths) do
			DelayedCalls:Add(Idstring('GetRandPicture2FFPainting_'..painting):key(), 0.35 * id, function()
				local uurl = ""
				if self.Debug then
					local rr1 = string.format("%x", math.random(0,0xFFF))
					local rr2 = string.format("%x", math.random(0,0xFFF))
					local rr0 = math.random(600, 800)
					uurl = "https://dummyimage.com/"..rr0..".png/"..rr1.."/"..rr2..""
					if self.DebugForce then
						uurl = self.DebugForce
					end
				else
					uurl = "https://api.thecatapi.com/v1/images/search/?mime_types=png,jpg&size=small"
				end
				dohttpreq(uurl, 
					function (thecatapi_page)
						local catdata = {}
						if self.Debug then
							catdata = {{url = uurl}}
						else
							catdata = json.decode(tostring(thecatapi_page))
						end
						if type(catdata) == "table" and catdata[1] and catdata[1].url then
							dohttpreq(catdata[1].url, 
								function (catdata_page)
									local basepath = Application:base_path()
									basepath = basepath:gsub('\\PAYDAY 2\\', '\\PAYDAY 2')
									local img2dds = self.ModPath..'img2dds/'
									local picpath = self.ModPath..'cache/'..painting..'.png'
									local ddspath = self.ModPath..'cache/'..painting..'.texture'
									local ppic = io.open(picpath, 'wb+')
									if ppic then
										ppic:write(catdata_page)
										ppic:close()
										DelayedCalls:Add(Idstring('LoadRandPicture2FFPainting_'..painting):key(), 0.15 * id, function()
											self.PaintingPaths_Size = self.PaintingPaths_Size - 1
											img2dds = Application:nice_path(img2dds, true) .. "img2dds.exe"
											picpath = Application:nice_path(basepath .. "/" .. picpath, false)											
											ddspath = Application:nice_path(basepath .. "/" .. ddspath, false)
											os.execute(tostring(string.format('%s -c "%s" "%s" & del "%s"', img2dds, picpath, ddspath, picpath)))
											if HudChallengeNotification then
												local precc = math.round((1-RandomPicture2FF.PaintingPaths_Size/#RandomPicture2FF.PaintingPaths)*100)
												if precc > 99 or precc%11 == 0 or precc%17 == 0 then
													HudChallengeNotification.queue(
														" ",
														"Nowloading..."..precc.."%",
														table.random_key(tweak_data.hud_icons)
													)
												end
											end
											if self.PaintingPaths_Size <= 0 then
												self:Reload()
											end
										end)
									end
								end
							)
						end
					end
				)
			end)
		end
	end
end

Hooks:Add("MenuManagerSetupCustomMenus", "MenuManagerSetupCustomMenus_RandomCat2FF", function(menu_manager, nodes)
	MenuHelper:NewMenu("RandomCat2FFMenuID")
end)

Hooks:Add("MenuManagerPopulateCustomMenus", "MenuManagerPopulateCustomMenus_RandomCat2FF", function(menu_manager, nodes)
	MenuCallbackHandler.CleanAllRandomCat2FFNow = function()
		RandomPicture2FF.PaintingPaths_Size = #RandomPicture2FF.PaintingPaths
		RandomPicture2FF:RunInitNow()
		QuickMenu:new(
			"[DownloadMoreCats]",
			"Nowloading...",
			{{"Ok", is_cancel_button = true}},
			true
		):Show()
	end
	MenuHelper:AddButton({
		id = "CleanAllRandomCat2FFNow",
		title = "menu_CleanAllRandomCat2FFNow_name",
		desc = "menu_CleanAllRandomCat2FFNow_desc",
		callback = "CleanAllRandomCat2FFNow",
		menu_id = "RandomCat2FFMenuID",
	})
end)

Hooks:Add("MenuManagerBuildCustomMenus", "MenuManagerBuildCustomMenus_RandomCat2FF", function(menu_manager, nodes)
	nodes["RandomCat2FFMenuID"] = MenuHelper:BuildMenu("RandomCat2FFMenuID")
	MenuHelper:AddMenuItem(nodes["blt_options"], "RandomCat2FFMenuID", "menu_CleanAllRandomCat2FFNow_name", "menu_CleanAllRandomCat2FFNow_desc")
end)