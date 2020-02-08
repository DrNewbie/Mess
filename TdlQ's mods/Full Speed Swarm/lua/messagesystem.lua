local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local pairs = pairs
function MessageSystem:_notify()
	for _, msg in ipairs(self._messages) do
		local listeners = self._listeners[msg.message]
		if listeners then
			if msg.uid then
				listeners[msg.uid](unpack(msg.arg))
			else
				for _, listener in pairs(listeners) do
					listener(unpack(msg.arg))
				end
			end
		end
	end
	self._messages = {}
end
