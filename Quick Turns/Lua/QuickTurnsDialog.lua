-------------------------------------------------
-- Quick Turns
-- by gunstarpl
-------------------------------------------------

-- Get persistent user data.
local userData = MapModData.QuickTurns.UserData;

-- Hide dialog by default.
ContextPtr:SetHide(true);

-- Set default check box states.
Controls.PlayerQuickMovement:SetCheck(userData.GetValue("PlayerQuickMovement") == 1);
Controls.PlayerQuickCombat:SetCheck(userData.GetValue("PlayerQuickCombat") == 1);
Controls.BarbarianQuickMovement:SetCheck(userData.GetValue("BarbarianQuickMovement") == 1);
Controls.BarbarianQuickCombat:SetCheck(userData.GetValue("BarbarianQuickCombat") == 1);
Controls.ComputerPeaceQuickMovement:SetCheck(userData.GetValue("ComputerPeaceQuickMovement") == 1);
Controls.ComputerPeaceQuickCombat:SetCheck(userData.GetValue("ComputerPeaceQuickCombat") == 1);
Controls.ComputerWarQuickMovement:SetCheck(userData.GetValue("ComputerWarQuickMovement") == 1);
Controls.ComputerWarQuickCombat:SetCheck(userData.GetValue("ComputerWarQuickCombat") == 1);

-- OpenDialog()
function OpenDialog()
	-- Show the dialog.
	ContextPtr:SetHide(false);
end

-- CloseDialog()
function CloseDialog()
	-- Hide the dialog.
	ContextPtr:SetHide(true);

	-- If player turn, apply some of the changed settings.
	if(MapModData.QuickTurns.IsPlayerTurn) then
		MapModData.QuickTurns.SetQuickAnimations(
			userData.GetValue("PlayerQuickMovement") == 1, 
			userData.GetValue("PlayerQuickCombat") == 1
		);
	end
end

Controls.CloseButton:RegisterCallback(Mouse.eLClick, CloseDialog);

-- HandleInput()
function HandleInput(uiMsg, wParam, lParam)
	-- Close dialog with ESC key.
	if(uiMsg == KeyEvents.KeyDown) then
		if(wParam == Keys.VK_ESCAPE) then
			CloseDialog();
		end
	end

	-- Block input.
	return true;
end

ContextPtr:SetInputHandler(HandleInput);

-- Quick animation check box callbacks.
Controls.PlayerQuickMovement:RegisterCheckHandler(
	function(bIsChecked)
		userData.SetValue("PlayerQuickMovement", bIsChecked);
	end
);

Controls.PlayerQuickCombat:RegisterCheckHandler(
	function(bIsChecked)
		userData.SetValue("PlayerQuickCombat", bIsChecked);
	end
);

Controls.BarbarianQuickMovement:RegisterCheckHandler(
	function(bIsChecked)
		userData.SetValue("BarbarianQuickMovement", bIsChecked);
	end
);

Controls.BarbarianQuickCombat:RegisterCheckHandler(
	function(bIsChecked)
		userData.SetValue("BarbarianQuickCombat", bIsChecked);
	end
);

Controls.ComputerPeaceQuickMovement:RegisterCheckHandler(
	function(bIsChecked)
		userData.SetValue("ComputerPeaceQuickMovement", bIsChecked);
	end
);

Controls.ComputerPeaceQuickCombat:RegisterCheckHandler(
	function(bIsChecked)
		userData.SetValue("ComputerPeaceQuickCombat", bIsChecked);
	end
);

Controls.ComputerWarQuickMovement:RegisterCheckHandler(
	function(bIsChecked)
		userData.SetValue("ComputerWarQuickMovement", bIsChecked);
	end
);

Controls.ComputerWarQuickCombat:RegisterCheckHandler(
	function(bIsChecked)
		userData.SetValue("ComputerWarQuickCombat", bIsChecked);
	end
);

-- AddDropdownEntry()
function AddDropdownEntry(additionalEntries)
	-- Add new dialog entry to the additional information dropdown list.
	table.insert(additionalEntries, { text = Locale.ConvertTextKey("TXT_KEY_QUICKTURNS_TITLE"), call = OpenDialog });
end

LuaEvents.AdditionalInformationDropdownGatherEntries.Add(AddDropdownEntry);
LuaEvents.RequestRefreshAdditionalInformationDropdownEntries();
