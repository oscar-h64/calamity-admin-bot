--------------------------------------------------------------------------------
-- Calamity Admin Bot                                                         --
--------------------------------------------------------------------------------
-- This source code is licensed under the BSD3 licence found in the LICENSE   --
-- file in the root directory of this source tree.                            --
--                                                                            --
-- Copyright 2020 Oscar Harris (oscar@oscar-h.com)                            --
--------------------------------------------------------------------------------
module Bot.Events.Ready ( onReady ) where

import Calamity.Gateway                ( StatusUpdateData(..) )
import Calamity.Gateway.DispatchEvents ( ReadyData )

import Bot.Import

onReady :: BotReader r => ReadyData -> Sem r ()
onReady _ = do
    maybeAct <- bcActivity <$> ask
    sendPresence $ StatusUpdateData Nothing maybeAct "" False