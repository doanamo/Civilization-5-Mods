-------------------------------------------------
-- Quick Turns
-- by gunstarpl
-------------------------------------------------

-- QuickTurnsStartGame()
function QuickTurnsStartGame()
	print("Called QuickTurnsStartGame()");
	
	-- Human loaded or started a new game.
	local options = { };
	table.insert(options, { "GAMEOPTION_QUICK_MOVEMENT", false });
	table.insert(options, { "GAMEOPTION_QUICK_COMBAT", false });

	Network.SendGameOptions(options);
end

-- QuickTurnsComputer()
function QuickTurnsComputer(iPlayerID)
	print("Called QuickTurnsComputer()");

	-- Get human and computer teams.
	local pHuman = Players[Game.GetActivePlayer()];
	local pHumanTeam = Teams[Game.GetActiveTeam()];

	local pComputer = Players[iPlayerID];
	local pComputerTeam = Teams[pComputer:GetTeam()];

	-- Use quick turns by default unless below states apply.
	local useQuickMovement = true;
	local useQuickCombat = true;

	-- Check if computer is at war with human.
	if(pComputerTeam:IsAtWar(pHuman:GetTeam())) then
		useQuickMovement = false;
		useQuickCombat = false;
	end

	-- Check if computer and human have a common enemy.
	-- TODO

	-- Check if computer is at war with human's friendly city states.
	-- TODO

	-- Set game options for current computer turn.
	local options = { };
	table.insert(options, { "GAMEOPTION_QUICK_MOVEMENT", useQuickMovement });
	table.insert(options, { "GAMEOPTION_QUICK_COMBAT", useQuickCombat });

	Network.SendGameOptions(options);
end

-- QuickTurnsHuman()
function QuickTurnsHuman()
	print("Called QuickTurnsHuman()");

	-- Set game options for current human turn.
	local options = { };
	table.insert(options, { "GAMEOPTION_QUICK_MOVEMENT", false });
	table.insert(options, { "GAMEOPTION_QUICK_COMBAT", false });

	Network.SendGameOptions(options);
end

-- QuickTurnsWarState()
function QuickTurnsWarState(iTeam1, iTeam2, bWar)
	print("Called QuickTurnsWarState()");

	-- Check war state change.
	if(iTeam2 == Game.GetActiveTeam()) then
		if(bWar) then
			-- Computer declared war on the human.
			local options = { };
			table.insert(options, { "GAMEOPTION_QUICK_MOVEMENT", false });
			table.insert(options, { "GAMEOPTION_QUICK_COMBAT", false });

			Network.SendGameOptions(options);
		else
			-- Computer made peace with the human.
			local options = { };
			table.insert(options, { "GAMEOPTION_QUICK_MOVEMENT", true });
			table.insert(options, { "GAMEOPTION_QUICK_COMBAT", true });

			Network.SendGameOptions(options);
		end
	else
		-- Computer declared war on other computer.
		if(bWar) then
			-- Check if computer and human have a common enemy.
			-- TODO

			-- Check if computer is at war with human's friendly city states.
			-- TODO
		end
	end
end

-- Add event callbacks.
Events.LoadScreenClose.Add(QuickTurnsStartGame);
Events.AIProcessingStartedForPlayer.Add(QuickTurnsComputer);
Events.ActivePlayerTurnStart.Add(QuickTurnsHuman);
Events.RemotePlayerTurnStart.Add(QuickTurnsHuman);
Events.WarStateChanged.Add(QuickTurnsWarState);

-- Debug print.
print("Quick Turns mod loaded!");
