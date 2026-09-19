Hooks:PostHook(MutatorItem, "init", "MutatorDoctorOnScene_MutatorItemIcon", function(mm, parent_panel, mutator, index)
	local _mutator_id = tostring(mutator:id())
	if _mutator_id == "MutatorDoctorOnScene" then
		mm._icon = mm._icon_panel:bitmap({
			name = "icon",
			texture = "guis/textures/pd2/skilltree_2/icons_atlas_2",
			texture_rect = {
				80,
				880,
				80,
				80
			},
			blend_mode = "add",
			alpha = mm:icon_alpha(),
			w = mm._icon_panel:w(),
			h = mm._icon_panel:h()
		})
		mm:refresh()
	end
end )