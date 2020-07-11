--------------------------------------------------------------------------------
-- Calamity Admin Bot                                                         --
--------------------------------------------------------------------------------
-- This source code is licensed under the BSD3 licence found in the LICENSE   --
-- file in the root directory of this source tree.                            --
--                                                                            --
-- Copyright 2020 Oscar Harris (oscar@oscar-h.com)                            --
--------------------------------------------------------------------------------
module Bot.Events.MessageCreate where

import qualified Calamity.HTTP.Reason as CR ( reason )

import           Data.Colour.Names    ( cornflowerblue )
import           Data.Default         ( def )

import           Bot.Import

onMessageCreate :: BotReader r => Message -> Sem r ()
onMessageCreate m = do
    let ltext = m ^. #content
        stext = toStrict ltext

    checkFor <- bcBannedFragments <$> ask

    if any (`isInfixOf` stext) checkFor then do
        let author   = m ^. #author
            channel  = m ^. #channelID
            origtime = showtl $ m ^. #timestamp
            embed    = def  & #title ?~ "Banned Fragment Detected"
                            & #color ?~ cornflowerblue
                            & #fields .~ [
                                EmbedField "Channel" (mention channel) True,
                                EmbedField "Author" (mention author) True,
                                EmbedField "Sent" origtime True,
                                EmbedField "Content" ltext False
                        ]

        lc <- bcLogChannel <$> ask
        tell @Embed lc embed

        void $ invoke $ CR.reason "Contains a banned fragment" $ DeleteMessage channel m

    else
        pure ()
