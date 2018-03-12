Hooks:PostHook(CharacterTweakData, "init", "alt_sydney_chr_init", function(self, tweak_data)
	self:_init_sydney_alt(self.presets)
end)

function CharacterTweakData:_init_sydney_alt(presets)
	self.sydney_alt = {
		damage = presets.gang_member_damage,
		weapon = deep_clone(presets.weapon.gang_member)
	}
	self.sydney_alt.weapon.weapons_of_choice = {
		primary = "wpn_fps_ass_m4_npc",
		secondary = Idstring("units/payday2/weapons/wpn_npc_mac11/wpn_npc_mac11")
	}
	self.sydney_alt.detection = presets.detection.gang_member
	self.sydney_alt.move_speed = presets.move_speed.very_fast
	self.sydney_alt.crouch_move = false
	self.sydney_alt.speech_prefix = "rb15"
	self.sydney_alt.weapon_voice = "3"
	self.sydney_alt.access = "teamAI1"
	self.sydney_alt.arrest = {
		timeout = 240,
		aggression_timeout = 6,
		arrest_timeout = 240
	}
end