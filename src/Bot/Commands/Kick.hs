--------------------------------------------------------------------------------
-- Calamity Admin Bot                                                         --
--------------------------------------------------------------------------------
-- This source code is licensed under the BSD3 licence found in the LICENSE   --
-- file in the root directory of this source tree.                            --
--                                                                            --
-- Copyright 2020 Oscar Harris (oscar@oscar-h.com)                            --
--------------------------------------------------------------------------------

module Bot.Commands.Kick where

--------------------------------------------------------------------------------

import Data.Colour.Names  ( darkmagenta )

import Bot.Commands.Admin
import Bot.Import

--------------------------------------------------------------------------------

data Kick

instance AdminLoggable Kick where
    colour = darkmagenta
    word = "Kicked"
    phrase = "kicked from"

--------------------------------------------------------------------------------

kick :: BotReader r => CommandContext -> Snowflake User -> Maybe Text -> Sem r ()
kick ctx user reason =
    doAdminAction @Kick ctx user reason [] $
        \g _ -> RemoveGuildMember g user

--------------------------------------------------------------------------------
