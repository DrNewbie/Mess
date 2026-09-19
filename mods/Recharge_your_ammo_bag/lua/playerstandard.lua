local Ply_init_second_interact = false
local Ply_use_second_interact = false

Hooks:PostHook(PlayerStandard, "init", "AddSecondInteract2AmmoBag", function(self)
	if Input and Input:keyboard() and not Ply_init_second_interact then
		Ply_init_second_interact = true
		Ply_use_second_interact = false
		Input:keyboard():add_trigger(Idstring("f9"), callback(self, self, "change_second_interact"))
	end
end)

function PlayerStandard:change_second_interact()
	if Ply_use_second_interact then
		Ply_use_second_interact = false
	else
		Ply_use_second_interact = true
	end
end

function PlayerStandard:use_second_interact()
	return Ply_use_second_interact and true or false
end