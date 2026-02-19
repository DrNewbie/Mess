local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()

local __Name = function(__id)
	return "YYY_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end

if _G[__Name(101)] then return end
_G[__Name(101)] = true

local __io = io

local loaded_data = __Name(2)

local last_icon = __Name(102)

local last_icon_path = __Name(103)

local last_bar_width = __Name(104)

_G[loaded_data] = _G[loaded_data] or {}

_G[last_icon] = nil

_G[last_icon_path] = nil

_G[last_bar_width] = 0

local function __set_current_interact(this_data)
	if type(this_data) ~= "table" and type(this_data.them) ~= "table" and type(this_data.them_icon) ~= "string" and type(this_data.them_valid) ~= "boolean" then
		return
	end

	local __type_select = "basic"
	
	local __name_to_type = {
		["equipment_doctor_bag"] = "medic_bag",
		["medic_bag"] = "medic_bag",
		["doctor_bag"] = "medic_bag",
		["equipment_ammo_bag"] = "ammo_bag",
		["ammo_bag"] = "ammo_bag"
	}
	
	__type_select = __name_to_type[tostring(this_data.them_icon)] or "basic"
	
	if type(_G[loaded_data][__type_select]) == "table" and not table.empty(_G[loaded_data][__type_select]) then
		local This_Img_Path = table.random(_G[loaded_data][__type_select])
		local is_same_one = false
		if type(_G[last_icon]) == "string" and _G[last_icon] == __type_select then
			is_same_one = true
			This_Img_Path = _G[last_icon_path] or This_Img_Path
		else
			_G[last_icon] = __type_select
		end
		_G[last_icon_path] = This_Img_Path
		if this_data.them._interact_circle then
			local this_texture = this_data.them_valid and __Name(This_Img_Path.."active.texture") or __Name(This_Img_Path.."invalid.texture")
			this_data.them._interact_circle:set_image(this_texture)
			if this_data.them._interact_circle._bg_circle then
				this_data.them._interact_circle._bg_circle:set_image(__Name(This_Img_Path.."bg.texture"))
			end
		end
	end
	
	return
end

local function __get_current_interact(this_data)
	local them = this_data.them or nil
	local valid = this_data.valid or false
	if not them then
		return
	end
	
	local player = managers.player:local_player()
	if not player or not alive(player) then
		return
	end
	
	if not player:movement() or not player:movement():current_state() then
		return
	end
	local player_state = player:movement():current_state()
	
	local is_deploying = player_state:is_deploying() or false
	if is_deploying then
		local equipment_data = managers.player:selected_equipment()
		if type(equipment_data) == "table" and type(equipment_data.equipment) == "string" then
			pcall(__set_current_interact, {them = them, them_icon = equipment_data.equipment, them_valid = valid})
		end
		return
	end
	
	local is_interacting = player_state:_interacting() or false
	if is_interacting and type(player_state._interact_params.object:interaction().tweak_data) == "string" then
		pcall(__set_current_interact, {them = them, them_icon = player_state._interact_params.object:interaction().tweak_data, them_valid = true})
	end
	
	return
end

Hooks:PostHook(HUDInteraction, "show_interact", __Name("show_interact:101"), function(self, ...)
	pcall(__get_current_interact, {them = self, valid = true})
end)

Hooks:PostHook(HUDInteraction, "set_bar_valid", __Name("set_bar_valid:101"), function(self, valid, ...)
	pcall(__get_current_interact, {them = self, valid = valid})
end)

Hooks:PreHook(HUDInteraction, "set_interaction_bar_width", __Name("PreHook:set_interaction_bar_width:101"), function(self, current, ...)
	if current < _G[last_bar_width] then
		_G[last_icon] = nil
	end
	_G[last_bar_width] = current
end)

Hooks:PostHook(HUDInteraction, "set_interaction_bar_width", __Name("PostHook:set_interaction_bar_width:101"), function(self, current, ...)
	pcall(__get_current_interact, {them = self, valid = true})
end)