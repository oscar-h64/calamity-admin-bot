--------------------------------------------------------------------------------
-- Calamity Admin Bot                                                         --
--------------------------------------------------------------------------------
-- This source code is licensed under the BSD3 licence found in the LICENSE   --
-- file in the root directory of this source tree.                            --
--                                                                            --
-- Copyright 2020 Oscar Harris (oscar@oscar-h.com)                            --
--------------------------------------------------------------------------------
module Bot.Events (
    onReady,
    onMessageCreate,
    onMessageEdit,
    onMessageDelete
) where

import Bot.Events.Ready
import Bot.Events.MessageCreate
import Bot.Events.MessageEdit
import Bot.Events.MessageDelete
