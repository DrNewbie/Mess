local mod_ids = Idstring("Fully Loaded Crafting System"):key()
local __using_dt = "__d_"..Idstring("__using_dt:"..mod_ids):key()
local __using_ft = "__d_"..Idstring("__using_ft:"..mod_ids):key()
local __take_ammo_dt = "__d_"..Idstring("__take_ammo_dt:"..mod_ids):key()


function PlayerManager:__use_fully_loaded_crafting_system()
	if not Utils or not Utils:IsInHeist() then
		return
	end
	if not self[__using_dt] then
		self[__take_ammo_dt] = 1
		self[__using_ft] = 8
		self[__using_dt] = self[__using_ft]
	end
end