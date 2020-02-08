local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local function _modify_node(node, except_name)
	local old_items = node:items()

	local except_item
	if except_name then
		for k, item in pairs(old_items) do
			if item:parameters().name == except_name then
				except_item = table.remove(old_items, k)
				break
			end
		end
	end

	node:clean_items()

	if except_item then
		node:add_item(except_item)
	end

	table.sort(old_items, function(a, b)
		local text_a = managers.localization:text(a:parameters().text_id)
		local text_b = managers.localization:text(b:parameters().text_id)
		return string.lower(text_a) < string.lower(text_b)
	end)

	for _, item in pairs(old_items) do
		node:add_item(item)
	end

	return node
end

local function _modify_node_blt_options(node)
	return _modify_node(node, 'blt_localization_choose')
end

Hooks:Add('MenuManagerBuildCustomMenus', 'MenuManagerBuildCustomMenus_AlphasortMods', function(menu_manager, nodes)
	nodes['blt_options']:parameters().modifier = {_modify_node_blt_options}
end)

function BLTModManager:AlphasortedMods()
	local mods = clone(self.mods)
	table.sort(mods, function(a, b)
		return string.lower(a:GetName()) < string.lower(b:GetName())
	end)
	return mods
end

local am_original_bltmodsgui_setup = BLTModsGui._setup
function BLTModsGui:_setup()
	local original_function = BLTModManager.Mods
	BLTModManager.Mods = BLTModManager.AlphasortedMods
	am_original_bltmodsgui_setup(self)
	BLTModManager.Mods = original_function
end
