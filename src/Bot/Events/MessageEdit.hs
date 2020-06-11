module Bot.Events.MessageEdit where

import Calamity.Types.Model.Channel.Message
import Calamity.Types.Model.Channel.Embed
import Calamity.Types.Tellable

import Data.Default

import Bot.Import

onMessageEdit :: BotC r => Message -> Message -> Sem r ()
onMessageEdit m1 m2 = do
    let origtext = m1 ^. #content
        newtext  = m2 ^. #content
        author = m2 ^. #author
        -- getAvatar u = u ^. #avatar
        channel = m2 ^. #channelID
        origtime = fromStrict $ showt $ m2 ^. #timestamp
        edittime = fromStrict $ fromMaybe "" $ showt <$> m2 ^. #editedTimestamp
    -- fullAuth <- upgrade author
    let msg :: Embed
        msg = def & #title ?~ "Message Edited" 
                --   & #author ?~ EmbedAuthor (displayUser <$> fullAuth) Nothing (getAvatar <$> fullAuth) Nothing
                  & #fields .~ [
                      EmbedField "Author" (mention author) True,
                      EmbedField "Channel" (mention channel) True,
                      EmbedField "Sent" origtime True,
                      EmbedField "Edited" edittime True,
                      EmbedField "Old Text" origtext True,
                      EmbedField "New Text" newtext True
                  ]
    void $ tell logChannel msg
