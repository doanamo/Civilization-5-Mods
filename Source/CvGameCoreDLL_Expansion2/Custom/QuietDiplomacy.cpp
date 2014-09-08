#include "CvGameCoreDLLPCH.h"
#include "QuietDiplomacy.h"

#include "CvPlayer.h"
#include "CvNotifications.h"

bool QuietDiplomacy::LeaderDiscussion(CvPlayer* human, CvPlayer* computer, const char* text)
{
    CvAssertMsg(human && computer && text, "Quiet Diplomacy: Assertion error!");
    CvAssertMsg(human->isHuman(), "Quiet Diplomacy: Not a human!");

    // Send a notification.
    CvNotifications* notifications = human->GetNotifications();
    
    if(notifications)
    {
        // Create strings.
        Localization::String message = Localization::Lookup("TXT_KEY_QUIETDIPLOMACY_LEADERDISCUSSION_MESSAGE");
        message << Localization::Lookup(computer->getNameKey());
        message << text;

        Localization::String summary = Localization::Lookup("TXT_KEY_QUIETDIPLOMACY_LEADERDISCUSSION_SUMMARY");
        summary << Localization::Lookup(computer->getNameKey());

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
        notifications->Add(NOTIFICATION_PEACE_ACTIVE_PLAYER, message.toUTF8(), summary.toUTF8(), x, y, computer->GetID());
    }

    // Inform that we took care of it.
    return true;
}
