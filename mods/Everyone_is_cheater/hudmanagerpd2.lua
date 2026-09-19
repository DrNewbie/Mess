Hooks:PostHook(HUDManager, "set_teammate_name", "MarkCheater4All", function(self, i)
	local peer = managers.network:session():peer(i)
	if not peer then
		return
	end
	peer:mark_cheater(VoteManager.REASON[table.random_key(VoteManager.REASON)])
end)