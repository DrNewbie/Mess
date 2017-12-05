local Remove_add = ContourExt.add

function ContourExt:add(type, ...)
  if type ~= "teammate" then
    return Remove_add(self, type, ...)
  end
end
