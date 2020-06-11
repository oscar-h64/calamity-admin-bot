module Bot.Events.MessageDelete where

import Data.Default
import Data.Colour.Names

import Bot.Import

onMessageDelete :: BotC r => Message -> Sem r ()
onMessageDelete m = do
    let text     = m ^. #content
        author   = m ^. #author
        channel  = m ^. #channelID
        origtime = fromStrict $ showt $ m ^. #timestamp
        embed = def & #title ?~ "Message Deleted" 
                    & #color ?~ red
                    & #fields .~ [
                        EmbedField "Author" (mention author) True,
                        EmbedField "Sent" origtime True,
                        EmbedField "Old Text" text True,
                        EmbedField "Channel" (mention channel) True
                    ]
    void $ tell @Embed logChannel embed
