--------------------------------------------------------------------------------
-- Calamity Admin Bot                                                         --
--------------------------------------------------------------------------------
-- This source code is licensed under the BSD3 licence found in the LICENSE   --
-- file in the root directory of this source tree.                            --
--                                                                            --
-- Copyright 2020 Oscar Harris (oscar@oscar-h.com)                            --
--------------------------------------------------------------------------------
module Bot.Import (
    module Bot.Import,
) where

import           Calamity                                   as Bot.Import
import qualified Calamity.Commands.Context                  as CC ( Context(..) )
import           Calamity.Commands.Parser                   ( KleenePlusConcat )
import           Polysemy                                   as Bot.Import ( Sem(..) )
import           Polysemy.Reader                            as Bot.Import
import qualified Polysemy                                   as P
import qualified DiPolysemy                                 as DiP
import           Data.Maybe                                 as Bot.Import (fromMaybe, maybe, isJust)
import           Data.Text                                  as Bot.Import ( Text, intercalate )
import qualified Data.Text.Lazy                             as L ( Text )
import           Data.Text.Lazy                             as Bot.Import (fromStrict, toStrict)
import           Control.Monad                              as Bot.Import
import           Lens.Micro                                 as Bot.Import
import           TextShow                                   as Bot.Import ( showt, showtl )
import           Prelude                                    as Bot.Import hiding ( error )

import           Bot.Config                                 as Bot.Import

type BotReader r = (P.Member (Reader BotConfig) r, BotC r)

info, debug :: BotC r => Text -> Sem r ()
info = DiP.info
debug = DiP.info

tellt :: (BotC r, Tellable t) => t -> L.Text -> Sem r (Either RestError Message)
tellt t m = tell t $ toStrict m

type CommandContext = CC.Context
type ActionReason = Maybe (KleenePlusConcat Text)
