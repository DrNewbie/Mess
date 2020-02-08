local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local fs_original_coroutinemanager_init = CoroutineManager.init
function CoroutineManager:init()
	self.fs_is_empty = true
	fs_original_coroutinemanager_init(self)
end

function CoroutineManager:update(t, dt)
	self:_add()

	if self.fs_is_empty then
		return
	end

	local amount = 0
	local coroutines = self._coroutines
	for i = self.Size, 1, -1 do
		local crs = coroutines[i]
		local sz = #crs
		amount = amount + sz
		for key = sz, 1, -1 do
			local cr = crs[key]
			if cr then
				local result, error_msg = coroutine.resume(cr.co, unpack(cr.arg))
				local status = coroutine.status(cr.co)

				if result == false then
					Application:error('Coroutine failed (' .. tostring(key) .. '): ' .. tostring(error_msg))
				end

				if status == 'dead' then
					table.remove(crs, key)
					amount = amount - 1
				end
			end
		end
	end

	if amount == 0 then
		self.fs_is_empty = true
	end
end

function CoroutineManager:fs_find(name, priority)
	if self.fs_is_empty then
		return
	end

	local l = priority or 1
	local h = priority or self.Size
	local coroutines = self._coroutines
	for p = l, h do
		local crs = coroutines[p]
		for rank, cr in ipairs(crs) do
			if cr.name == name then
				return p, rank
			end
		end
	end
end

function CoroutineManager:add_coroutine(name, func, ...)
	if not self:fs_find(name, func.Priority) and not self._buffer[name] then
		local arg = {...}
		self._buffer[name] = {
			name = name,
			func = func,
			arg = arg
		}
	end
end

function CoroutineManager:add_and_run_coroutine(name, func, ...)
	local arg = {...}
	local co = coroutine.create(func.Function)
	local result, error_msg = coroutine.resume(co, unpack(arg))
	local status = coroutine.status(co)

	if result == false then
		Application:error('Coroutine failed (' .. tostring(name) .. '): ' .. error_msg)
	end

	if status ~= 'dead' then
		table.insert(self._coroutines[func.Priority], {
			name = name,
			co = co,
			arg = arg
		})
		self.fs_is_empty = false
	end
end

function CoroutineManager:_add()
	for key, value in pairs(self._buffer) do
		local co = coroutine.create(value.func.Function)
		table.insert(self._coroutines[value.func.Priority], {
			name = value.name,
			co = co,
			arg = value.arg
		})
		self._buffer[key] = nil
		self.fs_is_empty = false
	end

	self._buffer = nil
	self._buffer = {}
end

function CoroutineManager:is_running(name)
	if self._buffer[name] then
		return true
	end

	if self:fs_find(name) then
		return true
	end

	return false
end

function CoroutineManager:remove_coroutine(name)
	if self._buffer[name] then
		self._buffer[name] = nil
	end

	local priority, rank = self:fs_find(name)
	if priority then
		table.remove(self._coroutines[priority][rank])
	end
end
