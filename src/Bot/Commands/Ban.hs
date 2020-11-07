--------------------------------------------------------------------------------
-- Calamity Admin Bot                                                         --
--------------------------------------------------------------------------------
-- This source code is licensed under the BSD3 licence found in the LICENSE   --
-- file in the root directory of this source tree.                            --
--                                                                            --
-- Copyright 2020 Oscar Harris (oscar@oscar-h.com)                            --
--------------------------------------------------------------------------------

module Bot.Commands.Ban where

--------------------------------------------------------------------------------

import Data.Colour.Names  ( mediumpurple, springgreen )

import Bot.Commands.Admin
import Bot.Import

--------------------------------------------------------------------------------

data Ban
data Unban

instance AdminLoggable Ban where
    colour = springgreen
    word = "Banned"
    phrase = "banned from"

instance AdminLoggable Unban where
    colour = mediumpurple
    word = "Unbanned"
    phrase = "unbanned from"

--------------------------------------------------------------------------------

ban :: BotReader r => CommandContext -> Snowflake User -> Maybe Text -> Sem r ()
ban ctx user reason =
    doAdminAction @Ban ctx user reason [] $
        \g r -> CreateGuildBan g user $ CreateGuildBanData Nothing r

unban :: BotReader r => CommandContext -> Snowflake User -> Maybe Text -> Sem r ()
unban ctx user reason =
    doAdminAction @Unban ctx user reason [] $
        \g _ -> RemoveGuildBan g user

bulkban :: BotReader r => CommandContext -> [Snowflake User] -> Maybe Text -> Sem r ()
bulkban ctx users reason = mapM_ (\u -> ban ctx u reason) users

--------------------------------------------------------------------------------
