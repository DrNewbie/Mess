local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local bc_original_groupaistatebase_onpolicecalled = GroupAIStateBase.on_police_called
function GroupAIStateBase:on_police_called(called_reason)
	bc_original_groupaistatebase_onpolicecalled(self, called_reason)
	if BagContour:CanHideBodyBagContour() then
		managers.interaction:remove_contour('person')
	end
end

local bc_original_groupaistatebase_syncevent = GroupAIStateBase.sync_event
function GroupAIStateBase:sync_event(event_id, blame_id)
	bc_original_groupaistatebase_syncevent(self, event_id, blame_id)
	if self.EVENT_SYNC[event_id] == 'police_called' and BagContour:CanHideBodyBagContour() then
		managers.interaction:remove_contour('person')
	end
end
