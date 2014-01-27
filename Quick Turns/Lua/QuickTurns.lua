-------------------------------------------------
-- Quick Turns
-- by gunstarpl
-------------------------------------------------

-- Global mod data.
MapModData.QuickTurns = { };
MapModData.QuickTurns.IsPlayerTurn = true;

-- Create a persistent user data.
MapModData.QuickTurns.UserData = Modding.OpenUserData("gunstarpl_QuickTurns", 1);

local userData = MapModData.QuickTurns.UserData;

-- Set default persistent user data values.
function QuickTurns_SetDefaultOption(option, value)
	if(userData.GetValue(option) == nil) then
		userData.SetValue(option, value);
	end
end

QuickTurns_SetDefaultOption("PlayerQuickMovement", 0);
QuickTurns_SetDefaultOption("PlayerQuickCombat", 0);
QuickTurns_SetDefaultOption("ComputerPeaceQuickMovement", 1);
QuickTurns_SetDefaultOption("ComputerPeaceQuickCombat", 1);
QuickTurns_SetDefaultOption("ComputerWarQuickMovement", 0);
QuickTurns_SetDefaultOption("ComputerWarQuickCombat", 0);

-- SetQuickAnimations()
function QuickTurns_SetQuickAnimations(movement, combat)
	-- Set quick animation options.
	local options = { };
	table.insert(options, { "GAMEOPTION_QUICK_MOVEMENT", movement });
	table.insert(options, { "GAMEOPTION_QUICK_COMBAT", combat });

	Network.SendGameOptions(options);
end

MapModData.QuickTurns.SetQuickAnimations = QuickTurns_SetQuickAnimations;

-- OnGameStart()
function QuickTurns_OnGameStart()
	print("Called OnGameStart()");
	
	-- Player loaded or started a new game.
	QuickTurns_SetQuickAnimations(
		userData.GetValue("PlayerQuickMovement") == 1, 
		userData.GetValue("PlayerQuickCombat") == 1
	);
end

Events.LoadScreenClose.Add(QuickTurns_OnGameStart);

-- OnComputerTurn()
function QuickTurns_OnComputerTurn(iPlayerID)
	print("Called OnComputerTurn()");

	-- Set non player turn state.
	MapModData.QuickTurns.IsPlayerTurn = false;

	-- Get player and computer teams.
	local pPlayer = Players[Game.GetActivePlayer()];
	local pPlayerTeam = Teams[Game.GetActiveTeam()];

	local pComputer = Players[iPlayerID];
	local pComputerTeam = Teams[pComputer:GetTeam()];

	-- Toggle animations for peace unless below states apply.
	local quickMovement = userData.GetValue("ComputerPeaceQuickMovement") == 1;
	local quickCombat = userData.GetValue("ComputerPeaceQuickCombat") == 1;

	-- Check if computer is at war with the player.
	if(pComputerTeam:IsAtWar(pPlayer:GetTeam())) then
		quickMovement = userData.GetValue("ComputerWarQuickMovement") == 1;
		quickCombat = userData.GetValue("ComputerWarQuickCombat") == 1;
	else
		-- Check if computer and player have a common enemy.
		-- TODO

		-- Check if computer is at war with the player's friendly city states.
		-- TODO
	end

	-- Set quick animations for current computer turn.
	QuickTurns_SetQuickAnimations(quickMovement,quickCombat);
end

Events.AIProcessingStartedForPlayer.Add(QuickTurns_OnComputerTurn);

-- OnPlayerTurn()
function QuickTurns_OnPlayerTurn()
	print("Called OnPlayerTurn()");

	-- Set player turn state.
	MapModData.QuickTurns.IsPlayerTurn = true;

	-- Set quick animations for current player turn.
	QuickTurns_SetQuickAnimations(
		userData.GetValue("PlayerQuickMovement") == 1,
		userData.GetValue("PlayerQuickCombat") == 1
	);
end

Events.ActivePlayerTurnStart.Add(QuickTurns_OnPlayerTurn);
Events.RemotePlayerTurnStart.Add(QuickTurns_OnPlayerTurn);

-- OnWarStateChange()
function QuickTurns_OnWarStateChange(iTeam1, iTeam2, bWar)
	print("Called OnWarStateChange()");

	-- Check war state change.
	if(iTeam2 == Game.GetActiveTeam()) then
		if(bWar) then
			-- Computer declared war on the player.
			QuickTurns_SetQuickAnimations(
				userData.GetValue("ComputerWarQuickMovement") == 1,
				userData.GetValue("ComputerWarQuickCombat") == 1
			);
		else
			-- Computer made peace with the player.
			QuickTurns_SetQuickAnimations(
				userData.GetValue("ComputerPeaceQuickMovement") == 1,
				userData.GetValue("ComputerPeaceQuickCombat") == 1
			);
		end
	end
end

Events.WarStateChanged.Add(QuickTurns_OnWarStateChange);

-- Debug print.
print("Quick Turns mod loaded!");
