module Bot.Events.MessageEdit where

import Calamity.Types.Model.Channel.Message

import Bot.Import

onMessageEdit :: BotC r => Message -> Message -> Sem r ()
onMessageEdit m1 m2 = do
    let orig = m1 ^. #content
        new  = m2 ^. #content
        auth = m2 ^. #author
        chan = m2 ^. #channelID
        time = fromStrict $ fromMaybe "" $ showt <$> m2 ^. #editedTimestamp
    void $ tellt m2 $ mention auth <> " updated their message in " <> mention chan <> " from " <> orig <> " to " <> new <> " at " <> time
