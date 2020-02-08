local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

core:module('CoreShapeManager')

local mvec3_add = mvector3.add
local mvec3_copy = mvector3.copy
local mvec3_dis = mvector3.distance
local mvec3_dis_sq = mvector3.distance_sq
local mvec3_dot = mvector3.dot
local mvec3_mul = mvector3.multiply
local mvec3_set = mvector3.set
local mvec3_set_x = mvector3.set_x
local mvec3_set_y = mvector3.set_y
local mvec3_set_z = mvector3.set_z
local mvec3_sub = mvector3.subtract
local mvec1 = Vector3()
local mvec2 = Vector3()
local mvec3 = Vector3()
local mposition = Vector3()

local fs_really_original_shapebox_isinside = ShapeBox.is_inside
function ShapeBox:is_inside(pos)
	local properties = self._properties
	local cache = self.fs_cache_for_is_inside
	if not cache then
		cache = {}
		self.fs_cache_for_is_inside = cache
		cache.position = self:position()
		local rot = self:rotation()
		cache.x = rot:x()
		cache.y = rot:y()
		cache.z = rot:z()
	end

	mvec3_set(mvec1, pos)
	mvec3_sub(mvec1, cache.position)
	local inside = mvec3_dot(cache.x, mvec1)
	if inside > 0 and inside < properties.width then
		inside = mvec3_dot(cache.y, mvec1)
		if inside > 0 and inside < properties.depth then
			inside = mvec3_dot(cache.z, mvec1)
			if inside > 0 and inside < properties.height then
				return true
			end
		end
	end
	return false
end

local fs_really_original_shapeboxmiddle_isinside = ShapeBoxMiddle.is_inside
function ShapeBoxMiddle:is_inside(pos)
	local properties = self._properties
	local cache = self.fs_cache_for_is_inside
	if not cache then
		local rot = self:rotation()
		local x = Vector3()
		local y = Vector3()
		local z = Vector3()
		mrotation.x(rot, x)
		mvec3_mul(x, properties.width / 2)
		mrotation.y(rot, y)
		mvec3_mul(y, properties.depth / 2)
		mrotation.z(rot, z)
		mvec3_mul(z, properties.height / 2)
		local position = Vector3()
		mvector3.set(position, self:position())
		mvec3_sub(position, x)
		mvec3_sub(position, y)
		mvec3_sub(position, z)
		local pos_dir = position
		mvec3_mul(pos_dir, -1)

		cache = {}
		self.fs_cache_for_is_inside = cache
		cache.pos_dir = pos_dir
		mrotation.x(rot, x)
		cache.x = x
		mrotation.y(rot, y)
		cache.y = y
		mrotation.z(rot, z)
		cache.z = z
	end

	local pos_dir = mposition
	mvec3_set(pos_dir, cache.pos_dir)
	mvec3_add(pos_dir, pos)
	local inside = mvec3_dot(cache.x, pos_dir)
	if inside > 0 and inside < properties.width then
		inside = mvec3_dot(cache.y, pos_dir)
		if inside > 0 and inside < properties.depth then
			inside = mvec3_dot(cache.z, pos_dir)
			if inside > 0 and inside < properties.height then
				return true
			end
		end
	end
	return false
end

local fs_really_original_shapeboxmiddlebottom_isinside = ShapeBoxMiddleBottom.is_inside
function ShapeBoxMiddleBottom:is_inside(pos)
	local properties = self._properties
	local cache = self.fs_cache_for_is_inside
	if not cache then
		local rot = self:rotation()
		local x = rot:x() * properties.width / 2
		local y = rot:y() * properties.depth / 2
		local position = self:position() - x - y

		cache = {}
		self.fs_cache_for_is_inside = cache
		cache.position = position
		mrotation.x(rot, x)
		cache.x = x
		mrotation.y(rot, y)
		cache.y = y
		mrotation.z(rot, z)
		cache.z = z
	end

	local pos_dir = pos - cache.position
	local inside = mvec3_dot(cache.x, pos_dir)
	if inside > 0 and inside < properties.width then
		inside = mvec3_dot(cache.y, pos_dir)
		if inside > 0 and inside < properties.depth then
			inside = mvec3_dot(cache.z, pos_dir)
			if inside > 0 and inside < properties.height then
				return true
			end
		end
	end
	return false
