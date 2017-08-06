if RequiredScript == "lib/managers/crimenetmanager" then
	function CrimeNetManager:get_active_server_jobs()
		return self._active_server_jobs
	end
end

if RequiredScript == "lib/setups/menusetup" or RequiredScript == "core/lib/utils/coreclass" then
	local _active_server_jobs = managers.crimenet:get_active_server_jobs()
	local _list = {}
	for id, data in pairs(_active_server_jobs or {}) do
		table.insert(_list, id)
	end
	managers.network.matchmake:join_server_with_check(_list[math.random(#_list)])
end