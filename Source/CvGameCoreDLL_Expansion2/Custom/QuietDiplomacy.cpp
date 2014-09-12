#include "CvGameCoreDLLPCH.h"
#include "QuietDiplomacy.h"

#include "CvPlayer.h"
#include "CvNotifications.h"

namespace
{
    bool DoesTextKeyExist(const char* key)
    {
        std::string text = Localization::Lookup(key).toUTF8();
        return text != key;
    }
}

bool QuietDiplomacy::LeaderDiscussion(CvPlayer* human, CvPlayer* computer, const char* text)
{
    CvAssertMsg(human && computer && text, "Quiet Diplomacy: Assertion error!");
    CvAssertMsg(human->isHuman(), "Quiet Diplomacy: Not a human!");

    // Send a notification.
    CvNotifications* notifications = human->GetNotifications();
    
    if(notifications)
    {
        // Create localized strings.
        // Hardcode some translation strings so DLL can be used alone without XML texts.
        std::string language = Localization::GetCurrentLanguage().GetType();

        std::string message;
        std::string summary;

        if(DoesTextKeyExist("TXT_KEY_QUIETDIPLOMACY_LEADERDISCUSSION_SUMMARY") && 
            DoesTextKeyExist("TXT_KEY_QUIETDIPLOMACY_LEADERDISCUSSION_MESSAGE"))
        {
            // Fetch from the database.
            Localization::String localeSummary = Localization::Lookup("TXT_KEY_QUIETDIPLOMACY_LEADERDISCUSSION_SUMMARY");
            localeSummary << Localization::Lookup(computer->getNameKey());

            Localization::String localeMessage = Localization::Lookup("TXT_KEY_QUIETDIPLOMACY_LEADERDISCUSSION_MESSAGE");
            localeMessage << Localization::Lookup(computer->getNameKey());
            localeMessage << text;

            summary = localeSummary.toUTF8();
            message = localeMessage.toUTF8();
        }
        else
        {
            if(language == "pl_PL")
            {
                // Polish
                Localization::String localeLeader = Localization::Lookup(computer->getNameKey());

                size_t localeLeaderBytes = 0;
                const char* localeLeaderString = localeLeader.toUTF8(localeLeaderBytes, 2);

                summary += "Wiadomo\xc5\x9b\xc4\x87 od ";
                summary.append(localeLeaderString, localeLeaderBytes);

                message += Localization::Lookup(computer->getNameKey()).toUTF8();
                message += ": ";
                message += text;
            }
            else
            {
                // English
                summary += "Message from ";
                summary += Localization::Lookup(computer->getNameKey()).toUTF8();

                message += Localization::Lookup(computer->getNameKey()).toUTF8();
                message += ": ";
                message += text;
            }
        }

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
        notifications->Add(NOTIFICATION_PEACE_ACTIVE_PLAYER, message.c_str(), summary.c_str(), x, y, computer->GetID());
    }

    // Inform that we took care of it.
    return true;
}
