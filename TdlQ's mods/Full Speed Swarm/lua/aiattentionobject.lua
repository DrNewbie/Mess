local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local REACT_MIN = AIAttentionObject.REACT_MIN
local REACT_MAX = AIAttentionObject.REACT_MAX

local fs_original_aiattentionobject_init = AIAttentionObject.init
function AIAttentionObject:init(...)
	fs_original_aiattentionobject_init(self, ...)
	self.rel_cache = {}
end

local fs_original_aiattentionobject_addattention = AIAttentionObject.add_attention
function AIAttentionObject:add_attention(...)
	fs_original_aiattentionobject_addattention(self, ...)
	self.rel_cache = {}
end

local fs_original_aiattentionobject_removeattention = AIAttentionObject.remove_attention
function AIAttentionObject:remove_attention(...)
	fs_original_aiattentionobject_removeattention(self, ...)
	self.rel_cache = {}
end

local fs_original_aiattentionobject_setattention = AIAttentionObject.set_attention
function AIAttentionObject:set_attention(...)
	fs_original_aiattentionobject_setattention(self, ...)
	self.rel_cache = {}
end

local fs_original_aiattentionobject_overrideattention = AIAttentionObject.override_attention
function AIAttentionObject:override_attention(...)
	fs_original_aiattentionobject_overrideattention(self, ...)
	self.rel_cache = {}
end

local fs_original_aiattentionobject_setteam = AIAttentionObject.set_team
function AIAttentionObject:set_team(...)
	fs_original_aiattentionobject_setteam(self, ...)
	self.rel_cache = {}
end

local fs_original_aiattentionobject_getattention = AIAttentionObject.get_attention
function AIAttentionObject:get_attention(filter, min, max, team)
	if self._attention_data then
		local cache_key = (min or REACT_MIN) .. filter .. (max or REACT_MAX) .. (team and team.id or '')
		local rel_cache = self.rel_cache
		local result = rel_cache[cache_key]
		if result == nil then
			result = fs_original_aiattentionobject_getattention(self, filter, min, max, team)
			rel_cache[cache_key] = result or false
		end
		return result
	end
end
function AIAttentionObject:get_attention_fast(cache_key, ...)
	local rel_cache = self.rel_cache
	local result = rel_cache[cache_key]
	if result == nil then
		result = fs_original_aiattentionobject_getattention(self, ...)
		rel_cache[cache_key] = result or false
	end
	return result
end
function AIAttentionObject:get_attention_no_cache_query(cache_key, ...)
	local result = fs_original_aiattentionobject_getattention(self, ...)
	self.rel_cache[cache_key] = result or false
	return result
end

function AIAttentionObject:update(unit, t, dt)
	self._attention_obj:m_position(self._observer_info_m_pos)
end

function AIAttentionObject:fs_update(unit, t, dt)
	self:set_update_enabled(false)
end

if Network:is_client() then
	AIAttentionObject.update = AIAttentionObject.fs_update
end
local function DisableUpdate()
	AIAttentionObject.update = AIAttentionObject.fs_update
end
table.insert(FullSpeedSwarm.call_on_loud, DisableUpdate)

function AIAttentionObject:setup_attention_positions()
	if self._attention_obj_name then
		self._attention_obj = self._unit:get_object(Idstring(self._attention_obj_name))
	else
		self._attention_obj = self._unit:orientation_object()
	end
	self._observer_info_m_pos = self._attention_obj:position()
	self._m_head_pos = self._observer_info_m_pos
end

function AIAttentionObject:get_attention_m_pos()
	return self._observer_info_m_pos
end
AIAttentionObject.get_detection_m_pos = AIAttentionObject.get_attention_m_pos
AIAttentionObject.get_ground_m_pos = AIAttentionObject.get_attention_m_pos
