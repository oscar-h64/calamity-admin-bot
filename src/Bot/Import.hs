--------------------------------------------------------------------------------
-- Discord Test Bot                                                           --
--------------------------------------------------------------------------------
-- This source code is licensed under the BSD 3-Clause licence found in the   --
-- LICENSE file in the root directory of this source tree.                    --
--                                                                            --
-- Copyright 2020 Oscar Harris (oscar@oscar-h.com)                            --
--------------------------------------------------------------------------------
module Bot.Import (
    module Bot.Import,
) where

import           Calamity                                   as Bot.Import
import qualified Calamity.Commands.Context                  as CC ( Context(..) )
import           Polysemy                                   as Bot.Import ( Sem(..) )
import qualified DiPolysemy                                 as DiP
import           Data.Maybe                                 as Bot.Import (fromMaybe, maybe)
import           Data.Text                                  as Bot.Import ( Text )
import qualified Data.Text.Lazy                             as L ( Text )
import           Data.Text.Lazy                             as Bot.Import (fromStrict, toStrict)
import           Control.Monad                              as Bot.Import
import           Control.Lens                               as Bot.Import
import           TextShow                                   as Bot.Import ( showt )
import           Prelude                                    as Bot.Import hiding ( error )


logChannel :: Snowflake Channel
logChannel = Snowflake 720278676104806522

info, debug :: BotC r => Text -> Sem r ()
info = DiP.info
debug = DiP.info

tellt :: (BotC r, Tellable t) => t -> L.Text -> Sem r (Either RestError Message)
tellt t m = tell t $ toStrict m

type CommandContext = CC.Context
