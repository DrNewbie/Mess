local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local fs_original_actionspooc_init = ActionSpooc.init
function ActionSpooc:init(action_desc, common_data)
	if Network:is_client() then
		local attention = common_data.ext_movement:attention()
		if attention and alive(attention.unit) and not attention.unit:base() then
			log('[FSS][ActionSpooc:init] attack cancelled due to invalid target: ' .. tostring(attention.unit))
			return
		end
	end

	self.fs_move_speed = CopActionWalk.fs_move_speeds[common_data.ext_base._tweak_table][common_data.stance.name]['run']

	return fs_original_actionspooc_init(self, action_desc, common_data)
end

ActionSpooc._get_current_max_walk_speed = CopActionWalk._get_current_max_walk_speed
