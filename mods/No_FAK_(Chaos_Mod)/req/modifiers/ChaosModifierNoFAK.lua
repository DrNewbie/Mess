ChaosModifierNoFAK = ChaosModifier.class("ChaosModifierNoFAK")
ChaosModifierNoFAK.run_as_client = true
ChaosModifierNoFAK.duration = 30

function ChaosModifierNoFAK:start()
	self:post_hook(UseInteractionExt, "can_select", function(this)
		if type(this) == "table" and tostring(this.tweak_data) == "first_aid_kit" then
			return false
		end
		return Hooks:GetReturn()
	end)
end

return ChaosModifierNoFAK