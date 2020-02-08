local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local mtga_original_interactiontweakdata_init = InteractionTweakData.init
function InteractionTweakData:init(...)
	mtga_original_interactiontweakdata_init(self, ...)

	self.drill_tank = {}
	self.drill_tank.action_text_id = 'hud_action_placing_drill'
	self.drill_tank.axis = 'y'
	self.drill_tank.force_update_position = true
	self.drill_tank.icon = 'equipment_drill'
	self.drill_tank.interact_distance = 250
	self.drill_tank.interaction_obj = Idstring("Spine2")
	self.drill_tank.sound_start = 'bar_secure_winch'
	self.drill_tank.sound_interupt = 'bar_secure_winch_cancel'
	self.drill_tank.sound_done = 'bar_secure_winch_finished'
	self.drill_tank.text_id = 'hud_int_equipment_drill'
	self.drill_tank.timer = 1.5
	self.drill_tank.requires_upgrade = {
		category = 'player',
		upgrade = 'drill_melee_hit_restart_chance'
	}
end
