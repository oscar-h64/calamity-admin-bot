--------------------------------------------------------------------------------
-- Discord Test Bot                                                           --
--------------------------------------------------------------------------------
-- This source code is licensed under the BSD3 licence found in the LICENSE   --
-- file in the root directory of this source tree.                            --
--                                                                            --
-- Copyright 2020 Oscar Harris (oscar@oscar-h.com)                            --
--------------------------------------------------------------------------------
module Bot.Commands.Kick where

import Data.Colour.Names ( darkmagenta )

import Bot.Import
import Bot.Commands.Admin

data Kick

instance AdminLoggable Kick where
    colour = darkmagenta
    word = "Kicked"

kick :: BotC r => CommandContext -> Snowflake User -> [Text] -> Sem r ()
kick ctx u r = 
    let reason = intercalate " " <$> if r == [] then Nothing else Just r
        toInvoke = \(g :: Guild) -> RemoveGuildMember g u
    in
        doAdminAction @Kick 
            ctx 
            u
            toInvoke 
            [EmbedField "Reason" (fromStrict $ fromMaybe "N/A" reason) False]
