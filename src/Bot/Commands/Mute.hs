--------------------------------------------------------------------------------
-- Discord Test Bot                                                           --
--------------------------------------------------------------------------------
-- This source code is licensed under the BSD3 licence found in the LICENSE   --
-- file in the root directory of this source tree.                            --
--                                                                            --
-- Copyright 2020 Oscar Harris (oscar@oscar-h.com)                            --
--------------------------------------------------------------------------------
module Bot.Commands.Mute where

import Data.Colour.Names ( khaki, palevioletred )

import Bot.Import
import Bot.Commands.Admin

data Mute
data Unmute

instance AdminLoggable Mute where
    colour = khaki
    word = "Muted"

instance AdminLoggable Unmute where
    colour = palevioletred
    word = "Unmuted"

mute :: BotC r => CommandContext -> Snowflake User -> [Text] -> Sem r ()
mute ctx u r = 
    let reason = intercalate " " <$> if r == [] then Nothing else Just r
        toInvoke = \(g :: Guild) -> AddGuildMemberRole g u muteRole
    in
        doAdminAction @Mute 
            ctx 
            u
            toInvoke 
            [EmbedField "Reason" (fromStrict $ fromMaybe "N/A" reason) False]

unmute :: BotC r => CommandContext -> Snowflake User -> [Text] -> Sem r ()
unmute ctx u r = 
    let reason = intercalate " " <$> if r == [] then Nothing else Just r
        toInvoke = \(g :: Guild) -> RemoveGuildMemberRole g u muteRole
    in
        doAdminAction @Unmute 
            ctx 
            u
            toInvoke 
            [EmbedField "Reason" (fromStrict $ fromMaybe "N/A" reason) False]

-- TODO: Tempmute - call unmute with reason ["Temporary mute ended"]
