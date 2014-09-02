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

		int x = computer->getCapitalCity()->getX();
		int y = computer->getCapitalCity()->getY();

		pNotifications->Add(NOTIFICATION_MINOR, szMessage.c_str(), szSummary.c_str(), x, y, -1);
	}
}
