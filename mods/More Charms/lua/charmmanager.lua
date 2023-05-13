local ThisModPath = ModPath

local __Name = function(__id)
	return "CCC_"..Idstring(tostring(__id).."::"..ThisModPath):key()
end

local part_factory = tweak_data.weapon.factory.parts
local weapon_charms = tweak_data.blackmarket.weapon_charms

local __addon_charms = {}

local __new_charms = {}

local function __Save()
	local save_files = io.open(ThisModPath.."/SaveFiles.json", "w+")
	if save_files then
		save_files:write(json.encode(__addon_charms))
		save_files:close()
	end
	return
end

local function __Load()
	local save_files = io.open(ThisModPath.."/SaveFiles.json", "r")
	if save_files then
		__addon_charms = json.decode(save_files:read("*all"))
		save_files:close()
		if type(__addon_charms) ~= "table" or table.empty(__addon_charms) then
			__addon_charms = {true}
		end
	else
		__addon_charms = {true}
	end
	pcall(__Save)
	return
end

local function __remove_charms()
	for __i, __unit in pairs(__new_charms) do
		if __unit and alive(__unit) then
			__unit:set_slot(0)
		end
		if __unit and alive(__unit) then
			World:delete_unit(__unit)
		end
		__new_charms[__i] = nil
	end
	return
end

local function __add_charms(__wep)
	if not __wep or not alive(__wep) or not __wep:base() then
	
	else
		local charm_data = __wep:base():charm_data()
		if type(__addon_charms) == "table" and type(charm_data) == "table" then
			local this_charm_data
			for _, c_data in pairs(charm_data) do
				if type(c_data) == "table" and c_data.unit and alive(c_data.unit) then
					this_charm_data = c_data
				end
			end
			local this_unit = this_charm_data.unit
			for __id, w_data in pairs(__addon_charms) do
				local __data = part_factory[w_data]
				if type(__data) == "table" and type(__data.unit) == "string" and DB:has(Idstring("unit"), Idstring(__data.unit)) then
					managers.dyn_resource:load(Idstring("unit"), Idstring(__data.unit), managers.dyn_resource.DYN_RESOURCES_PACKAGE, function()
						local new_one = World:spawn_unit(Idstring(__data.unit), this_unit:position(), Rotation())
						if new_one and alive(new_one) then
							__new_charms[new_one:key()] = new_one
							local charm_body = this_unit:get_object(Idstring("g_charm"))
							if charm_body then
								this_unit:link(charm_body:name(), new_one, new_one:orientation_object():name())
								this_unit = new_one
							end
						end
					end)
				end
			end
		end
	end
	return
end

Hooks:PostHook(CharmManager, "init", __Name("init"), function(...)
	for __id, w_data in pairs(weapon_charms) do
		local __data = part_factory[w_data]
		if type(__data) == "table" and type(__data.unit) == "string" and DB:has(Idstring("unit"), Idstring(__data.unit)) then
			managers.dyn_resource:load(Idstring("unit"), Idstring(__data.unit), managers.dyn_resource.DYN_RESOURCES_PACKAGE, nil)
		end
	end
end)

Hooks:PostHook(CharmManager, "add_weapon", __Name("add_weapon"), function(self, __weapon_unit, __parts, __user_unit, __is_menu, __custom_params)
	pcall(__remove_charms)
	pcall(__add_charms, __weapon_unit)
end)

pcall(__Load)