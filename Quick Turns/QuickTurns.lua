-------------------------------------------------
-- Quick Turns
-- by gunstarpl
-------------------------------------------------

-- SetQuickAnimations()
function QuickTurns_SetQuickAnimations(movement, combat)
	-- Set quick animation options.
	local options = { };
	table.insert(options, { "GAMEOPTION_QUICK_MOVEMENT", movement });
	table.insert(options, { "GAMEOPTION_QUICK_COMBAT", combat });

	Network.SendGameOptions(options);
end

-- OnGameStart()
function QuickTurns_OnGameStart()
	print("Called OnGameStart()");
	
	-- Player loaded or started a new game.
	QuickTurns_SetQuickAnimations(false, false);
end

-- OnComputerTurn()
function QuickTurns_OnComputerTurn(iPlayerID)
	print("Called OnComputerTurn()");

	-- Get player and computer teams.
	local pPlayer = Players[Game.GetActivePlayer()];
	local pPlayerTeam = Teams[Game.GetActiveTeam()];

	local pComputer = Players[iPlayerID];
	local pComputerTeam = Teams[pComputer:GetTeam()];

	-- Hide animations by default (in peace) unless below states apply.
	local quickMovement = true;
	local quickCombat = true;

	-- Check if computer is at war with the player.
	if(pComputerTeam:IsAtWar(pPlayer:GetTeam())) then
		quickMovement = false;
		quickCombat = false;
	end

	-- Check if computer and player have a common enemy.
	-- TODO

	-- Check if computer is at war with the player's friendly city states.
	-- TODO

	-- Set game options for current computer turn.
	QuickTurns_SetQuickAnimations(quickMovement, quickCombat);
end

-- OnPlayerTurn()
function QuickTurns_OnPlayerTurn()
	print("Called OnPlayerTurn()");

	-- Set game options for current player turn.
	QuickTurns_SetQuickAnimations(false, false);
end

-- OnWarStateChange()
function QuickTurns_OnWarStateChange(iTeam1, iTeam2, bWar)
	print("Called OnWarStateChange()");

	-- Check war state change.
	if(iTeam2 == Game.GetActiveTeam()) then
		if(bWar) then
			-- Computer declared war on the player.
			QuickTurns_SetQuickAnimations(false, false);
		else
			-- Computer made peace with the player.
			QuickTurns_SetQuickAnimations(true, true);
		end
	else
		-- Computer declared war on other computer.
		if(bWar) then
			-- Check if computer and player have a common enemy.
			-- TODO

			-- Check if computer is at war with the player's friendly city states.
			-- TODO
		end
	end
end

-- Add event callbacks.
Events.LoadScreenClose.Add(QuickTurns_OnGameStart);
Events.AIProcessingStartedForPlayer.Add(QuickTurns_OnComputerTurn);
Events.ActivePlayerTurnStart.Add(QuickTurns_OnPlayerTurn);
Events.RemotePlayerTurnStart.Add(QuickTurns_OnPlayerTurn);
Events.WarStateChanged.Add(QuickTurns_OnWarStateChange);

-- Debug print.
print("Quick Turns mod loaded!");
