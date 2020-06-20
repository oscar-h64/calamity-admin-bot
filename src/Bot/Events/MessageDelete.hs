--------------------------------------------------------------------------------
-- Calamity Admin Bot                                                         --
--------------------------------------------------------------------------------
-- This source code is licensed under the BSD3 licence found in the LICENSE   --
-- file in the root directory of this source tree.                            --
--                                                                            --
-- Copyright 2020 Oscar Harris (oscar@oscar-h.com)                            --
--------------------------------------------------------------------------------
module Bot.Events.MessageDelete where

import Data.Default
import Data.Colour.Names

import Bot.Import

onMessageDelete :: BotC r => Message -> Sem (Reader BotConfig ': r) ()
onMessageDelete m = do
    lc <- logChannel <$> ask
    let text     = m ^. #content
        author   = m ^. #author
        channel  = m ^. #channelID
        origtime = showtl $ m ^. #timestamp
        embed = def & #title ?~ "Message Deleted" 
                    & #color ?~ tomato
                    & #fields .~ [
                        EmbedField "Channel" (mention channel) True,
                        EmbedField "Author" (mention author) True,
                        EmbedField "Sent" origtime True,
                        EmbedField "Content" text False
                    ]
    void $ tell @Embed lc embed
