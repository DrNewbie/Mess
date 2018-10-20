local TagTeamEndP1Hook = PlayerAction.TagTeam.Function

local TagTeamEndP2Hook = PlayerAction.TagTeamTagged.Function

PlayerAction.TagTeam.Function = function (tagged, owner)
	TagTeamEndP1Hook(tagged, owner)
	managers.player:RemoveTaggedUnit(tagged)
end

PlayerAction.TagTeamTagged.Function = function (tagged, owner)
	TagTeamEndP2Hook(tagged, owner)
	managers.player:RemoveTaggedUnit(tagged)
end