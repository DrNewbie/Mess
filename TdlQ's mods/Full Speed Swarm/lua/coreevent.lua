local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

if core then
	core:module('CoreEvent')
end

local math_floor = math.floor
local table_insert = table.insert
local table_remove = table.remove

function CallbackHandler:remove(cb)
	if cb then
		cb.disabled = true -- to ease life of __insert_sorted()
	end
end

function CallbackHandler:update(dt)
	local tbl = self._sorted
	local t = self._t
	t = t + dt
	self._t = t
	while true do
		local cb = tbl[1]
		if cb == nil then
			return
		elseif t < cb.next then
			return
		else
			table_remove(tbl, 1)
			repeat
				if cb.disabled then
					break
				end
				cb:f(t)
				local times = cb.times
				if times >= 0 then
					times = times - 1
					if times <= 0 then
						break
					end
					cb.times = times
				end
				cb.next = cb.next + cb.interval
				self:__insert_sorted(cb)
			until true
		end
	end
end

-- ref http://lua-users.org/wiki/BinaryInsert
function CallbackHandler:__insert_sorted(cb)
	local new_val = cb.next
	local tbl = self._sorted
	local i_start, i_end, i_mid, i_state = 1, #tbl, 1, 0

	while i_start <= i_end do
		i_mid = math_floor((i_start + i_end) * 0.5)
		local mid_val = tbl[i_mid].next
		if new_val <= mid_val then
			i_end, i_state = i_mid - 1, 0
		else
			i_start, i_state = i_mid + 1, 1
		end
	end
	table_insert(tbl, i_mid + i_state, cb)
end
