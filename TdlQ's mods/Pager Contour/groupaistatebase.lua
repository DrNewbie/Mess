local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local pc_clbk = 'pc_clbk_on_police_called'

local pc_original_groupaistatebase_init = GroupAIStateBase.init
function GroupAIStateBase:init()
	pc_original_groupaistatebase_init(self)
	self:add_listener(pc_clbk, {'police_called'}, callback(self, self, pc_clbk))
end

function GroupAIStateBase:pc_clbk_on_police_called()
	self:remove_listener(pc_clbk)
	for u_key, u_data in pairs(managers.enemy._enemy_data.corpses) do
		if alive(u_data.unit) then
			u_data.unit:contour():remove('friendly')
		end
	end
	for u_key, u_data in pairs(managers.enemy:all_enemies()) do
		if alive(u_data.unit) then
			u_data.unit:contour():remove('friendly')
		end
	end
end
