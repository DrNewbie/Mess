if true then return end

SkillTreeManFix_ModPath = ModPath

function SkillTreeManager:SkillTreeManFix_Transfer(a_table, a_bool)
	a_table.points = Application:digest_value(a_table.points, a_bool)
	for i, d in pairs(a_table.trees) do
		if type(d) == "table" then
			if d.points_spent then
				a_table.trees[i].points_spent = Application:digest_value(d.points_spent, a_bool)
			end
		end
	end
	for i, d in pairs(a_table.specializations) do
		if type(d) == "table" then
			if d.points_spent then
				a_table.specializations[i].points_spent = Application:digest_value(d.points_spent, a_bool)
			end
			if d.tiers then
				a_table.specializations[i].tiers.current_tier = Application:digest_value(d.tiers.current_tier, a_bool)
				a_table.specializations[i].tiers.max_tier = Application:digest_value(d.tiers.max_tier, a_bool)
				if d.tiers.next_tier_data then
					a_table.specializations[i].tiers.next_tier_data.points = Application:digest_value(d.tiers.next_tier_data.points, a_bool)
					a_table.specializations[i].tiers.next_tier_data.current_points = Application:digest_value(d.tiers.next_tier_data.current_points, a_bool)
				end
			end
		end
	end
	for _, name in pairs({"points_present", "current_specialization", "xp_present", "xp_leftover", "points", "max_points", "total_points"}) do
		a_table.specializations[name] = Application:digest_value(a_table.specializations[name], a_bool)
	end
	for i, d in pairs(a_table.skill_switches) do
		if type(d) == "table" then
			if d.points then
				a_table.skill_switches[i].points = Application:digest_value(d.points, a_bool)
			end
			if d.specialization then
				a_table.skill_switches[i].specialization = Application:digest_value(d.specialization, a_bool)
			end
			if d.trees then
				for ii, dd in pairs(d.trees) do
					if dd.points_spent then
						a_table.skill_switches[i].trees[ii].points_spent = Application:digest_value(dd.points_spent, a_bool)
					end
				end
			end
		end
	end
	return a_table
end

local Post_SkillTreeManFix_Load = SkillTreeManager.load

function SkillTreeManager:load(data, ...)
	local save_files = io.open(SkillTreeManFix_ModPath.."/Save/skilltree.json", "r")
	if not save_files then
		log("[SkillTreeManFix] save_files open fail.")
	else
		local save_data = json.decode(save_files:read("*all"))
		save_files:close()
		if type(data) ~= "table" then
			log("[SkillTreeManFix] data is not table.")
			self:reset()
			self:_verify_loaded_data(0)
		elseif type(save_data) ~= "table" then
			log("[SkillTreeManFix] save_data is not table.")
		elseif save_data.Empty then
			log("[SkillTreeManFix] save_data is 'Empty'.")
		else
			log("[SkillTreeManFix] load")
			save_data.SkillTreeManager = self:SkillTreeManFix_Transfer(save_data.SkillTreeManager, true)
			data.SkillTreeManager = deep_clone(save_data.SkillTreeManager)
		end
	end
	return Post_SkillTreeManFix_Load(self, data, ...)
end

Hooks:PostHook(SkillTreeManager, 'save', 'Post_SkillTreeManFix_Save', function(self)
	local save_files = io.open(SkillTreeManFix_ModPath.."/Save/skilltree.json", "w+")
	if not save_files then
		log("[SkillTreeManFix] save_files open fail.")
	else
		log("[SkillTreeManFix] SkillTreeManager")
		local clone_global = deep_clone(self._global)
		local save2files = {
			SkillTreeManager = {
				points = clone_global.points,
				trees = clone_global.trees,
				skills = clone_global.skills,
				skill_switches = clone_global.skill_switches,
				selected_skill_switch = clone_global.selected_skill_switch,
				specializations = clone_global.specializations,
				VERSION = clone_global.VERSION or 0,
				reset_message = clone_global.reset_message,
				times_respeced = clone_global.times_respeced or 1
			}
		}
		save2files.SkillTreeManager = self:SkillTreeManFix_Transfer(save2files.SkillTreeManager, false)
		save2files.Version = os.date("%m/%d/%Y - %X")
		save_files:write(json.encode(save2files))
		save_files:close()
	end
end)