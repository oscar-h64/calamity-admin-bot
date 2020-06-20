--------------------------------------------------------------------------------
-- Calamity Admin Bot                                                         --
--------------------------------------------------------------------------------
-- This source code is licensed under the BSD3 licence found in the LICENSE   --
-- file in the root directory of this source tree.                            --
--                                                                            --
-- Copyright 2020 Oscar Harris (oscar@oscar-h.com)                            --
--------------------------------------------------------------------------------
module Bot.Config (
    BotConfig(..)
) where

import Prelude

import Calamity     ( Token, Snowflake, Channel, Role )

import Data.Aeson
import Data.Char    ( isLower, isUpper, toLower )
import Data.Text    ( Text )

import Text.Casing  ( kebab )

import GHC.Generics ( Generic )

data BotConfig = BotConfig {
    bcBotSecret :: Token,
    bcLogChannel :: Snowflake Channel,
    bcMuteRole :: Snowflake Role,
    bcToMuteRoles :: [Snowflake Role],
    bcInviteLink :: Text,
    bcServerName :: Text
} deriving Generic

jsonOpts :: Options
jsonOpts = defaultOptions {
    fieldLabelModifier = toFieldName
}

toFieldName :: String -> String
toFieldName = kebab . while isUpper toLower . dropWhile isLower
    where while _ _ [] = []
          while p f (x:xs)
            | p x       = f x : while p f xs
            | otherwise = x : xs

instance FromJSON Token

instance FromJSON BotConfig where
    parseJSON = genericParseJSON jsonOpts
