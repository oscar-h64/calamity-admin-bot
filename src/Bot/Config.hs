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

import Calamity       ( activity, Activity, Token(..), Snowflake(..), Channel, Role )

import Data.Aeson
import Data.Maybe     ( fromMaybe )
import Data.Text      ( Text )
import Data.Text.Lazy ( fromStrict )

import GHC.Generics

data BotConfig = BotConfig {
    bcBotSecret       :: Token,
    bcLogChannel      :: Snowflake Channel,
    bcMuteRole        :: Snowflake Role,
    bcToMuteRoles     :: [Snowflake Role],
    bcInviteLink      :: Text,
    bcServerName      :: Text,
    bcBannedFragments :: [Text],
    bcActivity        :: Maybe Activity
}

data BotActivity = BotActivity ActTypeProxy Text

-- FromJSON type for ActivityType is numbers. This gives them 
-- appropriate names. Note unused is there because the streaming 
-- option says playing and says live on twitch. Since there is
-- no ability to add links with the bot this would be stupid
data ActTypeProxy = Playing | Unused | Listening | Watching
    deriving (Show, Read, Enum, Generic)

instance FromJSON ActTypeProxy

instance FromJSON BotActivity where
    parseJSON = withObject "BotActivity" $ \v -> BotActivity
                    <$> v .: "type"
                    <*> v .: "text"

instance FromJSON BotConfig where
    parseJSON = withObject "BotConfig" $ \v -> BotConfig
                    <$> (BotToken <$> v .: "bot-secret")
                    <*> (Snowflake <$> v .: "log-channel")
                    <*> (Snowflake <$> v .: "mute-role")
                    <*> (map (Snowflake) <$> (v .: "to-mute-roles"))
                    <*> v .: "invite-link"
                    <*> v .: "server-name"
                    <*> (fromMaybe [] <$> v .:? "banned-fragments")
                    <*> (fmap makeActivity <$> v .:? "activity")
        where
            makeActivity (BotActivity atype atext) = activity (fromStrict atext) (toEnum $ fromEnum atype)
            