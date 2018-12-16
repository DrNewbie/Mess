local SSTOMB_ModPath = ModPath

function MenuSceneManager:addon_spawn_on_menu(data)
	self._addon_spawn_on_menu = self._addon_spawn_on_menu or {}
	local u_key = data.key or tostring(data.unit:key())
	if self._addon_spawn_on_menu[u_key] then
		if alive(self._addon_spawn_on_menu[u_key]) then
			self._addon_spawn_on_menu[u_key]:set_slot(0)
		end
	end
	self._addon_spawn_on_menu[u_key] = World:spawn_unit(data.unit, data.attach:position() + (data.pos or Vector3(0, 0, 0)), data.rot or Rotation(-45, 0, 0))
end

Hooks:PostHook(MenuSceneManager, "_setup_bg", "SpawnAddonItemsEventNow", function(self)    
	local rrfile = io.open(SSTOMB_ModPath.."configs.json", "r")
	local rrdata
	local spawn_list = {}
	if rrfile then
		local rrcurrent = rrfile:seek()
		local rrsize = rrfile:seek("end")
		rrfile:seek("set", rrcurrent)
		if rrsize > 1 then
			spawn_list = json.decode(tostring(rrfile:read("*all")))
		end
		for _, data in pairs(spawn_list) do
			if data and data.unit then
				data.unit = Idstring(data.unit)
				data.pos = data.pos and data.pos:ToVector3() or Vector3(70, 200, 0)
				if data.rot then
					local rott = string.split(data.rot, ",")
					data.rot = Rotation(tonumber(rott[1]), tonumber(rott[2]), tonumber(rott[3]))
				else
					data.rot = Rotation(-45, 0, 0)
				end
			end
		end
		rrfile:close()
	end
	if type(spawn_list) ~= "table" or table.size(spawn_list) < 1 then
		while true do
			local safe_name = table.random_key(tweak_data.economy.safes)
			if tweak_data.economy.safes[safe_name].unit_name then
				table.insert(spawn_list, {
					unit = Idstring(tweak_data.economy.safes[safe_name].unit_name),
					pos = Vector3(70, 200, 0),
					rot = Rotation(-45, 0, 0)
				})
				break
			end
		end
	end
	
	local a = self._bg_unit:get_object(Idstring("a_reference"))

	for _, data in pairs(spawn_list) do
		if data and data.unit and DB:has(Idstring("unit"), data.unit) then
			data.attach = a
			if not managers.dyn_resource:is_resource_ready(Idstring("unit"), data.unit, managers.dyn_resource.DYN_RESOURCES_PACKAGE) then
				managers.dyn_resource:load(Idstring("unit"), data.unit, managers.dyn_resource.DYN_RESOURCES_PACKAGE, callback(self, self, "addon_spawn_on_menu", data))
			else
				self:addon_spawn_on_menu(data)
			end
		end
	end
end)