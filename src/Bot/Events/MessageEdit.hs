module Bot.Events.MessageEdit where

import Calamity.Types.Model.Channel.Message

import Bot.Import

onMessageEdit :: BotC r => Message -> Message -> Sem r ()
onMessageEdit m1 m2 = do
    let origtext = m1 ^. #content
        newtext  = m2 ^. #content
        author = m2 ^. #author
        channel = m2 ^. #channelID
        origtime = fromStrict $ showt $ m2 ^. #timestamp
        edittime = fromStrict $ fromMaybe "" $ showt <$> m2 ^. #editedTimestamp
    
    void $ tellt logChannel $ mention author <> " updated their message in " <> mention channel <> " from " <> origtext <> " to " <> newtext <> " at " <> edittime
