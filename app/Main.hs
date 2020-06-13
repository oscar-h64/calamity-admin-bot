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

import Bot.Secret
import Bot.Import
import Bot.Commands
import Bot.Events

main :: IO ()
main = void . P.runFinal . P.embedToFinal . runCacheInMemory . runMetricsNoop . useConstantPrefix "!"
        $ runBotIO secret $ do
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

                -- User Ban
                adminCheck $ help (const "Bans the given user for the given reason") $
                    command @'[User, [Text]] "ban" ban
                
                -- User Unban
                adminCheck $ help (const "Unbans the given user for the given reason") $
                    command @'[User, [Text]] "unban" unban

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
