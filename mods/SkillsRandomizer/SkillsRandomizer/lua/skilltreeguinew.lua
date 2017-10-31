_G.SKRR = _G.SKRR or {}

function SKRR:do_invest(tree, skill_id, tier)
	if managers.skilltree:has_enough_skill_points(skill_id) and managers.skilltree:unlock(skill_id) then
		local skill_step = managers.skilltree:skill_step(skill_id)
		local points = managers.skilltree:skill_cost(tier, skill_step)
		local skill_points = managers.skilltree:spend_points(points)
		managers.menu_component._skilltree_gui:set_skill_point_text(skill_points)
		managers.skilltree:_set_points_spent(tree, managers.skilltree:points_spent(tree) + points)
		return true
	end
	return false
end

local skrr_original_skilltreeguinew_setup = NewSkillTreeGui._setup
function NewSkillTreeGui:_setup()
	skrr_original_skilltreeguinew_setup(self)
	local do_skills_randomizer_setup = self._panel:text({
		name = "do_skills_randomizer_setup",
		text = managers.localization:to_upper_text("menu_skillsrandomizer_run"),
		align = "left",
		vertical = "top",
		font_size = tweak_data.menu.pd2_medium_font_size - 4,
		font = tweak_data.menu.pd2_medium_font,
		color = Color.black,
		blend_mode = "add",
	})
	local _, _, w, h = do_skills_randomizer_setup:text_rect()
	do_skills_randomizer_setup:set_size(w, h)
	do_skills_randomizer_setup:set_bottom(self._panel:bottom())
	do_skills_randomizer_setup:set_right(self._panel:child("SkillsRootPanel"):right() - 20)
	self._skills_randomizer_highlight = true
end

local skrr_skilltreeguinew_mousepressed = NewSkillTreeGui.mouse_pressed
function NewSkillTreeGui:mouse_pressed(button, x, y)
	if self._renaming_skill_switch then
		self:_stop_rename_skill_switch()
		return
	end
	if not self._enabled then
		return
	end
	skrr_skilltreeguinew_mousepressed(self, button, x, y)
	if button == Idstring("0") then
		if self._panel:child("do_skills_randomizer_setup"):inside(x, y) then
			if not managers or not managers.menu_component or not managers.menu_component._skilltree_gui then
				return
			end
			local SkillsRandomizer_Get = function()		
				managers.menu_component._skilltree_gui:_dialog_respec_all_yes()
				local _skilltree_table = {}
				for _tree, _data1 in pairs(tweak_data.skilltree.trees) do
					for _tier, _skills in pairs(tweak_data.skilltree.trees[_tree].tiers) do
						for _, _skill_id in pairs(_skills) do
							table.insert(
								_skilltree_table,
								{
									skill_id = _skill_id,
									tree = _tree,
									tier = _tier,
									aced = false
								}
							)
						end
					end
				end
				local _try = 1000
				while _try > 0 and table.size(_skilltree_table) > 0 do
					local _idx = math.random(table.size(_skilltree_table))
					if _skilltree_table[_idx] then
						local _ans = SKRR:do_invest(_skilltree_table[_idx].tree, _skilltree_table[_idx].skill_id, _skilltree_table[_idx].tier)
						if _skilltree_table[_idx].aced then
							_skilltree_table[_idx] = nil
						else
							_skilltree_table[_idx].aced = true
						end
					end
					_try = _try - 1
				end
				return
			end
			SkillsRandomizer_Get()
			return
		end
	end
end

function NewSkillTreeGui:check_skillsrandomizer_button(x, y, panel_name, highlight_var_name)
	local inside = false

	if x and y and self._panel:child(panel_name):inside(x, y) then
		if not self[highlight_var_name] then
			self[highlight_var_name] = true
			self._panel:child(panel_name):set_color(tweak_data.screen_colors.button_stage_2)
			managers.menu_component:post_event("highlight")
		end
		inside = true
	elseif self[highlight_var_name] then
		self[highlight_var_name] = false
		self._panel:child(panel_name):set_color(managers.menu:is_pc_controller() and tweak_data.screen_colors.button_stage_3 or Color.black)
	end

	return inside
end

local skrr_original_skilltreeguinew_mousemoved = NewSkillTreeGui.mouse_moved
function NewSkillTreeGui:mouse_moved(o, x, y)
	local inside, pointer = skrr_original_skilltreeguinew_mousemoved(self, o, x, y)

	if self._enabled then
		if self:check_skillsrandomizer_button(x, y, "do_skills_randomizer_setup", "_skills_randomizer_highlight") then
			inside = true
			pointer = "link"
		end
	end

	return inside, pointer
end