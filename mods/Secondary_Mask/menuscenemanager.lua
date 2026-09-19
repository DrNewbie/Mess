local ThisSavePath = ModPath.."__save_json.txt"

local mask_data_from_save = {true}
local mask_data_ready_to_apply = {}
local mask_unit_ready_to_remove = {}

local function __save()
	pcall(function()
		io.save_as_json(mask_data_from_save, ThisSavePath)
	end)
	return
end

local function __load()
	pcall(function()
		mask_data_from_save = io.load_as_json(ThisSavePath)
		if type(mask_data_from_save) ~= "table" then
			mask_data_from_save = {true}
			__save()
		end
	end)
	return
end

function MenuSceneManager:apply_character_mask_2_from_save(data)
	local owner_name = data.owner_name
	if type(owner_name) == "string" and type(mask_data_from_save[owner_name]) == "table" then
		for _, m_data in pairs(mask_data_from_save[owner_name]) do
			if type(m_data) == "table" and type(m_data.mask_id) == "string" then
				local this_data = {
					owner_name = owner_name,
					unit_name = m_data.unit_name,
					mask_id = m_data.mask_id,
					blueprint = m_data.blueprint
				}
				table.insert(mask_data_ready_to_apply, this_data)
			end
		end		
		self:add_one_frame_delayed_clbk(callback(self, self, "apply_character_mask_2"))
	end
end

function MenuSceneManager:apply_character_mask_2()
	if not managers.dyn_resource or not DynamicResourceManager or not DynamicResourceManager.DYN_RESOURCES_PACKAGE then
		return
	end
	if type(mask_data_ready_to_apply) ~= "table" then
		return
	end
	if table.empty(mask_data_ready_to_apply) then
		return
	end
	for this_key, use_this_mask_data in pairs(mask_data_ready_to_apply) do
		if type(use_this_mask_data) == "table" and not table.empty(use_this_mask_data) then
			local owner_name = use_this_mask_data.owner_name
			local unit_name = tostring(use_this_mask_data.unit_name)
			if owner_name and DB:has(Idstring("unit"), Idstring(unit_name)) then
				managers.dyn_resource:load(Idstring("unit"), Idstring(unit_name), DynamicResourceManager.DYN_RESOURCES_PACKAGE, function()
					local owner_unit = nil
					for u_key, m_data in pairs(self._mask_units) do
						if type(m_data) == "table" and m_data.unit and alive(m_data.unit) and m_data.unit:base() and m_data.unit:base():character_name() == owner_name then
							owner_unit = m_data.unit
							break
						end
					end
					if owner_unit and alive(owner_unit) then
						local mask_id = use_this_mask_data.mask_id
						local blueprint = use_this_mask_data.blueprint
						local mask_align = owner_unit:get_object(Idstring("Head"))
						local mask_unit = self:_spawn_mask(Idstring(unit_name), false, mask_align:position(), mask_align:rotation(), mask_id)
						if mask_unit and alive(mask_unit) then
							mask_unit:base():apply_blueprint(blueprint, function()
								return
							end)
							owner_unit:link(mask_align:name(), mask_unit)
							use_this_mask_data.mask_unit = mask_unit
							use_this_mask_data.mask_align = mask_align
							use_this_mask_data.character_name = self._player_character_name
							use_this_mask_data.peer_id = nil
							self:update_mask_offset(use_this_mask_data)
							self:_chk_character_visibility(owner_unit)
						end
						table.insert(mask_unit_ready_to_remove, mask_unit)
					end
					mask_data_ready_to_apply[this_key] = nil
				end)
			end
		end
	end
end

function MenuSceneManager:remove_character_mask_2()
	for this_key, remove_this_mask_unit in pairs(mask_unit_ready_to_remove) do
		if remove_this_mask_unit and alive(remove_this_mask_unit) then
			for _, linked_unit in ipairs(remove_this_mask_unit:children()) do
				linked_unit:unlink()
				World:delete_unit(linked_unit)
			end
			remove_this_mask_unit:unlink()
			World:delete_unit(remove_this_mask_unit)
		end
		mask_unit_ready_to_remove[this_key] = nil
	end
	return
end

Hooks:PostHook(MenuSceneManager, "_set_player_character_unit", "2Mask_MenuSceneManager_ReNewUnit", function(self)
	self:remove_character_mask_2()
	__load()
	self:add_one_frame_delayed_clbk(callback(self, self, "apply_character_mask_2"))
	for _, m_data in pairs(self._mask_units) do
		if type(m_data) == "table" and m_data.unit and alive(m_data.unit) and m_data.unit:base() then
			self:add_one_frame_delayed_clbk(callback(self, self, "apply_character_mask_2_from_save", {owner_name = m_data.unit:base():character_name()}))
		end
	end
end)

function MenuSceneManager:set_character_mask_2_by_id(mask_id, blueprint, owner_unit)
	mask_id = managers.blackmarket:get_real_mask_id(mask_id)	
	local unit_name = managers.blackmarket:mask_unit_name_by_mask_id(mask_id)
	owner_unit = owner_unit or self._character_unit
	if owner_unit and alive(owner_unit) and owner_unit:base() then
		local owner_name = owner_unit:base():character_name()
		local this_data = {
			owner_name = owner_name,
			unit_name = unit_name,
			mask_id = mask_id,
			blueprint = blueprint
		}
		table.insert(mask_data_ready_to_apply, this_data)
		if self._mask_units[owner_unit:key()] then
			mask_data_from_save[owner_name] = mask_data_from_save[owner_name] or {} 
			table.insert(mask_data_from_save[owner_name], this_data)
			__save()
		end
	end
end

function MenuSceneManager:clean_character_mask_2(owner_unit)
	owner_unit = owner_unit or self._character_unit
	if owner_unit and alive(owner_unit) and owner_unit:base() then
		mask_data_from_save[owner_unit:base():character_name()] = nil	
		__save()
	end
	self:remove_character_mask_2()
end