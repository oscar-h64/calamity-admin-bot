--------------------------------------------------------------------------------
-- Discord Test Bot                                                           --
--------------------------------------------------------------------------------
-- This source code is licensed under the BSD3 licence found in the LICENSE   --
-- file in the root directory of this source tree.                            --
--                                                                            --
-- Copyright 2020 Oscar Harris (oscar@oscar-h.com)                            --
--------------------------------------------------------------------------------
module Bot.Commands.Admin (
    adminCheck
) where

import Calamity.Commands.Dsl ( DSLState, requiresPure )
import qualified Data.Text.Lazy as L ( Text )
import qualified Data.Vector.Unboxed as V ( elem )

import Bot.Import

check :: CommandContext -> Maybe L.Text
check ctx = do
    member <- ctx ^. #member
    if Snowflake 720279447776788540 `V.elem` member ^. #roles then 
        Nothing 
    else 
        Just "You must be an administator to do that"

adminCheck :: Sem (DSLState r) a -> Sem (DSLState r) a
adminCheck = requiresPure [("adminCheck", check)]
