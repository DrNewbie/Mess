local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local fs_original_modifiersmanager_init = ModifiersManager.init
function ModifiersManager:init()
	fs_original_modifiersmanager_init(self)
	ModifiersManager.fs_original_modify_value = ModifiersManager.modify_value
	ModifiersManager.modify_value = ModifiersManager.fs_dont_modify_value
end

local fs_original_modifiersmanager_addmodifier = ModifiersManager.add_modifier
function ModifiersManager:add_modifier(modifier, category)
	ModifiersManager.modify_value = ModifiersManager.fs_original_modify_value
	return fs_original_modifiersmanager_addmodifier(self, modifier, category)
end

function ModifiersManager:fs_dont_modify_value(id, value)
	return value
end
