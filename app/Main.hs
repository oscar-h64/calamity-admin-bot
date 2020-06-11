{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeApplications #-}


module Main where

import           Calamity
import           Calamity.Cache.InMemory
import           Calamity.Commands
import qualified Calamity.Commands.Context                  as CommandContext
import           Calamity.Metrics.Noop

import           Control.Monad

import           Data.Text                                  ( Text )
import qualified Data.Text.Lazy                             as L

import qualified DiPolysemy                                 as DiP

import qualified Polysemy                                   as P

import           Prelude                                    hiding ( error )

import           TextShow

import Bot.Secret

info, debug :: BotC r => Text -> P.Sem r ()
info = DiP.info
debug = DiP.info

tellt :: (BotC r, Tellable t) => t -> L.Text -> P.Sem r (Either RestError Message)
tellt t m = tell t $ L.toStrict m

main :: IO ()
main = void . P.runFinal . P.embedToFinal . runCacheInMemory . runMetricsNoop . useConstantPrefix "!"
        $ runBotIO secret $ do
            -- Commands:
            addCommands $ do
                -- Help command
                helpCommand

                -- Ping Command
                command @'[] "ping" $ void . flip tellt "pong"
              
            -- Event Handlers:
            react @('CustomEvt "command-error" (CommandContext.Context, CommandError)) $ \(ctx, e) -> do
              info $ "Command failed with reason: " <> showt e
              case e of
                ParseError n r -> void . tellt ctx $ "Failed to parse parameter: `" <> L.fromStrict n <> "`, with reason: ```\n" <> r <> "```"
