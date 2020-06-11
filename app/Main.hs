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

main :: IO ()
main = void . P.runFinal . P.embedToFinal . runCacheInMemory . runMetricsNoop . useConstantPrefix "!"
        $ runBotIO secret $ do
            -- Commands:
            addCommands $ do
                -- Help command
                helpCommand

                -- Ping Command
                command @'[] "ping" ping
              
            -- Event Handlers:
            react @('CustomEvt "command-error" (CommandContext, CommandError)) $ \(ctx, e) -> do
              info $ "Command failed with reason: " <> showt e
              case e of
                ParseError n r -> void . tellt ctx $ "Failed to parse parameter: `" <> L.fromStrict n <> "`, with reason: ```\n" <> r <> "```"
