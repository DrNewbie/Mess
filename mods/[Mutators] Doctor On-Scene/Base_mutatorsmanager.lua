_G.TMP_mutator_saving = _G.TMP_mutator_saving or {}

Hooks:PostHook(MutatorsManager, "init", "MutatorDoctorOnScene_MutatorsManagerInit", function(mm)
	table.insert(mm._mutators, MutatorDoctorOnScene:new(mm))
	TMP_mutator_saving:New_Mutators_Init(mm)
end )