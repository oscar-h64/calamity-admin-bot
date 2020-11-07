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

--------------------------------------------------------------------------------

import           Control.Concurrent   ( threadDelay )

import           Data.Colour.Names    ( khaki, palevioletred )
import           Data.Text            ( unpack )
import           Data.Text.Lazy       ( pack )
import           Data.Time.Clock
import           Data.Time.SuffixRead ( readSuffixTime )

import qualified Polysemy             as P ( embed )

import           Bot.Commands.Admin
import           Bot.Import

--------------------------------------------------------------------------------

data Mute
data Tempmute
data Unmute
data Untempmute

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

instance AdminLoggable Untempmute where
    colour = palevioletred
    word = "Unmuted"
    phrase = "unmuted in"
    tellContext = False

--------------------------------------------------------------------------------

mute :: BotReader r => CommandContext -> Snowflake User -> Maybe Text -> Sem r ()
mute ctx user reason = do
    mr <- bcMuteRole <$> ask
    doAdminAction @Mute ctx user reason [] $
        \g _ -> AddGuildMemberRole g user mr

tempmute :: BotReader r => CommandContext -> Snowflake User -> Text -> Maybe Text -> Sem r ()
tempmute ctx user length reason = do
    case readSuffixTime (unpack length) of
        Nothing -> void $ tell ctx $ "Invalid Time: " <> length
        Just lenTime -> do
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

            -- Unmute user
            doUnmute @Untempmute ctx user $ Just "Temporary Mute Ended"

doUnmute :: forall action r
        . (AdminLoggable action, BotReader r)
       => CommandContext
       -> Snowflake User
       -> Maybe Text
       -> Sem r ()
doUnmute ctx user reason = do
    mr <- bcMuteRole <$> ask
    doAdminAction @action ctx user reason [] $
        \g _ -> RemoveGuildMemberRole g user mr

unmute :: BotReader r => CommandContext -> Snowflake User -> Maybe Text -> Sem r ()
unmute = doUnmute @Unmute

--------------------------------------------------------------------------------
