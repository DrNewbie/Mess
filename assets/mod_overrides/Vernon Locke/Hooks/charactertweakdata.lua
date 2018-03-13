Hooks:PostHook(CharacterTweakData, "init", "locke_player_chr_init", function(self, tweak_data)
	self:_init_locke_player(self.presets)
end)

function CharacterTweakData:_init_locke_player(presets)
	self.locke_player = {
		damage = presets.gang_member_damage,
		weapon = deep_clone(presets.weapon.gang_member)
	}
	self.locke_player.weapon.weapons_of_choice = {
		primary = "wpn_fps_ass_m4_npc",
		secondary = Idstring("units/payday2/weapons/wpn_npc_mac11/wpn_npc_mac11")
	}
	self.locke_player.detection = presets.detection.gang_member
	self.locke_player.move_speed = presets.move_speed.very_fast
	self.locke_player.crouch_move = false
	self.locke_player.speech_prefix = "rb2"
	self.locke_player.weapon_voice = "3"
	self.locke_player.access = "teamAI1"
	self.locke_player.arrest = {
		timeout = 240,
		aggression_timeout = 6,
		arrest_timeout = 240
	}
end