#include "CvGameCoreDLLPCH.h"
#include "QuietDiplomacy.h"

#include "CvPlayer.h"
#include "CvNotifications.h"

void QuietDiplomacy::CreateNotification(CvPlayer* human, CvPlayer* computer, const char* text)
{
	CvAssertMsg(human && computer && text, "Quiet Diplomacy: Assertion error!");
	CvAssertMsg(human->isHuman(), "Quiet Diplomacy: Not a human!");

	CvNotifications* pNotifications = human->GetNotifications();

	if(pNotifications)
	{
		std::string szMessage;
		szMessage += computer->getName();
		szMessage += ": ";
		szMessage += text;

		std::string szSummary;
		szSummary += "Message from ";
		szSummary += computer->getName();

		int x = -1;
		int y = -1;

		CvCity* computerCapital = computer->getCapitalCity();
		if(computerCapital && computerCapital->isRevealed(human->getTeam(), false))
		{
			x = computerCapital->getX();
			y = computerCapital->getY();
		}

		pNotifications->Add(NOTIFICATION_PEACE_ACTIVE_PLAYER, szMessage.c_str(), szSummary.c_str(), x, y, computer->GetID());
	}
}
