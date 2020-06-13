--------------------------------------------------------------------------------
-- Discord Test Bot                                                           --
--------------------------------------------------------------------------------
-- This source code is licensed under the BSD3 licence found in the LICENSE   --
-- file in the root directory of this source tree.                            --
--                                                                            --
-- Copyright 2020 Oscar Harris (oscar@oscar-h.com)                            --
--------------------------------------------------------------------------------
module Bot.Commands.Ban where

import Data.Text (pack)
import Data.Colour.Names
import Data.Default
import Data.Time.Clock

import Polysemy as P (embed)

import Bot.Import

ban :: BotC r => CommandContext -> User -> [Text] -> Sem r ()
ban ctx u r = do
    let reason = intercalate " " <$> if r == [] then Nothing else Just r
    time <- P.embed getCurrentTime
    case ctx ^. #guild of
        Nothing -> void $ tellt ctx "An error occurred while banning: Command must be executed in a guild"
        Just g -> do
            result <- invoke $ CreateGuildBan g u $ CreateGuildBanData Nothing reason 
            void $ tellt ctx $ "Banned " <> mention u
            let embed = def & #title ?~ "User Banned" 
                    & #color ?~ springgreen
                    & #fields .~ [
                        EmbedField "User" (mention u) True,
                        EmbedField "Admin" (mention $ ctx ^. #user) True,
                        EmbedField "Time" (showtl time) True,
                        EmbedField "Reason" (fromStrict $ fromMaybe "N/A" reason) False
                    ]
            void $ tell @Embed logChannel embed
