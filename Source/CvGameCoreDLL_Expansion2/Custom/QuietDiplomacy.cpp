#include "CvGameCoreDLLPCH.h"
#include "QuietDiplomacy.h"

#include "CvPlayer.h"
#include "CvNotifications.h"

bool QuietDiplomacy::LeaderDiscussion(CvPlayer* human, CvPlayer* computer, const char* text)
{
    CvAssertMsg(human && computer && text, "Quiet Diplomacy: Assertion error!");
    CvAssertMsg(human->isHuman(), "Quiet Diplomacy: Not a human!");

    // Send a notification.
    CvNotifications* pNotifications = human->GetNotifications();
    
    if(pNotifications)
    {
        // Create notification strings.
        std::string szMessage;
        szMessage += computer->getName();
        szMessage += ": ";
        szMessage += text;

        std::string szSummary;
        szSummary += "Message from ";
        szSummary += computer->getName();

        // Get computer's capital.
        int x = -1;
        int y = -1;

        CvCity* computerCapital = computer->getCapitalCity();
        if(computerCapital && computerCapital->isRevealed(human->getTeam(), false))
        {
            x = computerCapital->getX();
            y = computerCapital->getY();
        }

        // Add a notification.
        pNotifications->Add(NOTIFICATION_PEACE_ACTIVE_PLAYER, szMessage.c_str(), szSummary.c_str(), x, y, computer->GetID());
    }

    // Inform that we took care of it.
    return true;
}
