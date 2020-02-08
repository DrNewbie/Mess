local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local pgt_original_civilianlogicescort_updpathing = CivilianLogicEscort._upd_pathing
function CivilianLogicEscort._upd_pathing(data, my_data)
	if my_data.processing_coarse_path and data.pathing_results and data.unit:base().pgt_destination then
		local path = data.pathing_results[my_data.coarse_path_search_id]
		if type(path) == 'table' then
			data.pgt_nav_segs = {}
			for i, step in ipairs(path) do
				data.pgt_nav_segs[i] = step[1]
			end
		end
	end

	pgt_original_civilianlogicescort_updpathing(data, my_data)
end
