--------------------------------------------------------------------------------
-- Calamity Admin Bot                                                         --
--------------------------------------------------------------------------------
-- This source code is licensed under the BSD3 licence found in the LICENSE   --
-- file in the root directory of this source tree.                            --
--                                                                            --
-- Copyright 2020 Oscar Harris (oscar@oscar-h.com)                            --
--------------------------------------------------------------------------------

module Bot.Events.ReactionAdd ( onReactionAdd ) where

--------------------------------------------------------------------------------

import qualified Data.Map as M

import Bot.Config
import Bot.Import

--------------------------------------------------------------------------------

onReactionAdd :: BotReader r => Reaction -> Sem r ()
onReactionAdd Reaction{..} = do
    roles <- asks bcReactRolesWatch
    case M.lookup messageID roles of
        Nothing -> pure ()
        Just ReactRoleList{..} -> pure ()

--------------------------------------------------------------------------------
