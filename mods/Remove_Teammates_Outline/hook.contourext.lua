local Remove_add = ContourExt.add

function ContourExt:add(type, ...)
	if type ~= "teammate" and type ~= "teammate_downed" and type ~= "teammate_dead" and type ~= "teammate_cuffed" and type ~= "teammate_downed_selected" then
		return Remove_add(self, type, ...)
	end
end