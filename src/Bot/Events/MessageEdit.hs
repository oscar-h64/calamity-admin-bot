--------------------------------------------------------------------------------
-- Calamity Admin Bot                                                         --
--------------------------------------------------------------------------------
-- This source code is licensed under the BSD3 licence found in the LICENSE   --
-- file in the root directory of this source tree.                            --
--                                                                            --
-- Copyright 2020 Oscar Harris (oscar@oscar-h.com)                            --
--------------------------------------------------------------------------------
module Bot.Events.MessageEdit where

import Data.Default
import Data.Colour.Names

import Bot.Import

onMessageEdit :: BotC r => Message -> Message -> Sem (Reader BotConfig ': r) ()
onMessageEdit m1 m2 = do
    lc <- bcLogChannel <$> ask
    let origtext = m1 ^. #content
        newtext  = m2 ^. #content
        author   = m2 ^. #author
        channel  = m2 ^. #channelID
        origtime = showtl $ m2 ^. #timestamp
        edittime = fromMaybe "ERROR" $ showtl <$> m2 ^. #editedTimestamp
        embed = def & #title ?~ "Message Edited" 
                    & #color ?~ mediumaquamarine
                    & #fields .~ [
                        EmbedField "Author" (mention author) True,
                        EmbedField "Sent" origtime True,
                        EmbedField "Old Text" origtext True,

                        EmbedField "Channel" (mention channel) True,
                        EmbedField "Edited" edittime True,                      
                        EmbedField "New Text" newtext True
                    ]
    void $ tell @Embed lc embed
