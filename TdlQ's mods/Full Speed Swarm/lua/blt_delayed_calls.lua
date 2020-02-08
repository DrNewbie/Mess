-- main point of this: don't use resources when you have nothing to do

local DelayedCalls = DelayedCalls
if CallbackHandler and DelayedCalls and DelayedCalls._calls then
	if not DelayedCalls.FSS then
		function CallbackHandler:remove_by_id(id)
			local sorted = self._sorted
			local nr = #sorted
			for i = 1, nr do
				local cb = sorted[i]
				if cb.id == id then
					cb.disabled = true
				end
			end
		end

		DelayedCalls.FSS = true
		DelayedCalls.clbk_handler = CallbackHandler:new()
		DelayedCalls.clbk_handler._t = TimerManager:game():time()
	end

	function DelayedCalls:Add(id, interval, func, repeat_x_times)
		if type(id) ~= 'string' or type(interval) ~= 'number' or type(func) ~= 'function' then
			log('[FSS] DelayedCalls:Add() received crap:')
			log('[FSS]   id: ' .. tostring(id))
			log('[FSS]   interval: ' .. tostring(interval))
			log('[FSS]   func: ' .. tostring(func))
			log('[FSS] ' .. debug.traceback())
			return
		end

		-- ugly and slow but given how many times it's called...
		self.clbk_handler:remove_by_id(id)
		local cb = self.clbk_handler:add(func, interval, repeat_x_times or 1)
		cb.id = id
	end

	function DelayedCalls:Remove(id)
		self.clbk_handler:remove_by_id(id)
	end

	Hooks:Add('MenuUpdate', 'MenuUpdate_Queue', function(t, dt)
		DelayedCalls.clbk_handler:update(dt)
	end)

	Hooks:Add('GameSetupUpdate', 'GameSetupUpdate_Queue', function(t, dt)
		DelayedCalls.clbk_handler:update(dt)
	end)

	for id, call in pairs(DelayedCalls._calls) do
		if type(call) == 'table' then
			DelayedCalls:Add(id, call.timeToWait - call.currentTime, call.functionCall)
		end
	end
	DelayedCalls._calls = nil
end
