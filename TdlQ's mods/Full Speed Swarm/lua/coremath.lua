if core then
	core:module("CoreMath")
end

function math.bezier(points, t)
	local p1 = points[1]
	local p2 = points[2]
	local p3 = points[3]
	local p4 = points[4]
	local t_squared = t * t
	local t_cubed = t_squared * t
	local omt = 1 - t
	local a1 = p1 * (omt * omt * omt)
	local a2 = 3 * p2 * t * omt * omt
	local a3 = 3 * p3 * t_squared * omt
	local a4 = p4 * t_cubed
	return a1 + a2 + a3 + a4
end
