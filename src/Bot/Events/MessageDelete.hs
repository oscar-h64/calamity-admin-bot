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
                    & #color ?~ tomato
                    & #fields .~ [
                        EmbedField "Channel" (mention channel) True,
                        EmbedField "Author" (mention author) True,
                        EmbedField "Sent" origtime True,
                        EmbedField "Content" text False
                    ]
    void $ tell @Embed logChannel embed
