--------------------------------------------------------------------------------
-- Discord Test Bot                                                           --
--------------------------------------------------------------------------------
-- This source code is licensed under the BSD3 licence found in the LICENSE   --
-- file in the root directory of this source tree.                            --
--                                                                            --
-- Copyright 2020 Oscar Harris (oscar@oscar-h.com)                            --
--------------------------------------------------------------------------------
module Bot.Commands.Ban where

import Bot.Import

ban :: BotC r => CommandContext -> User -> Maybe Text -> Sem r ()
ban ctx u reason = case ctx ^. #guild of
        Nothing -> void $ tellt ctx "An error occurred while banning: Command must be executed in a guild"
        Just g -> void $ invoke $ CreateGuildBan g u $ CreateGuildBanData Nothing reason 
