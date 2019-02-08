MProfileManFix_ModPath = ModPath

local Post_MProfileManFix_Load = MultiProfileManager.load

function MultiProfileManager:load(data, ...)
	local save_files = io.open(MProfileManFix_ModPath.."/Save/multiprofile.json", "r")
	if not save_files then
		log("[MProfileManFix] save_files open fail.")
	else
		local save_data = json.decode(save_files:read("*all"))
		save_files:close()
		if type(data) ~= "table" then
			log("[MProfileManFix] data is not table.")
		elseif type(save_data) ~= "table" then
			log("[MProfileManFix] save_data is not table.")
		elseif save_data.Empty then
			log("[MProfileManFix] save_data is 'Empty'.")
		else
			if type(data.multi_profile) ~= "table" then
				log("[MProfileManFix] data.multi_profile is not table.")
				data.multi_profile = {}
				for i = 1, 15 do
					data.multi_profile[i] = {
						primary = 1,
						perk_deck = 1,
						armor = "level_1",
						skillset = 1,
						secondary = 9,
						mask = 1,
						armor_skin = "none",
						throwable = "frag",
						melee = "weapon"
					}
					data.multi_profile.current_profile = 1
				end
			else
				if type(save_data) ~= "table" then
					log("[MProfileManFix] save_data is not table.")
				else
					if type(save_data.dates) ~= "table" then
						log("[MProfileManFix] save_data.dates is not table.")
					else
						data.multi_profile = deep_clone(save_data.dates)
						if type(data.multi_profile.current_profile) ~= "number" then
							log("[MProfileManFix] data.multi_profile.current_profile is not number.")
							data.multi_profile.current_profile = 1
						end
						if type(data.multi_profile) ~= "table" or data.multi_profile[data.multi_profile.current_profile] then
							log("[MProfileManFix] data.multi_profile or [i] is not table.")
							data.multi_profile.current_profile = 1
							data.multi_profile[1] = {
								primary = 1,
								perk_deck = 1,
								armor = "level_1",
								skillset = 1,
								secondary = 9,
								mask = 1,
								armor_skin = "none",
								throwable = "frag",
								melee = "weapon"
							}
						end
					end
				end
			end
		end		
	end
	return Post_MProfileManFix_Load(self, data, ...)
end

Hooks:PostHook(MultiProfileManager, 'save', 'Post_MProfileManFix_Save', function(self, data)
	local save_files = io.open(MProfileManFix_ModPath.."/Save/multiprofile.json", "w+")
	if not save_files then
		log("[MProfileManFix] save_files open fail.")
	else
		log("[MProfileManFix] multi_profile")
		local save2files = {
			dates = deep_clone(self._global._profiles)
		}
		save2files.dates.current_profile = self._global._current_profile		
		save2files.Version = os.date("%m/%d/%Y - %X")
		save_files:write(json.encode(save2files))
		save_files:close()
	end
end)