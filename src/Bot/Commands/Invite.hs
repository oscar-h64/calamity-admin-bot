--------------------------------------------------------------------------------
-- Discord Test Bot                                                           --
--------------------------------------------------------------------------------
-- This source code is licensed under the BSD3 licence found in the LICENSE   --
-- file in the root directory of this source tree.                            --
--                                                                            --
-- Copyright 2020 Oscar Harris (oscar@oscar-h.com)                            --
--------------------------------------------------------------------------------
module Bot.Commands.Invite where

import Bot.Import

invite :: BotC r => CommandContext -> Sem r ()
invite = void . flip tellt (fromStrict $ "Invite Link: " <> inviteLink)
