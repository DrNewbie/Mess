local ThisModPath = ModPath
local mod_ids = Idstring(ThisModPath):key()
local func1 = "F_"..Idstring("func1::"..mod_ids):key()
local func2 = "F_"..Idstring("func2::"..mod_ids):key()
local func3 = "F_"..Idstring("func3::"..mod_ids):key()
local func4 = "F_"..Idstring("func4::"..mod_ids):key()

local function __Kleptomaniac(them, list)
	local pickups = World:find_units_quick("sphere", them._unit:movement():m_pos(), 200, 1) or {}
	if type(pickups) == "table" and #pickups > 0 then
		for _, pickup in pairs(pickups) do
			if type(pickup.interaction) == "function" and pickup:interaction() and type(pickup:interaction().tweak_data) == "string" and (not list or (type(list) == "table" and list[pickup:interaction().tweak_data])) then
				local pick_inter = pickup:interaction()
				local pick_tweak = pick_inter.tweak_data
				if not tweak_data.interaction[pick_tweak] or tweak_data.interaction[pick_tweak].timer then
				
				else
					if pick_inter:can_select(them._unit) and pick_inter:can_interact(them._unit) and not pick_inter:_interact_blocked(them._unit) and pick_inter:active() and not pick_inter:disabled() then
						pick_inter:interact(them._unit)
						return
					end
				end
			end
		end
	end
end

Hooks:PostHook(PlayerStandard, "_update_check_actions", func1, function(self, t, dt)
	if self[func3] then
		self[func3] = false
	else
		self[func3] = true
		__Kleptomaniac(self)
	end
end)

Hooks:PostHook(PlayerCarry, "_update_check_actions", func2, function(self, t, dt)
	if self[func4] then
		self[func4] = false
	else
		self[func4] = true
		__Kleptomaniac(self)
	end
end)