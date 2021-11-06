local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local Hook1 = "F_"..Idstring("Hook1::"..ThisModIds):key()

_G[ThisModIds] = _G[ThisModIds] or false
if _G[ThisModIds] then
	return
else
	_G[ThisModIds] = true
end

local ThisModJson = {Since = 0}

local function __rnd_table(__t)
	math.randomseed(
		tostring(os.time()):reverse():sub(1, 6)
	)
	math.random()
	math.random()
	math.random()
	math.random()
	return table.random(__t)
end

local function __Save()
	local ThisModSave = io.open(ThisModPath.."__record.json", "w+")
	if ThisModSave then
		ThisModJson = ThisModJson or {Since = 0}
		ThisModSave:write(json.encode(ThisModJson))
		ThisModSave:close()
		ThisModSave = nil
	end
	return
end

local function __Load()
	local ThisModSave = io.open(ThisModPath.."__record.json", "r")
	if ThisModSave then
		ThisModJson = json.decode(ThisModSave:read("*all"))
		ThisModSave:close()
		ThisModSave = nil
	else
		ThisModJson.Since = 0
		__Save()
	end
	return
end

__Load()

local function IsTimeOK()
	ThisModJson = ThisModJson or {Since = 0}
	return math.abs((os.time()-ThisModJson.Since)/86400) >= 1.000
end

Hooks:PostHook(CivilianHeisterInteractionExt, "interact", Hook1, function(self)
	if managers.player and not self:is_daily_contractor() and self.character and self.character == "old_hoxton" then
		local __TodayNews = io.open(ThisModPath.."__news.json", "r")
		local __TodayNewsJson = nil
		if __TodayNews then
			__TodayNewsJson = json.decode(__TodayNews:read("*all"))
			__TodayNews:close()
			__TodayNews = nil
			if type(__TodayNewsJson) == "table" and not __TodayNewsJson.errors and __TodayNewsJson.totalArticles and type(__TodayNewsJson.articles) == "table" then
				__TodayNewsJson = __rnd_table(__TodayNewsJson.articles)
				local __t1, __t2 = tostring(__TodayNewsJson.title):gsub("[^%w%s-.',]", "")
				local __t3, __t4 = tostring(__TodayNewsJson.description):gsub("[^%w%s-.',]", "")
				__TodayNewsJson = {
					title = __t1,
					description = __t3,
					image = __TodayNewsJson.image
				}
				managers.system_menu:show({
					title = "[Daily News]",
					text = __TodayNewsJson.title.."\n"..__TodayNewsJson.description,
					button_list = {
						{text = "Thanks", is_cancel_button = true}
					},
					id = "F_"..Idstring(tostring(math.random(0,0xFFFFFFFF))):key()
				})
			end
		end
	end
end)

if not IsTimeOK() then
	return
end

local UseThisApiKey = __rnd_table({
	"725896638502d1ba8b3d4babb04576dc",
	"caab9993417443e5ed8b124e17b17b03",
	"f25a6158e21385994c3d5e8a02816ab4",
	"35d2b2f06e6d9ddfe020a5a63e981ed6",
	"475b2f1e92b2175b7fa38e851da23343",
	"b5a7e56cb439eb6d0cde8405f8cf3afd",
	"2d8efdbc45f679372efd06713b6a5c0a",
	"d44120985594e3882b672c184719e3d3"
})

local UseThisKeyWord = __rnd_table({
	"drug", "gun", "weapon", "candy", "cash", "money", "cocaine", 
	"heist", "steal", "rob", "payday", "lose", "crime", "bitcoin"
})

local UseThisUrl = "https://gnews.io/api/v4/search?q=" .. UseThisKeyWord
UseThisUrl = UseThisUrl .. "&lang=en"
UseThisUrl = UseThisUrl .. "&max=10"
UseThisUrl = UseThisUrl .. "&token=" .. UseThisApiKey

if dohttpreq then
	dohttpreq(UseThisUrl, 
		function (thecatapi_page)
			thecatapi_page = tostring(thecatapi_page)
			local TodayNews = io.open(ThisModPath.."__news.json", "w+")
			if TodayNews then
				local TodayNewsJson = json.decode(thecatapi_page)
				if type(TodayNewsJson) == "table" and not TodayNewsJson.errors and TodayNewsJson.totalArticles and type(TodayNewsJson.articles) == "table" then
					ThisModJson.Since = os.time()
					TodayNews:write(thecatapi_page)
					TodayNews:close()
					TodayNews = nil
					__Save()
				end
			end
		end
	)
end