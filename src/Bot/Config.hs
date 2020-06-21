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

import Calamity       ( Token(..), Snowflake(..), Channel, Role )

import Data.Aeson
import Data.Text      ( Text )

data BotConfig = BotConfig {
    bcBotSecret       :: Token,
    bcLogChannel      :: Snowflake Channel,
    bcMuteRole        :: Snowflake Role,
    bcToMuteRoles     :: [Snowflake Role],
    bcInviteLink      :: Text,
    bcServerName      :: Text,
    bcBannedFragments :: [Text]
}

instance FromJSON BotConfig where
    parseJSON = withObject "BotConfig" $ \v -> BotConfig
                    <$> (BotToken <$> v .: "bot-secret")
                    <*> (Snowflake <$> v .: "log-channel")
                    <*> (Snowflake <$> v .: "mute-role")
                    <*> (map (Snowflake) <$> (v .: "to-mute-roles"))
                    <*> v .: "invite-link"
                    <*> v .: "server-name"
                    <*> v .: "banned-fragments"
