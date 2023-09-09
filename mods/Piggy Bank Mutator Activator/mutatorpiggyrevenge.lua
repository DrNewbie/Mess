local ThisModPath = ModPath

if not MutatorHelper or not MutatorPiggyRevenge then
	return
end

MutatorPiggyRevengeAlt = MutatorPiggyRevengeAlt or class(MutatorPiggyRevenge)

MutatorPiggyRevengeAlt.name_id = "mutator_piggyrevengealt"

MutatorPiggyRevengeAlt.categories = {
	"gameplay"
}

MutatorPiggyRevengeAlt.texture = {
    path = "piggybankmutator",
    custom = true
}

pcall(function()
	if not _G[Idstring("MutatorPiggyRevengeAlt")]  then
		_G[Idstring("MutatorPiggyRevengeAlt")] = true
		MutatorHelper:AddMutator(MutatorPiggyRevengeAlt, ThisModPath)
	end
end)