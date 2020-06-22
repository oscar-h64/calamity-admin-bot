--------------------------------------------------------------------------------
-- Calamity Admin Bot                                                         --
--------------------------------------------------------------------------------
-- This source code is licensed under the BSD3 licence found in the LICENSE   --
-- file in the root directory of this source tree.                            --
--                                                                            --
-- Copyright 2020 Oscar Harris (oscar@oscar-h.com)                            --
--------------------------------------------------------------------------------
module Bot.Commands.Mute (
    Bot.Commands.Mute.mute,
    tempmute,
    unmute
) where

import           Control.Concurrent      ( threadDelay )

import           Data.Colour.Names       ( khaki, palevioletred )
import           Data.Time.Clock 
import           Data.Text.Lazy          ( pack )

import qualified Polysemy           as P ( embed )

import           Bot.Import
import           Bot.Commands.Admin

data Mute
data Tempmute
data Unmute

instance AdminLoggable Mute where
    colour = khaki
    word = "Muted"
    phrase = "muted in"

instance AdminLoggable Tempmute where
    colour = khaki
    word = "Temporarily Muted"
    phrase = "temporarily muted in"

instance AdminLoggable Unmute where
    colour = palevioletred
    word = "Unmuted"
    phrase = "unmuted in"

mute :: BotReader r => CommandContext -> Snowflake User -> Maybe Text -> Sem r ()
mute ctx user reason = do
    mr <- bcMuteRole <$> ask
    doAdminAction @Mute ctx user reason [] $
        \g _ -> AddGuildMemberRole g user mr

calcTime :: Text -> NominalDiffTime
calcTime = undefined

tempmute :: BotReader r => CommandContext -> Snowflake User -> Text -> Maybe Text -> Sem r ()
tempmute ctx user length reason = do
    -- TODO: Should check if time is valid first before muting
    let lenTime = calcTime length
    currentTime <- P.embed getCurrentTime
    mr <- bcMuteRole <$> ask
    
    -- Mute User
    doAdminAction 
        @Tempmute 
        ctx 
        user 
        reason 
        [
            EmbedField "Start Time" (showtl currentTime) True,
            EmbedField "Length" (pack $ show lenTime) True,
            EmbedField "End Time" (showtl $ addUTCTime lenTime currentTime) True
        ]
        $ \g _ -> AddGuildMemberRole g user mr
    
    -- Wait for x time
    P.embed $ threadDelay $ truncate $ toRational $ 1000000 * nominalDiffTimeToSeconds lenTime

    -- TODO: This shouldn't respond to context - could field to AdminLoggable to 
    --       determine if it replied to ctx (default to true)
    -- Unmute user
    unmute ctx user $ Just "Temporary Mute Ended"

unmute :: BotReader r => CommandContext -> Snowflake User -> Maybe Text -> Sem r ()
unmute ctx user reason = do
    mr <- bcMuteRole <$> ask
    doAdminAction @Unmute ctx user reason [] $
        \g _ -> RemoveGuildMemberRole g user mr

-- TODO: Tempmute - call unmute with reason ["Temporary mute ended"]
