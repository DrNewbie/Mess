local mod_ids = Idstring("Skills Randomizer"):key()
local func1 = "F_"..Idstring("func1::"..mod_ids):key()
local func2 = "F_"..Idstring("func2::"..mod_ids):key()
local func3 = "F_"..Idstring("func3::"..mod_ids):key()
local func4 = "F_"..Idstring("func4::"..mod_ids):key()
local func5 = "F_"..Idstring("func5::"..mod_ids):key()
local func6 = "F_"..Idstring("func6::"..mod_ids):key()
local func7 = "F_"..Idstring("func7::"..mod_ids):key()
local func8 = "F_"..Idstring("func8::"..mod_ids):key()
local func9 = "F_"..Idstring("func9::"..mod_ids):key()
local funcB = "F_"..Idstring("funcB::"..mod_ids):key()

Hooks:PostHook(NewSkillTreeGui, "_setup", func2, function(self)
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
end)

Hooks:PostHook(NewSkillTreeGui, "mouse_pressed", func3, function(self, button, x, y)
	if not self._renaming_skill_switch and self._enabled and button == Idstring("0") then
		if self._panel:child("do_skills_randomizer_setup"):inside(x, y) then
			self:_dialog_respec_all_yes()
			local all_items = {}
			local now_tree
			for i = 1, #self._tab_items do
				now_tree = self._tree_items[i]
				local get_trees, get_tiers, get_skills
				if type(now_tree._trees) == "table" then
					for __i, __d in pairs(now_tree._trees) do
						if type(__d._tiers) == "table" then
							for __ii, __dd in pairs(__d._tiers) do
								if type(__dd._skills_ordered) == "table" then
									for __iii, __ddd in pairs(__dd._skills_ordered) do
										table.insert(all_items, {
											__page = i,
											__trees = __i,
											__tiers = __ii,
											__skills_ordered = __ddd
										})
									end
								end
							end
						end
					end
				end
			end
			self[func4] = true
			self[func9] = 0.05
			self[func6] = self[func9]
			self[funcB] = 1000
			self[func7] = self[funcB]
			self[func8] = all_items
		end
	end
end)

Hooks:PostHook(NewSkillTreeGui, "update", func5, function(self, t, dt)
	if self[func4] then
		if type(self[func6]) == "number" and self[func6] > 0 then
			self[func6] = self[func6] - dt
		else
			self[func6] = self[func9]
			if type(self[func7]) == "number" and self[func7] > 0 then
				self[func7] = self[func7] - 1
				local all_items, rnd_pick, now_tree, item
				all_items = self[func8]
				rnd_pick = math.random(1, #all_items)
				get_pick = all_items[rnd_pick]
				self:set_active_page(get_pick.__page)
				now_tree = self._tree_items[self._active_page]
				item = now_tree:item(get_pick.__trees, get_pick.__tiers, get_pick.__skills_ordered)
				if item then
					self:set_selected_item(item, true)
					self:invest_point(item)
					if math.random() > 0.6 then
						self:refund_point(item)
					end
					item = nil
				end
			else
				self[func4] = false
			end
		end
	end
end)

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

local old_skrr_mousemoved = NewSkillTreeGui.mouse_moved
function NewSkillTreeGui:mouse_moved(o, x, y, ...)
	local inside, pointer = old_skrr_mousemoved(self, o, x, y, ...)
	if self._enabled then
		if self:check_skillsrandomizer_button(x, y, "do_skills_randomizer_setup", "_skills_randomizer_highlight") then
			inside = true
			pointer = "link"
		end
	end
	return inside, pointer
end