end

local fs_really_original_shapecylindermiddle_isinside = ShapeCylinderMiddle.is_inside
function ShapeCylinderMiddle:is_inside(pos)
	local properties = self._properties
	local cache = self.fs_cache_for_is_inside
	if not cache then
		local rot = self:rotation()
		local z = Vector3()
		local to = Vector3()
		mrotation.z(rot, z)
		mvec3_set(to, z)
		mvec3_mul(z, properties.height / 2)
		local position = Vector3()
		mvec3_set(position, self:position())
		mvec3_sub(position, z)
		local pos_dir = Vector3()
		mvec3_set(pos_dir, position)
		mvec3_mul(pos_dir, -1)
		mvec3_mul(to, properties.height)
		mvec3_add(to, position)

		cache = {}
		self.fs_cache_for_is_inside = cache
		cache.position = position
		cache.pos_dir = pos_dir
		mrotation.z(rot, z)
		cache.z = z
		cache.to = to
	end

	local pos_dir = mvec1
	mvec3_set(pos_dir, cache.pos_dir)
	mvec3_add(pos_dir, pos)
	local inside = mvec3_dot(cache.z, pos_dir)
	if inside > 0 and inside < properties.height then
		if math.distance_to_segment(pos, cache.position, cache.to) <= properties.radius then
			return true
		end
	end
	return false
end

local fs_original_shapebox_isinside = ShapeBox.is_inside
local fs_original_shapeboxmiddle_isinside = ShapeBoxMiddle.is_inside
local fs_original_shapeboxmiddlebottom_isinside = ShapeBoxMiddleBottom.is_inside
local fs_original_shapecylinder_isinside = ShapeCylinder.is_inside
local fs_original_shapecylindermiddle_isinside = ShapeCylinderMiddle.is_inside

local function _points_are_in_the_same_navseg(positions)
	if #positions == 0 then
		return
	end
	local qf = managers.navigation._quad_field
	local navseg = qf:find_nav_segment(positions[1], true)
	for _, position in ipairs(positions) do
		if navseg ~= qf:find_nav_segment(position, true) then
			return
		end
	end
	return navseg
end

