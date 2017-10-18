Hooks:PostHook(GameSetup, "init_game", "SMF_GameSetup_init_game", function(self)
	if managers.mutators:is_mutator_active(MutatorBigParty) then
		return
	end
	local FakeBigParty = managers.mutators:get_mutator(MutatorBigParty)
	if FakeBigParty then
		FakeBigParty:setup()
		FakeBigParty:clear_values()
		FakeBigParty:reset_to_default()
		FakeBigParty:set_value("insanity_level", 2.25)
		FakeBigParty:modify_tweak_data()
		FakeBigParty:modify_character_tweak_data()
	end
end)