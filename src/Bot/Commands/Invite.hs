--------------------------------------------------------------------------------
-- Calamity Admin Bot                                                         --
--------------------------------------------------------------------------------
-- This source code is licensed under the BSD3 licence found in the LICENSE   --
-- file in the root directory of this source tree.                            --
--                                                                            --
-- Copyright 2020 Oscar Harris (oscar@oscar-h.com)                            --
--------------------------------------------------------------------------------
module Bot.Commands.Invite where

import Polysemy.Reader

import Bot.Import

invite :: BotC r => CommandContext -> Sem (Reader BotConfig ': r) ()
invite ctx = do
    link <- inviteLink <$> ask
    void $ tellt ctx (fromStrict $ "Invite Link: " <> link)
