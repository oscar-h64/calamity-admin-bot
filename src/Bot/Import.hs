module Bot.Import (
    module Bot.Import,
    module L,
) where

import           Calamity                                   as Bot.Import
import qualified Calamity.Commands.Context                  as CC ( Context(..) )
import           Polysemy                                   as Bot.Import ( Sem(..) )
import qualified DiPolysemy                                 as DiP
import           Data.Text                                  as Bot.Import ( Text )
import qualified Data.Text.Lazy                             as L
import           Control.Monad                              as Bot.Import
import           Prelude                                    as Bot.Import hiding ( error )

info, debug :: BotC r => Text -> Sem r ()
info = DiP.info
debug = DiP.info

tellt :: (BotC r, Tellable t) => t -> L.Text -> Sem r (Either RestError Message)
tellt t m = tell t $ L.toStrict m

type CommandContext = CC.Context