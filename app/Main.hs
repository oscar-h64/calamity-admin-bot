--------------------------------------------------------------------------------
-- Calamity Admin Bot                                                         --
--------------------------------------------------------------------------------
-- This source code is licensed under the BSD3 licence found in the LICENSE   --
-- file in the root directory of this source tree.                            --
--                                                                            --
-- Copyright 2020 Oscar Harris (oscar@oscar-h.com)                            --
--------------------------------------------------------------------------------
{-# LANGUAGE TypeApplications #-}

module Main where

import           Calamity.Cache.InMemory        ( runCacheInMemory )
import           Calamity.Commands
import           Calamity.Commands.Command      ( Command )
import           Calamity.Commands.CommandUtils ( CommandForParsers,
                                                  TypedCommandC )
import           Calamity.Metrics.Noop          ( runMetricsNoop )

import qualified Data.Text.Lazy                 as L
import           Data.Yaml                      ( decodeFileEither,
                                                  prettyPrintParseException )

import qualified Polysemy                       as P
import qualified Polysemy.Reader                as P

import           TextShow

import           Bot.Commands
import           Bot.Commands.Check
import           Bot.Events
import           Bot.Import

-- | `botCommands` @toMuteRoles@ represents a list of commands the bot supports.
-- Mute related commands are restricted to users with at least one role from the
-- roles represented by @toMuteRoles@
botCommands :: (BotReader r, P.Member ParsePrefix r)
            => [Snowflake Role]
            -> Sem (DSLState r) Command
botCommands toMuteRoles = do
    -- Help command
    helpCommand

    -- Ping Command
    help (const "Replies with 'pong'") $
        command @'[] "ping" ping

    -- Invite command
    help (const "Returns the invite link to the server") $
        command @'[] "invite" invite

    -- User Mute
    muteCheck toMuteRoles $ help (const "Mutes the given user for the given reason") $
        command @'[Snowflake User, ActionReason] "mute" Bot.Commands.mute

    -- User Tempmute
    muteCheck toMuteRoles $ help (const "Mutes the given user for the given time for the given reason") $
        command @'[Snowflake User, Text, ActionReason] "tempmute" tempmute

    -- User Unmute
    muteCheck toMuteRoles $ help (const "Unmutes the given user for the given reason") $
        command @'[Snowflake User, ActionReason] "unmute" unmute

    -- User Ban
    banCheck $ help (const "Bans the given user for the given reason") $
        command @'[Snowflake User, ActionReason] "ban" ban

    -- User Unban
    banCheck $ help (const "Unbans the given user for the given reason") $
        command @'[Snowflake User, ActionReason] "unban" unban

    -- Bulk user ban
    banCheck $ help (const "Bans the given users for the given reason") $
        command @'[[Snowflake User], ActionReason] "bulkban" bulkban

    -- User Kick
    kickCheck $ help (const "Kicks the given user for the given reason") $
        command @'[Snowflake User, ActionReason] "kick" kick

runBot :: BotConfig -> IO ()
runBot conf = void . P.runFinal . P.embedToFinal . runCacheInMemory . runMetricsNoop . useConstantPrefix "!"
    $ runBotIO (bcBotSecret conf) $ P.runReader conf $ do
        -- Commands:
        addCommands $ botCommands $ bcToMuteRoles conf

        -- Event Handlers:
        -- Ready:
        react @'ReadyEvt onReady

        -- Message Create:
        react @'MessageCreateEvt onMessageCreate

        -- Message Edit:
        react @'MessageUpdateEvt $ uncurry onMessageEdit

        -- Message Delete:
        react @'MessageDeleteEvt onMessageDelete

        -- Command Error Event
        react @('CustomEvt "command-error" (CommandContext, CommandError)) $ \(ctx, e) -> do
            info $ "Command failed with reason: " <> showt e
            case e of
                ParseError n r -> void . tellt ctx $
                    "Failed to parse parameter: `" <> L.fromStrict n <> "`, with reason: ```\n" <> r <> "```"
                CheckError n r -> void . tellt ctx $
                    "The following check failed: " <> codeline (L.fromStrict n) <> ", with reason: " <> codeblock' Nothing r

main :: IO ()
main = do
    conf <- decodeFileEither "config/settings.yaml"
    case conf of
        Left err   -> putStrLn $ prettyPrintParseException err
        Right conf -> runBot conf

