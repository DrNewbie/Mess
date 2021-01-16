local func1 = "F_"..Idstring("func1:Free Internet Points (Put Melee on Gun)"):key()
local func2 = "F_"..Idstring("func2:Free Internet Points (Put Melee on Gun)"):key()
local func3 = "F_"..Idstring("func3:Free Internet Points (Put Melee on Gun)"):key()

Hooks:PostHook(FPCameraPlayerBase, "unspawn_melee_item", func1, function(self)
	if not self[func3] then
		self:spawn_melee_item()
	end
end)

Hooks:PreHook(FPCameraPlayerBase, "destroy", func2, function(self)
	self[func3] = true
end)