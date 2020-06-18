--------------------------------------------------------------------------------
-- Discord Test Bot                                                           --
--------------------------------------------------------------------------------
-- This source code is licensed under the BSD3 licence found in the LICENSE   --
-- file in the root directory of this source tree.                            --
--                                                                            --
-- Copyright 2020 Oscar Harris (oscar@oscar-h.com)                            --
--------------------------------------------------------------------------------
{-# LANGUAGE TypeApplications #-}

module Main where

import           Calamity.Commands
import           Calamity.Cache.InMemory                    ( runCacheInMemory )
import           Calamity.Metrics.Noop                      ( runMetricsNoop )

import qualified Data.Text.Lazy                             as L

import qualified Polysemy                                   as P

import           TextShow

import Bot.Import
import Bot.Commands
import Bot.Events

main :: IO ()
main = void . P.runFinal . P.embedToFinal . runCacheInMemory . runMetricsNoop . useConstantPrefix "!"
        $ runBotIO botSecret $ do
            -- Commands:
            addCommands $ do
                -- Help command
                helpCommand

                -- Ping Command
                help (const "Replies with 'pong'") $
                    command @'[] "ping" ping

                -- Invite command
                help (const "Returns the invite link to the server") $
                    command @'[] "invite" invite

                -- User Mute
                adminCheck $ help (const "Mutes the given user for the given reason") $
                    command @'[Snowflake User, [Text]] "mute" Bot.Commands.mute

                -- User Unmute
                adminCheck $ help (const "Unmutes the given user for the given reason") $
                    command @'[Snowflake User, [Text]] "unmute" unmute

                -- User Ban
                adminCheck $ help (const "Bans the given user for the given reason") $
                    command @'[Snowflake User, [Text]] "ban" ban
                
                -- User Unban
                adminCheck $ help (const "Unbans the given user for the given reason") $
                    command @'[Snowflake User, [Text]] "unban" unban
                
                -- User Ban
                adminCheck $ help (const "Kicks the given user for the given reason") $
                    command @'[Snowflake User, [Text]] "kick" kick

            -- Event Handlers:
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
