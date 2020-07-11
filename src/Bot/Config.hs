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

import           Prelude

import           Calamity            ( Activity, Channel, Message, Role,
                                       Snowflake (..), Token (..), activity )

import           Data.Aeson
import qualified Data.HashMap.Strict as HMS
import qualified Data.Map            as M
import           Data.Maybe          ( fromMaybe )
import           Data.Text           ( Text )
import           Data.Text.Lazy      ( fromStrict )

import           GHC.Generics

data ReactRoleList = ReactRoleList {
    rrlOnlyOne :: Bool,
    rrlRoles   :: HMS.HashMap Text (Snowflake Role)
}

type ReactRoleWatchlist = M.Map (Snowflake Message) ReactRoleList

data BotConfig = BotConfig {
    bcBotSecret       :: Token,
    bcLogChannel      :: Snowflake Channel,
    bcMuteRole        :: Snowflake Role,
    bcToMuteRoles     :: [Snowflake Role],
    bcInviteLink      :: Text,
    bcServerName      :: Text,
    bcBannedFragments :: [Text],
    bcActivity        :: Maybe Activity,
    bcReactRolesAuto  :: Maybe (), -- create messages before starting reader - update watchlist
    bcReactRolesWatch :: Maybe ReactRoleWatchlist
}

data BotActivity = BotActivity ActTypeProxy Text

-- IDs are converted to snowflake after reading rather than reading `Snowflake a`
-- directly as it removes the requirement to put quotes around IDs

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
                    <*> pure Nothing
                    <*> (fmap (M.mapKeys Snowflake) <$> v .:? "react-roles-manual")
        where
            makeActivity (BotActivity atype atext) = activity (fromStrict atext)
                $ toEnum $ fromEnum atype

instance FromJSON ReactRoleList where
    parseJSON = withObject "ReactRoleList" $ \v -> ReactRoleList
                    <$> v .: "only-one"
                    <*> (HMS.map Snowflake <$> v .: "roles")
