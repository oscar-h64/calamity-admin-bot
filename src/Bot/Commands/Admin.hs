--------------------------------------------------------------------------------
-- Calamity Admin Bot                                                         --
--------------------------------------------------------------------------------
-- This source code is licensed under the BSD3 licence found in the LICENSE   --
-- file in the root directory of this source tree.                            --
--                                                                            --
-- Copyright 2020 Oscar Harris (oscar@oscar-h.com)                            --
--------------------------------------------------------------------------------
module Bot.Commands.Admin (
    AdminLoggable(..),
    doAdminAction
) where

import qualified Calamity.HTTP.Reason as CR (reason) 

import           Data.Colour (Colour)
import           Data.Default
import           Data.Time.Clock ( getCurrentTime )

import qualified Polysemy as P

import           Bot.Import

class AdminLoggable a where
    colour :: AdminLoggable a => Colour Double
    word :: AdminLoggable a => Text
    phrase :: AdminLoggable a => Text

type ToInvoke = Guild -> Maybe Text -> GuildRequest ()

doAdminAction :: forall action r u
               . (AdminLoggable action, BotReader r, Mentionable u, HasID User u) 
              => CommandContext 
              -> u
              -> Maybe Text
              -> [EmbedField]
              -> ToInvoke 
              -> Sem r ()
doAdminAction ctx u reasonM fields toInvoke = case ctx ^. #guild of
    Nothing -> void $ tellt ctx "Administrator actions must be performed in a guild"
    Just g -> do
        let 
            admin = ctx ^. #user
            -- Blank if no reason, otherwise reason
            rna = fromMaybe "N/A" reasonM
            -- Blank if no reason, otherwise " for " <> reason - useful for including reason in messages
            rpr = fromMaybe "" $ (" for " <>) <$> reasonM
            -- Reason to send with request
            rr = "Requested by " <> toStrict (displayUser admin) <> rpr
        -- Bot config:
        conf <- ask

        invoke $ CR.reason rr $ toInvoke g reasonM
        dmChannel <- invoke $ CreateDM u
        
        case dmChannel of 
            Left _   -> return ()
            Right dm -> void $ tellt dm $ fromStrict $ 
                            "You have been " <> phrase @action <> " " <> serverName conf <> rpr  

        tellt ctx $ fromStrict (word @action) <> " " <> mention u
        time <- P.embed getCurrentTime
        let embed = def & #title ?~ fromStrict ("User " <> word @action) 
                        & #color ?~ colour @action
                        & #fields .~  EmbedField "User" (mention u) True
                                    : EmbedField "Admin" (mention admin) True
                                    : EmbedField "Time" (showtl time) True
                                    : EmbedField "Reason" (fromStrict rna) False
                                    : fields
        void $ tell @Embed (logChannel conf) embed
