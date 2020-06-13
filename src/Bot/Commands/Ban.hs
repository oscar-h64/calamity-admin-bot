--------------------------------------------------------------------------------
-- Discord Test Bot                                                           --
--------------------------------------------------------------------------------
-- This source code is licensed under the BSD3 licence found in the LICENSE   --
-- file in the root directory of this source tree.                            --
--                                                                            --
-- Copyright 2020 Oscar Harris (oscar@oscar-h.com)                            --
--------------------------------------------------------------------------------
module Bot.Commands.Ban where

import Data.Colour.Names ( springgreen, mediumpurple )

import Bot.Commands.Admin
import Bot.Import

data Ban
data Unban

instance AdminLoggable Ban where
    colour = springgreen
    word = "Banned"

instance AdminLoggable Unban where
    colour = mediumpurple
    word = "Unbanned"

ban :: BotC r => CommandContext -> User -> [Text] -> Sem r ()
ban ctx u r = 
    let reason = intercalate " " <$> if r == [] then Nothing else Just r
        toInvoke = \(g :: Guild) -> CreateGuildBan g u $ CreateGuildBanData Nothing reason 
    in
        doAdminAction @Ban ctx u toInvoke [EmbedField "Reason" (fromStrict $ fromMaybe "N/A" reason) False]

unban :: BotC r => CommandContext -> User -> [Text] -> Sem r ()
unban ctx u r = 
    let reason = intercalate " " <$> if r == [] then Nothing else Just r
        toInvoke = \(g :: Guild) -> RemoveGuildBan g u
    in
        doAdminAction @Unban ctx u toInvoke [EmbedField "Reason" (fromStrict $ fromMaybe "N/A" reason) False]
