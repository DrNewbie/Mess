local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local ctc_original_ingamewaitingforplayersstate_clbkfilestreamerstatus = IngameWaitingForPlayersState.clbk_file_streamer_status
function IngameWaitingForPlayersState:clbk_file_streamer_status(workload)
	ctc_original_ingamewaitingforplayersstate_clbkfilestreamerstatus(self, workload)
	if self._last_sent_streaming_status == 100 then
		Application:apply_render_settings()
	end
end
