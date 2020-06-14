--------------------------------------------------------------------------------
-- Discord Test Bot                                                           --
--------------------------------------------------------------------------------
-- This source code is licensed under the BSD3 licence found in the LICENSE   --
-- file in the root directory of this source tree.                            --
--                                                                            --
-- Copyright 2020 Oscar Harris (oscar@oscar-h.com)                            --
--------------------------------------------------------------------------------
module Bot.Commands.Admin (
    adminCheck,
    AdminLoggable(..),
    doAdminAction
) where

import           Calamity.Commands.Dsl ( DSLState, requiresPure )

import           Data.Colour (Colour)
import           Data.Default
import qualified Data.Text.Lazy as L ( Text )
import           Data.Time.Clock ( getCurrentTime )
import qualified Data.Vector.Unboxed as V ( elem )

import qualified Polysemy as P

import           Bot.Import

check :: CommandContext -> Maybe L.Text
check ctx = do
    member <- ctx ^. #member
    if Snowflake ***REMOVED*** `V.elem` member ^. #roles then 
        Nothing 
    else 
        Just "You must be an administator to do that"

adminCheck :: Sem (DSLState r) a -> Sem (DSLState r) a
adminCheck = requiresPure [("adminCheck", check)]

class AdminLoggable a where
    colour :: AdminLoggable a => Colour Double
    word :: AdminLoggable a => Text

type ToInvoke = Guild -> GuildRequest ()

doAdminAction :: forall action r u
               . (AdminLoggable action, BotC r, Mentionable u, HasID User u) 
              => CommandContext 
              -> u 
              -> ToInvoke 
              -> [EmbedField] 
              -> Sem r ()
doAdminAction ctx u toInvoke fields = case ctx ^. #guild of
    Nothing -> void $ tellt ctx "Administrator actions must be performed in a guild"
    Just g -> do
        invoke $ toInvoke g
        tellt ctx $ fromStrict (word @action) <> " " <> mention u
        time <- P.embed getCurrentTime
        let embed = def & #title ?~ fromStrict ("User " <> word @action) 
                        & #color ?~ colour @action
                        & #fields .~ EmbedField "User" (mention u) True
                                    : EmbedField "Admin" (mention $ ctx ^. #user) True
                                    : EmbedField "Time" (showtl time) True
                                    : fields
        void $ tell @Embed logChannel embed
