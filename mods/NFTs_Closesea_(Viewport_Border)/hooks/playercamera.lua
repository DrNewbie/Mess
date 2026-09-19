local ThisModPath = ModPath or tostring(math.random())
local ThisModIds = Idstring(ThisModPath):key()
local __Name = function(__id)
	return "NFTs_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end
local __NewText = function(__data)
	local panel = managers.hud._fullscreen_workspace:panel()
	local text = panel:child(__Name(__data.name)) or panel:text({
		name = __Name(__data.name),
		text = __data.text,
		valign = "center",
		align = "left",
		vertical = "center",
		w = __data.w,
		h = __data.h,
		color = __data.color or Color.white,
		font = "fonts/font_large_mf",
		font_size = __data.font_size
	})
	text:set_center_x(panel:w()*__data.x_rate)
	text:set_center_y(panel:h()*__data.y_rate)
end
local __NameList = {Steam:username()}
local __LoadNames = function()
	local function fetch_random_group_member_names(url)
		local members = {}
		local function fetch_pages(url)
			dohttpreq(url, function (data)
				for id in data:gmatch("<steamID64>([0-9]+)<") do
					table.insert(members, id)
				end
				local next_page = data:match("<nextPageLink><!%[CDATA%[(.+)%]%]></nextPageLink>")
				if next_page then
					fetch_pages(next_page)
				else
					for i = 1, 10 do
						local index = math.random(#members)
						local member = members[index]
						table.remove(members, index)
						dohttpreq("https://steamcommunity.com/profiles/" .. member .. "/?xml=1", function (data)
							local name = data:match("<steamID><!%[CDATA%[(.+)%]%]></steamID>")
							if name then
								table.insert(__NameList, name)
							end
						end)
					end
				end
			end)
		end
		fetch_pages(url)
	end
	fetch_random_group_member_names("https://steamcommunity.com/groups/modworkshop/memberslistxml/?xml=1")
end
__LoadNames()

local ui_wanted = false

Hooks:PostHook(PlayerCamera, "setup_viewport", __Name("setup_viewport"), function(self, ...)
	lore_wanted = true
	ui_wanted = true
end)

Hooks:PostHook(PlayerCamera, "update", __Name("update"), function(self, ...)
	if ui_wanted then
		local nfts = ViewportBorderImage:new(
			"nftslol",
			1440, 1440,
			90, 340, 520, 600
		)
		ViewportBorder.add_layer(nfts)
		
		__NewText({
			name = "nfts id",
			text = "#"..Idstring(tostring(math.random())):key(),
			w = 256,
			h = 128,
			font_size = 32,
			x_rate = 0.57,
			y_rate = 0.267
		})
		
		__NewText({
			name = "nfts author 1",
			text = string.sub("Created by "..tostring(Steam:username()), 1, 32),
			w = 256,
			h = 128,
			font_size = 18,
			x_rate = 0.37,
			y_rate = 0.682
		})
		
		__NewText({
			name = "nfts own 1",
			text = string.sub("Owned by "..tostring(table.random(__NameList)), 1, 32),
			w = 256,
			h = 128,
			font_size = 18,
			x_rate = 0.57,
			y_rate = 0.31
		})
		
		local now_time = os.time()
		__NewText({
			name = "nfts sell end",
			text = "Sale ends "..tostring(os.date("%Y-%m-%d-%H:%M", now_time)),
			w = 256,
			h = 128,
			font_size = 12,
			x_rate = 0.583,
			y_rate = 0.353
		})
		
		local price_now = math.random()*1000
		__NewText({
			name = "nfts price now",
			text = string.format("%.2f",price_now),
			w = 256,
			h = 128,
			font_size = 14,
			x_rate = 0.583,
			y_rate = 0.422
		})
		
		local price_p = {}
		price_p[1] = price_now * math.random()
		price_p[2] = price_p[1] * math.random()
		price_p[3] = price_p[2] * math.random()
		price_p[4] = price_p[3] * math.random()
		
		local time_p = {}
		time_p[1] = now_time - math.round(math.random()*100)
		time_p[2] = time_p[1] - math.round(math.random()*100)
		time_p[3] = time_p[2] - math.round(math.random()*100)
		time_p[4] = time_p[3] - math.round(math.random()*100)
		
		local __step = 0.04		
		for __i = 1, 4 do
			__NewText({
				name = "nfts price p"..__i,
				text = string.format("%.2f WETH", price_p[__i]),
				w = 256,
				h = 128,
				font_size = 12,
				x_rate = 0.58,
				y_rate = 0.653 + __i * __step - __step
			})
			__NewText({
				name = "nfts price p"..__i.." rate",
				text = string.format("(%d%% below)", ((price_now-price_p[__i])/price_now)*100),
				w = 256,
				h = 128,
				font_size = 12,
				x_rate = 0.63,
				y_rate = 0.653 + __i * __step - __step
			})
			__NewText({
				name = "nfts price p"..__i.." time",
				text = tostring(os.date("%Y-%m-%d", time_p[__i])),
				w = 256,
				h = 128,
				font_size = 12,
				x_rate = 0.68,
				y_rate = 0.653 + __i * __step - __step
			})
			__NewText({
				name = "nfts price p"..__i.." name",
				text = string.sub(table.random(__NameList), 1, 16),
				w = 256,
				h = 128,
				font_size = 12,
				x_rate = 0.73,
				y_rate = 0.653 + __i * __step - __step
			})
		end
			
		ui_wanted = false
	end
end)