function Shape:reset_bounds()
	self.fs_cache_for_is_inside = nil
	local fs_type = self.fs_type
	local pos = self:position()
	local rot = self:rotation()
	local props = self._properties
	local perimeter = {}

	if fs_type == 'ShapeBox' then
		local r = math.max(math.abs(props.width), math.abs(props.depth), math.abs(props.height))
		self._center_pos = pos + rot:x() * props.width / 2 + rot:y() * props.depth / 2 + rot:z() * props.height / 2
		self._bounding_radius = math.sqrt(3) * r / 2
		self.fs_is_inside = self._unit and fs_really_original_shapebox_isinside or (self._bounding_radius < 200 and self.fs_is_inside_no_unit or ShapeBox.is_inside)
		perimeter[1] = pos
		perimeter[2] = pos + rot:y() * props.depth
		perimeter[3] = pos + rot:x() * props.width
		perimeter[4] = pos + rot:x() * props.width + rot:y() * props.depth
		perimeter[5] = mvec3_copy(perimeter[1]) + rot:z() * props.height
		perimeter[6] = mvec3_copy(perimeter[2]) + rot:z() * props.height
		perimeter[7] = mvec3_copy(perimeter[3]) + rot:z() * props.height
		perimeter[8] = mvec3_copy(perimeter[4]) + rot:z() * props.height

	elseif fs_type == 'ShapeBoxMiddle' then
		local r = math.max(math.abs(props.width), math.abs(props.depth), math.abs(props.height))
		self._center_pos = pos
		self._bounding_radius = math.sqrt(3) * r / 2
		self.fs_is_inside = self._unit and fs_really_original_shapebox_isinside or (self._bounding_radius < 200 and self.fs_is_inside_no_unit or ShapeBoxMiddle.is_inside)
		perimeter[1] = pos + rot:x() * props.width / 2 + rot:y() * props.depth / 2 - rot:z() * props.height / 2
		perimeter[2] = pos - rot:x() * props.width / 2 - rot:y() * props.depth / 2 - rot:z() * props.height / 2
		perimeter[3] = pos + rot:x() * props.width / 2 - rot:y() * props.depth / 2 - rot:z() * props.height / 2
		perimeter[4] = pos - rot:x() * props.width / 2 + rot:y() * props.depth / 2 - rot:z() * props.height / 2
		perimeter[5] = mvec3_copy(perimeter[1]) + rot:z() * props.height
		perimeter[6] = mvec3_copy(perimeter[2]) + rot:z() * props.height
		perimeter[7] = mvec3_copy(perimeter[3]) + rot:z() * props.height
		perimeter[8] = mvec3_copy(perimeter[4]) + rot:z() * props.height

	elseif fs_type == 'ShapeBoxMiddleBottom' then
		local r = math.max(math.abs(props.width), math.abs(props.depth), math.abs(props.height))
		self._center_pos = pos + rot:z() * props.height / 2
		self._bounding_radius = math.sqrt(3) * r / 2
		self.fs_is_inside = self._unit and fs_really_original_shapeboxmiddlebottom_isinside or self.fs_is_inside_no_unit
		perimeter[1] = pos + rot:x() * props.width / 2 + rot:y() * props.depth / 2
		perimeter[2] = pos - rot:x() * props.width / 2 - rot:y() * props.depth / 2
		perimeter[3] = pos + rot:x() * props.width / 2 - rot:y() * props.depth / 2
		perimeter[4] = pos - rot:x() * props.width / 2 + rot:y() * props.depth / 2
		perimeter[5] = mvec3_copy(perimeter[1]) + rot:z() * props.height
		perimeter[6] = mvec3_copy(perimeter[2]) + rot:z() * props.height
		perimeter[7] = mvec3_copy(perimeter[3]) + rot:z() * props.height
		perimeter[8] = mvec3_copy(perimeter[4]) + rot:z() * props.height

	elseif fs_type == 'ShapeCylinder' then
		local r = props.radius
		local h = props.height / 2
		self._center_pos = pos + rot:z() * h
		self._bounding_radius = math.sqrt(r * r + h * h)
		self.fs_is_inside = self._unit and fs_original_shapecylinder_isinside or self.fs_is_inside_no_unit
		local da = 20
		for i = 0, 17 do
			local tmp_vec1 = Vector3()
			mvec3_set(tmp_vec1, pos)
			mvec3_set_x(tmp_vec1, tmp_vec1.x + math.cos(i * da) * props.radius)
			mvec3_set_y(tmp_vec1, tmp_vec1.y + math.sin(i * da) * props.radius)
			table.insert(perimeter, tmp_vec1)
			local tmp_vec2 = Vector3()
			mvec3_set(tmp_vec2, tmp_vec1 + rot:z() * props.height)
			table.insert(perimeter, tmp_vec2)
		end

	elseif fs_type == 'ShapeCylinderMiddle' then
		local r = props.radius
		local h = props.height / 2
		self._center_pos = pos
		self._bounding_radius = math.sqrt(r * r + h * h)
		self.fs_is_inside = self._unit and fs_really_original_shapecylindermiddle_isinside or self.fs_is_inside_no_unit
		local da = 20
		for i = 0, 17 do
			local tmp_vec1 = Vector3()
			mvec3_set(tmp_vec1, pos - rot:z() * props.height / 2)
			mvec3_set_x(tmp_vec1, tmp_vec1.x + math.cos(i * da) * props.radius)
			mvec3_set_y(tmp_vec1, tmp_vec1.y + math.sin(i * da) * props.radius)
			table.insert(perimeter, tmp_vec1)
			local tmp_vec2 = Vector3()
			mvec3_set(tmp_vec2, tmp_vec1 + rot:z() * props.height / 2)
			table.insert(perimeter, tmp_vec2)
		end
	end

	self._bounding_radius = self._bounding_radius * self._bounding_radius

	if not self._unit and Network:is_server() then
		table.insert(perimeter, self._center_pos)
		self._navseg = _points_are_in_the_same_navseg(perimeter)
		-- #{[@^\{[[|`@ GGC's metal detectors
		if not self._navseg and props.width and props.width <= 100 and props.depth and props.depth <= 100 then
			self._navseg = managers.navigation._quad_field:find_nav_segment(self._center_pos, true)
		end
	end
