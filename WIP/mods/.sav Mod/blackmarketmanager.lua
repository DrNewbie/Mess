BlkManFix_ModPath = ModPath

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
	_preferred_henchmen = {"bodhi"},
	cash = {
		total_collected = 0,
		total_spent = 0,
		offshore = 0,
		total = 0
	},
	exp = {
		level = 1,
		xp_gained = 0,
		total = 0,
		rank = 0,
		next_level_data = {
			points = 1,
			current_points = 0
		}
	}
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
		else
			if type(save_data.blackmarket) ~= "table" then
				log("[BlkManFix] save_data.blackmarket is not table.")
				save_data.blackmarket = {}
			end
			if type(save_data.exp) ~= "table" then
				log("[BlkManFix] save_data.exp is not table.")
				save_data.exp = BlkManFix_Default.exp
			end
			if type(save_data.cash) ~= "table" then
				log("[BlkManFix] save_data.cash is not table.")
				save_data.cash = BlkManFix_Default.cash
			end
			if type(save_data.crafted_items) ~= "table" then
				save_data.crafted_items = nil
			else
				if type(save_data.crafted_items.primaries) ~= "table" then
					save_data.crafted_items.primaries = {}
				end
				if type(save_data.crafted_items.secondaries) ~= "table" then
					save_data.crafted_items.secondaries = {}
				end
				if type(save_data.crafted_items.masks) ~= "table" then
					save_data.crafted_items.masks = {}
				end
				if tweak_data.weapon and tweak_data.weapon.factory then
					for id, data in pairs(save_data.crafted_items.primaries) do
						if type(data) ~= "table" then
							log("[BlkManFix] crafted_items.primaries["..id.."] is not table.")
							save_data.crafted_items.primaries[id] = nil
						elseif not data.weapon_id then
							log("[BlkManFix] crafted_items.primaries["..id.."] has no weapon_id.")
							save_data.crafted_items.primaries[id] = nil
						elseif not tweak_data.weapon[data.weapon_id] then
							log("[BlkManFix] broken data.weapon_id: "..tostring(data.weapon_id))
							save_data.crafted_items.primaries[id] = nil
						elseif not tweak_data.weapon.factory[data.factory_id] then
							log("[BlkManFix] broken data.factory_id: "..tostring(data.factory_id))
							save_data.crafted_items.primaries[id] = nil
						end
					end
					for id, data in pairs(save_data.crafted_items.secondaries) do
						if type(data) ~= "table" then
							log("[BlkManFix] crafted_items.secondaries["..id.."] is not table.")
							save_data.crafted_items.secondaries[id] = nil
						elseif not data.weapon_id then
							log("[BlkManFix] crafted_items.secondaries["..id.."] has no weapon_id.")
							save_data.crafted_items.secondaries[id] = nil
						elseif not tweak_data.weapon[data.weapon_id] then
							log("[BlkManFix] broken data.weapon_id: "..tostring(data.weapon_id))
							save_data.crafted_items.secondaries[id] = nil
						elseif not tweak_data.weapon.factory[data.factory_id] then
							log("[BlkManFix] broken data.factory_id: "..tostring(data.factory_id))
							save_data.crafted_items.secondaries[id] = nil
						end
					end
				end
				if tweak_data.blackmarket.masks then
					for id, data in pairs(save_data.crafted_items.masks) do
						if type(data) ~= "table" then
							log("[BlkManFix] crafted_items.masks["..id.."] is not table.")
							save_data.crafted_items.masks[id] = nil
						elseif not data.mask_id then
							log("[BlkManFix] crafted_items.masks["..id.."] has no mask_id.")
							save_data.crafted_items.masks[id] = nil
						elseif not tweak_data.blackmarket.masks[data.mask_id] then
							log("[BlkManFix] broken data.mask_id: "..tostring(data.mask_id))
							save_data.crafted_items.masks[id] = nil
						end
					end
					for id, data in pairs(save_data._selected_henchmen) do
						if type(data) ~= "table" then
							log("[BlkManFix] _selected_henchmen["..id.."] is not table.")
							save_data._selected_henchmen[id] = {mask = "character_locked"}
						elseif not data.mask then
							log("[BlkManFix] _selected_henchmen["..id.."] has no mask.")
							save_data._selected_henchmen[id].mask = "character_locked"
						elseif not tweak_data.blackmarket.masks[data.mask] then
							log("[BlkManFix] broken data.mask: "..tostring(data.mask))
							save_data._selected_henchmen[id].mask = "character_locked"
						end
					end
				end
			end
			data.blackmarket._preferred_characters = save_data._preferred_characters or BlkManFix_Default._preferred_characters
			data.blackmarket.crafted_items = save_data.crafted_items or BlkManFix_Default.crafted_items
			data.blackmarket._selected_henchmen = save_data._selected_henchmen or BlkManFix_Default._selected_henchmen
			data.blackmarket._preferred_character = save_data._preferred_character or BlkManFix_Default._preferred_character
			data.blackmarket.armors = save_data.armors or BlkManFix_Default.armors
			data.blackmarket._preferred_henchmen = save_data._preferred_henchmen or BlkManFix_Default._preferred_henchmen
			if type(save_data.exp.level) == "number" then
				data.ExperienceManager.level = Application:digest_value(math.max(save_data.exp.level, 1), true)
			else
				log("[BlkManFix] exp.level is not number")
				data.ExperienceManager.level = Application:digest_value(BlkManFix_Default.exp.level, true)
			end
			if type(save_data.exp.xp_gained) == "number" then
				data.ExperienceManager.xp_gained = Application:digest_value(math.max(save_data.exp.xp_gained, 0), true)
			else
				log("[BlkManFix] exp.xp_gained is not number")
				data.ExperienceManager.xp_gained = Application:digest_value(BlkManFix_Default.exp.xp_gained, true)
			end
			if type(save_data.exp.total) == "number" then
				data.ExperienceManager.total = Application:digest_value(math.max(save_data.exp.total, 0), true)
			else
				log("[BlkManFix] exp.total is not number")
				data.ExperienceManager.total = Application:digest_value(BlkManFix_Default.exp.total, true)
			end
			if type(save_data.exp.rank) == "number" then
				data.ExperienceManager.rank = Application:digest_value(math.max(save_data.exp.rank, 0), true)
			else
				log("[BlkManFix] exp.rank is not number")
				data.ExperienceManager.rank = Application:digest_value(BlkManFix_Default.exp.rank, true)
			end
			if type(save_data.exp.next_level_data) ~= "table" then
				log("[BlkManFix] exp.next_level_data is not table")
				save_data.exp.next_level_data = BlkManFix_Default.exp.next_level_data
			end
			if type(save_data.exp.next_level_data.points) == "number" then
				data.ExperienceManager.next_level_data.points = Application:digest_value(math.max(save_data.exp.next_level_data.points, 1), true)
			else
				log("[BlkManFix] exp.next_level_data.points is not number")
				data.ExperienceManager.next_level_data.points = Application:digest_value(BlkManFix_Default.exp.next_level_data.points, true)
			end
			if type(save_data.exp.next_level_data.current_points) == "number" then
				data.ExperienceManager.next_level_data.current_points = Application:digest_value(math.max(save_data.exp.next_level_data.current_points, 0), true)
			else
				log("[BlkManFix] exp.next_level_data.current_points is not number")
				data.ExperienceManager.next_level_data.current_points = Application:digest_value(BlkManFix_Default.exp.next_level_data.current_points, true)
			end
			if type(save_data.cash.total_collected) == "number" then
				data.MoneyManager.total_collected = Application:digest_value(math.max(save_data.cash.total_collected, 0), true)
			else
				log("[BlkManFix] cash.total_collected is not number")
				data.MoneyManager.total_collected = Application:digest_value(BlkManFix_Default.cash.total_collected, true)
			end
			if type(save_data.cash.total_spent) == "number" then
				data.MoneyManager.total_spent = Application:digest_value(math.max(save_data.cash.total_spent, 0), true)
			else
				log("[BlkManFix] cash.total_spent is not number")
				data.MoneyManager.total_spent = Application:digest_value(BlkManFix_Default.cash.total_spent, true)
			end
			if type(save_data.cash.offshore) == "number" then
				data.MoneyManager.offshore = Application:digest_value(math.max(save_data.cash.offshore, 0), true)
			else
				log("[BlkManFix] cash.offshore is not number")
				data.MoneyManager.offshore = Application:digest_value(BlkManFix_Default.cash.offshore, true)
			end
			if type(save_data.cash.total) == "number" then
				data.MoneyManager.total = Application:digest_value(math.max(save_data.cash.total, 0), true)
			else
				log("[BlkManFix] cash.total is not number")
				data.MoneyManager.total = Application:digest_value(BlkManFix_Default.cash.total, true)
			end
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
		--Create empty table for empty slot
		for i = 1, #(save2files.crafted_items.primaries) do
			if type(save2files.crafted_items.primaries[i]) ~= "table" then
				save2files.crafted_items.primaries[i] = {}
			end
		end
		for i = 1, #(save2files.crafted_items.secondaries) do
			if type(save2files.crafted_items.secondaries[i]) ~= "table" then
				save2files.crafted_items.secondaries[i] = {}
			end
		end
		for i = 1, #(save2files.crafted_items.masks) do
			if type(save2files.crafted_items.masks[i]) ~= "table" then
				save2files.crafted_items.masks[i] = {}
			end
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
		local digest_value_type = type(Application:digest_value(1, true))
		if type(data.ExperienceManager) ~= "table" then
			log("[BlkManFix] data.ExperienceManager is not table")
		end
		log("[BlkManFix] data.ExperienceManager")
		save2files.exp = BlkManFix_Default.exp
		local EXP_table = type(data.ExperienceManager) == "table" and data.ExperienceManager or {}
		if type(EXP_table.level) == digest_value_type then
			save2files.exp.level = Application:digest_value(EXP_table.level, false)
		end
		if type(EXP_table.xp_gained) == digest_value_type then
			save2files.exp.xp_gained = Application:digest_value(EXP_table.xp_gained, false)
		end
		if type(EXP_table.total) == digest_value_type then
			save2files.exp.total = Application:digest_value(EXP_table.total, false)
		end
		if type(EXP_table.rank) == digest_value_type then
			save2files.exp.rank = Application:digest_value(EXP_table.rank, false)
		end
		if type(EXP_table.next_level_data) == "table" then
			if type(EXP_table.next_level_data.points) == digest_value_type then
				save2files.exp.next_level_data.points = Application:digest_value(EXP_table.next_level_data.points, false)
			end
			if type(EXP_table.next_level_data.current_points) == digest_value_type then
				save2files.exp.next_level_data.current_points = Application:digest_value(EXP_table.next_level_data.current_points, false)
			end
		end
		if type(data.MoneyManager) ~= "table" then
			log("[BlkManFix] data.MoneyManager is not table")
		end
		log("[BlkManFix] data.MoneyManager")
		save2files.cash = BlkManFix_Default.cash
		local Money_table = type(data.MoneyManager) == "table" and data.MoneyManager or {}
		if type(Money_table.total_collected) == digest_value_type then
			save2files.cash.total_collected = Application:digest_value(Money_table.total_collected, false)
		end
		if type(Money_table.total_spent) == digest_value_type then
			save2files.cash.total_spent = Application:digest_value(Money_table.total_spent, false)
		end
		if type(Money_table.offshore) == digest_value_type then
			save2files.cash.offshore = Application:digest_value(Money_table.offshore, false)
		end
		if type(Money_table.total) == digest_value_type then
			save2files.cash.total = Application:digest_value(Money_table.total, false)
		end
		save2files.Version = os.date("%m/%d/%Y - %X")
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