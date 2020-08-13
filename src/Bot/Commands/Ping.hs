--------------------------------------------------------------------------------
-- Calamity Admin Bot                                                         --
--------------------------------------------------------------------------------
-- This source code is licensed under the BSD3 licence found in the LICENSE   --
-- file in the root directory of this source tree.                            --
--                                                                            --
-- Copyright 2020 Oscar Harris (oscar@oscar-h.com)                            --
--------------------------------------------------------------------------------
module Bot.Commands.Ping where

import Bot.Import

-- | `ping` @ctx@ is a handler for the ping command. It uses tellt to reply to
-- the user with "Pong!" in the same context the command was sent
ping :: (BotC r) => CommandContext -> Sem r ()
ping = void . flip tellt "Pong!"
