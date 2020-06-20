--------------------------------------------------------------------------------
-- Calamity Admin Bot                                                         --
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

mute :: BotC r => CommandContext -> Snowflake User -> Maybe Text -> Sem (Reader BotConfig ': r) ()
mute ctx user reason = do
    mr <- muteRole <$> ask
    doAdminAction @Mute ctx user reason [] $
        \g _ -> AddGuildMemberRole g user mr

unmute :: BotC r => CommandContext -> Snowflake User -> Maybe Text -> Sem (Reader BotConfig ': r) ()
unmute ctx user reason = do
    mr <- muteRole <$> ask
    doAdminAction @Unmute ctx user reason [] $
        \g _ -> RemoveGuildMemberRole g user mr

-- TODO: Tempmute - call unmute with reason ["Temporary mute ended"]
