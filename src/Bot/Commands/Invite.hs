--------------------------------------------------------------------------------
-- Calamity Admin Bot                                                         --
--------------------------------------------------------------------------------
-- This source code is licensed under the BSD3 licence found in the LICENSE   --
-- file in the root directory of this source tree.                            --
--                                                                            --
-- Copyright 2020 Oscar Harris (oscar@oscar-h.com)                            --
--------------------------------------------------------------------------------
module Bot.Commands.Invite where

import qualified Polysemy        as P
import qualified Polysemy.Reader as P

import Bot.Import

invite :: BotReader r => CommandContext -> Sem r ()
invite ctx = do
    link <- bcInviteLink <$> ask
    void $ tellt ctx (fromStrict $ "Invite Link: " <> link)
