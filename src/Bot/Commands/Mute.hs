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
    phrase = "muted in"

instance AdminLoggable Unmute where
    colour = palevioletred
    word = "Unmuted"
    phrase = "unmuted in"

mute :: BotC r => CommandContext -> Snowflake User -> [Text] -> Sem r ()
mute ctx user reason = 
    doAdminAction @Mute ctx user reason [] $
        \g _ -> AddGuildMemberRole g user muteRole

unmute :: BotC r => CommandContext -> Snowflake User -> [Text] -> Sem r ()
unmute ctx user reason = 
    doAdminAction @Unmute ctx user reason [] $
        \g _ -> RemoveGuildMemberRole g user muteRole

-- TODO: Tempmute - call unmute with reason ["Temporary mute ended"]
