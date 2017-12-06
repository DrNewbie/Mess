local Remove_add = ContourExt.add
local ROL_setup = "teammate" or "teammate_downed" or "teammate_dead" or "teammate_cuffed" or "teammate_downed_selected"

function ContourExt:add(type, ...)
  if type ~= "ROL_setup" then
    return Remove_add(self, type, ...)
  end
end
