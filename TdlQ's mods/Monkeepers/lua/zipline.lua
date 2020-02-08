local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

if Monkeepers.disabled then
	return
end

function ZipLine:mkp_register_zipline_position()
	Monkeepers.ziplines[self._unit:key()] = self:is_usage_type_bag() and mvector3.copy(self._start_pos) or nil
end

local mkp_original_zipline_init = ZipLine.init
function ZipLine:init(...)
	mkp_original_zipline_init(self, ...)
	self:mkp_register_zipline_position()
end

local mkp_original_zipline_setusagetype = ZipLine.set_usage_type
function ZipLine:set_usage_type(...)
	mkp_original_zipline_setusagetype(self, ...)
	self:mkp_register_zipline_position()
end

local mkp_original_zipline_setstartpos = ZipLine.set_start_pos
function ZipLine:set_start_pos(...)
	mkp_original_zipline_setstartpos(self, ...)
	self:mkp_register_zipline_position()
end

local mkp_original_zipline_destroy = ZipLine.destroy
function ZipLine:destroy(...)
	Monkeepers.ziplines[self._unit:key()] = nil
	mkp_original_zipline_destroy(self, ...)
end
