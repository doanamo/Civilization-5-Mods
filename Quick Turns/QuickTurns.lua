-------------------------------------------------
-- Quick Turns
-- by gunstarpl
-------------------------------------------------

-- QuickTurnsComputer()
function QuickTurnsComputer(iPlayerID)
	-- Get player and computer teams.
	local player = Players[Game.GetActivePlayer()];
	local playerTeam = Teams[player:GetTeam()];

	local computer = Players[iPlayerID];
	local computerTeam = Teams[computer:GetTeam()];

	-- Use quick turns by default unless below states apply.
	local useQuickMovement = true;
	local useQuickCombat = true;

	-- Check if computer is at war with player.
	if(computerTeam:IsAtWar(player:GetTeam())) then
		useQuickMovement = false;
		useQuickCombat = false;
	end

	-- Check if computer and player have a common enemy.
	-- TODO

	-- Check if computer is at war with player's friendly city states.
	-- TODO

	-- Set game options for current computer turn.
	local options = { };
	table.insert(options, { "GAMEOPTION_QUICK_MOVEMENT", useQuickMovement });
	table.insert(options, { "GAMEOPTION_QUICK_COMBAT", useQuickCombat });

	Network.SendGameOptions(options);
end

-- QuickTurnsPlayer()
function QuickTurnsPlayer()
	-- Set game options for current player turn.
	local options = { };
	table.insert(options, { "GAMEOPTION_QUICK_MOVEMENT", false });
	table.insert(options, { "GAMEOPTION_QUICK_COMBAT", false });

	Network.SendGameOptions(options);
end

-- Add event callbacks.
Events.AIProcessingStartedForPlayer.Add(QuickTurnsComputer);
Events.ActivePlayerTurnStart.Add(QuickTurnsPlayer);
Events.RemotePlayerTurnStart.Add(QuickTurnsPlayer);
