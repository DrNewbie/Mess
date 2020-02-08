local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

core:module("CoreElementShape")

function ElementShape:is_inside(pos)
	for _, shape in ipairs(self._shapes) do
		if shape:fs_is_inside(pos) then
			return true
		end
	end
	return false
end
