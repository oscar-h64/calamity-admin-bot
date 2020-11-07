--------------------------------------------------------------------------------
-- Calamity Admin Bot                                                         --
--------------------------------------------------------------------------------
-- This source code is licensed under the BSD3 licence found in the LICENSE   --
-- file in the root directory of this source tree.                            --
--                                                                            --
-- Copyright 2020 Oscar Harris (oscar@oscar-h.com)                            --
--------------------------------------------------------------------------------
module Bot.Commands.Check (
    muteCheck,
    kickCheck,
    banCheck
) where

import           Calamity.Commands.Dsl ( DSLState, requiresPure )
import           Data.Flags            ( (.*.) )
import qualified Data.Text.Lazy        as L ( Text )
import qualified Data.Vector.Unboxing  as V ( elem )

import           Bot.Import

testPermission :: Permissions -> CommandContext -> Maybe L.Text
testPermission permission ctx = do
    member <- ctx ^. #member
    guild <- ctx ^. #guild
    if any (\p -> basePermissions guild member .*. p == p) [permission, administrator] then
        Nothing
    else
        Just "You do not have permission to do that"

testRoles :: [Snowflake Role] -> CommandContext -> Maybe L.Text
testRoles roles ctx = do
    member <- ctx ^. #member
    if any (`V.elem` (member ^. #roles)) roles then
        Nothing
    else
        Just "You do not have permission to do that"

muteCheck :: [Snowflake Role] -> Sem (DSLState r) a -> Sem (DSLState r) a
muteCheck rs = requiresPure [("Mute Permission Check", testRoles rs)]

kickCheck :: Sem (DSLState r) a -> Sem (DSLState r) a
kickCheck = requiresPure [("Kick Permission Check", testPermission kickMembers)]

banCheck :: Sem (DSLState r) a -> Sem (DSLState r) a
banCheck = requiresPure [("Ban Permission Check", testPermission banMembers)]