end

local fs_original_shape_setunit = Shape.set_unit
function Shape:set_unit(...)
	fs_original_shape_setunit(self, ...)
	self:reset_bounds()
end

local fs_original_shape_setproperty = Shape.set_property
function Shape:set_property(...)
	fs_original_shape_setproperty(self, ...)
	self:reset_bounds()
end

local fs_original_shape_setrotation = Shape.set_rotation
function Shape:set_rotation(...)
	fs_original_shape_setrotation(self, ...)
	self:reset_bounds()
end

local fs_original_shapebox_init = ShapeBox.init
function ShapeBox:init(...)
	fs_original_shapebox_init(self, ...)
	self.fs_type = 'ShapeBox'
	self:reset_bounds()
end

function ShapeBox:fs_is_inside_no_unit(pos)
	if mvec3_dis_sq(pos, self._center_pos) > self._bounding_radius then
		return false
	end
	return fs_original_shapebox_isinside(self, pos)
end

local fs_original_shapeboxmiddle_init = ShapeBoxMiddle.init
function ShapeBoxMiddle:init(...)
	fs_original_shapeboxmiddle_init(self, ...)
	self.fs_type = 'ShapeBoxMiddle'
	self:reset_bounds()
end

function ShapeBoxMiddle:fs_is_inside_no_unit(pos)
	if mvec3_dis_sq(pos, self._center_pos) > self._bounding_radius then
		return false
	end
	return fs_original_shapeboxmiddle_isinside(self, pos)
end

local fs_original_shapeboxmiddlebottom_init = ShapeBoxMiddleBottom.init
function ShapeBoxMiddleBottom:init(...)
	fs_original_shapeboxmiddlebottom_init(self, ...)
	self.fs_type = 'ShapeBoxMiddleBottom'
	self:reset_bounds()
end

function ShapeBoxMiddleBottom:fs_is_inside_no_unit(pos)
	if mvec3_dis_sq(pos, self._center_pos) > self._bounding_radius then
		return false
	end
	return fs_original_shapeboxmiddlebottom_isinside(self, pos)
end

local fs_original_shapecylinder_init = ShapeCylinder.init
function ShapeCylinder:init(...)
	fs_original_shapecylinder_init(self, ...)
	self.fs_type = 'ShapeCylinder'
	self:reset_bounds()
end

function ShapeCylinder:fs_is_inside_no_unit(pos)
	if mvec3_dis_sq(pos, self._center_pos) > self._bounding_radius then
		return false
	end
	return fs_original_shapecylinder_isinside(self, pos)
end

local fs_original_shapecylindermiddle_init = ShapeCylinderMiddle.init
function ShapeCylinderMiddle:init(...)
	fs_original_shapecylindermiddle_init(self, ...)
	self.fs_type = 'ShapeCylinderMiddle'
	self:reset_bounds()
end

function ShapeCylinderMiddle:fs_is_inside_no_unit(pos)
	if mvec3_dis_sq(pos, self._center_pos) > self._bounding_radius then
		return false
	end
	return fs_original_shapecylindermiddle_isinside(self, pos)
end
