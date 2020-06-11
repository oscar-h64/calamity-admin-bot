module Bot.Events.MessageEdit where

import Calamity.Types.Model.Channel.Message

import Bot.Import

import TextShow

import qualified Data.Text.Lazy as L

onMessageEdit :: BotC r => Message -> Message -> Sem r ()
onMessageEdit m1 m2 = do
    let orig = m1 ^. #content
        new  = m2 ^. #content
        auth = m2 ^. #author
        chan = m2 ^. #channelID
        time = m2 ^. #editedTimestamp
    void $ tellt m2 $ L.fromStrict $ showt auth <> " updated their message in " <> showt chan <> " from " <> L.toStrict orig <> " to " <> L.toStrict new <> " at " <> showt time
