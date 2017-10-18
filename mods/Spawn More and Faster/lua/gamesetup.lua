Hooks:PostHook(GameSetup, "init_game", "SMF_GameSetup_init_game", function(self)
	if managers.mutators:is_mutator_active(MutatorBigParty) then
		return
	end
	local FakeBigParty = managers.mutators:get_mutator(MutatorBigParty)
	if FakeBigParty then
		FakeBigParty:register_value("insanity_level", 2, "dm")
		FakeBigParty:set_value("insanity_level", 2)
		FakeBigParty:setup()
	end
end)