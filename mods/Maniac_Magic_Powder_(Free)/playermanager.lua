local CD_38e2a18ebe580bc5 = 0

function PlayerManager:UseManiacMagicPowde()
	local local_peer_id = managers.network:session() and managers.network:session():local_peer():id()
	if not local_peer_id or not self:has_category_upgrade("player", "cocaine_stacking") then
		return
	else
		if TimerManager:game():time() > CD_38e2a18ebe580bc5 then
			CD_38e2a18ebe580bc5 = TimerManager:game():time() + 30
			self:update_synced_cocaine_stacks_to_peers(
				(tweak_data.upgrades.max_total_cocaine_stacks or 2047), 
				self:upgrade_value("player", "sync_cocaine_upgrade_level", 1), 
				self:upgrade_level("player", "cocaine_stack_absorption_multiplier", 0)
			)
		end
	end
	return
end

Hooks:PostHook(PlayerManager, "on_killshot", "F_"..Idstring("speed-up::Magic Powder"):key(), function(self)
	CD_38e2a18ebe580bc5 = CD_38e2a18ebe580bc5 - 2
end)