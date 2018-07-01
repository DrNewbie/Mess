BlkManFix_ModPath = ModPath

if ModCore then
	ModCore:new(BlkManFix_ModPath .. "Config.xml", true, true)
end

BlkManFix_Default = {
	_preferred_characters = {"bodhi"},
	crafted_items = {
		primaries = {},
		masks = {},
		secondaries = {}
	},
	_selected_henchmen = {
		{mask = "character_locked"},
		{mask = "character_locked"},
		{mask = "character_locked"},
		{mask = "character_locked"},
		{mask = "character_locked"},
		{mask = "character_locked"},
		{mask = "character_locked"},
		{mask = "character_locked"},
		{mask = "character_locked"},
		{mask = "character_locked"},
		{mask = "character_locked"},
		{mask = "character_locked"},
		{mask = "character_locked"},
		{mask = "character_locked"},
		{mask = "character_locked"}
	},
	_preferred_character = "bodhi",
	armors = {
		level_1 = {equipped = true, owned = true, unlocked = true},
		level_2 = {equipped = false, owned = false, unlocked = false},
		level_3 = {equipped = false, owned = false, unlocked = false},
		level_4 = {equipped = false, owned = false, unlocked = false},
		level_5 = {equipped = false, owned = false, unlocked = false},
		level_6 = {equipped = false, owned = false, unlocked = false},
		level_7 = {equipped = false, owned = false, unlocked = false}
	},
	_preferred_henchmen = {"bodhi"}
}

local Post_BlkManFix_Load = BlackMarketManager.load

function BlackMarketManager:load(data, ...)
	local save_files = io.open(BlkManFix_ModPath.."/Save/blackmarket.json", "r")
	if not save_files then
		log("[BlkManFix] save_files open fail.")
	else
		local save_data = json.decode(save_files:read("*all"))
		save_files:close()
		if type(data) ~= "table" then
			log("[BlkManFix] data is not table.")
		elseif type(save_data) ~= "table" then
			log("[BlkManFix] save_data is not table.")
		elseif save_data.Empty then
			log("[BlkManFix] save_data is 'Empty'.")
		elseif type(data.blackmarket) ~= "table" then
			log("[BlkManFix] data.blackmarket is not table.")
		else
			data.blackmarket._preferred_characters = save_data._preferred_characters or BlkManFix_Default._preferred_characters
			data.blackmarket.crafted_items = save_data.crafted_items or BlkManFix_Default.crafted_items
			data.blackmarket._selected_henchmen = save_data._selected_henchmen or BlkManFix_Default._selected_henchmen
			data.blackmarket._preferred_character = save_data._preferred_character or BlkManFix_Default._preferred_character
			data.blackmarket.armors = save_data.armors or BlkManFix_Default.armors
			data.blackmarket._preferred_henchmen = save_data._preferred_henchmen or BlkManFix_Default._preferred_henchmen
		end		
	end
	return Post_BlkManFix_Load(self, data, ...)
end

Hooks:PostHook(BlackMarketManager, 'save', 'Post_BlkManFix_Save', function(self, data)
	local save_files = io.open(BlkManFix_ModPath.."/Save/blackmarket.json", "w+")
	if not save_files then
		log("[BlkManFix] save_files open fail.")
	else
		local save2files = {}
		data = type(data) == "table" and data or {}
		data.blackmarket = type(data.blackmarket) == "table" and data.blackmarket or {}
		
		log("[BlkManFix] crafted_items")
		save2files.crafted_items = BlkManFix_Default.crafted_items
		if data.blackmarket.crafted_items then
			save2files.crafted_items = data.blackmarket.crafted_items
		end
		log("[BlkManFix] armors")
		save2files.armors = BlkManFix_Default.armors
		if data.blackmarket.armors then
			save2files.armors = data.blackmarket.armors
		end
		log("[BlkManFix] _selected_henchmen")
		save2files._selected_henchmen = BlkManFix_Default._selected_henchmen
		if data.blackmarket._selected_henchmen then
			save2files._selected_henchmen = data.blackmarket._selected_henchmen
		end
		log("[BlkManFix] _preferred_characters")
		save2files._preferred_characters = BlkManFix_Default._preferred_characters
		if data.blackmarket._preferred_characters then
			save2files._preferred_characters = data.blackmarket._preferred_characters
		end
		log("[BlkManFix] _preferred_henchmen")
		save2files._preferred_henchmen = BlkManFix_Default._preferred_henchmen
		if data.blackmarket._preferred_henchmen then
			save2files._preferred_henchmen = data.blackmarket._preferred_henchmen
		end
		log("[BlkManFix] _preferred_character")
		save2files._preferred_character = BlkManFix_Default._preferred_character
		if data.blackmarket._preferred_character then
			save2files._preferred_character = data.blackmarket._preferred_character
		end
		save_files:write(json.encode(save2files))
		save_files:close()
	end
end)

local BlkManFix_outfit_string_mask = BlackMarketManager._outfit_string_mask

function BlackMarketManager:_outfit_string_mask(...)
	local equipped = managers.blackmarket:equipped_mask()
	if type(equipped) == "string" or type(equipped) == "table" then
		return BlkManFix_outfit_string_mask(self, ...)
	else
		log("[BlkManFix] broken equipped")
		local s = ""
		s = s .. " " .. "false"
		s = s .. " " .. "nothing"
		s = s .. " " .. "no_color_no_material"
		s = s .. " " .. "plastic"
		return s
	end
end