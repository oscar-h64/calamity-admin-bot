--------------------------------------------------------------------------------
-- Calamity Admin Bot                                                         --
--------------------------------------------------------------------------------
-- This source code is licensed under the BSD3 licence found in the LICENSE   --
-- file in the root directory of this source tree.                            --
--                                                                            --
-- Copyright 2020 Oscar Harris (oscar@oscar-h.com)                            --
--------------------------------------------------------------------------------

module Bot.Config (
    ReactRoleList(..),
    ReactRoleWatchlist,
    BotConfig(..)
) where

--------------------------------------------------------------------------------

import           Prelude

import           Calamity            (Emoji,  Activity(..), Channel, Message, Role,
                                       Snowflake (..), Token (..), activity )
import qualified Calamity            as AT ( ActivityType(..) )

import           Data.Aeson
import qualified Data.Map            as M
import           Data.Maybe          ( fromMaybe )
import           Data.Text           ( Text )
import           Data.Text.Lazy      ( fromStrict )

import           GHC.Generics

--------------------------------------------------------------------------------

-- | Represents the roles for a particular react role message. This defines
-- whether to allow more than 1 role, and which reactions map to which roles
data ReactRoleList = ReactRoleList {
    rrlOnlyOne :: Bool,
    rrlRoles   :: M.Map (Snowflake Emoji) (Snowflake Role)
}

instance FromJSON ReactRoleList where
    parseJSON = withObject "ReactRoleList" $ \v -> ReactRoleList
                    <$> v .: "only-one"
                    <*> ((M.mapKeys Snowflake . M.map Snowflake) <$> v .: "roles")

--------------------------------------------------------------------------------

-- | Map of message IDs to role list value
type ReactRoleWatchlist = M.Map (Snowflake Message) ReactRoleList

--------------------------------------------------------------------------------

-- | The configuration for the bot loaded from the config file
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
    bcReactRolesWatch :: ReactRoleWatchlist
}

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
                    <*> (M.mapKeys Snowflake <$> v .:? "react-roles-manual" .!= M.empty)
        where
            makeActivity (BotActivity atype atext) =
                activity (fromStrict atext) $ actProxyToAct atype

--------------------------------------------------------------------------------

-- IDs are converted to snowflake after reading rather than reading `Snowflake a`
-- directly as it removes the requirement to put quotes around IDs

-- FromJSON type for ActivityType is numbers. This gives them
-- appropriate names
data ActTypeProxy = Playing | Listening | Watching
    deriving (Show, Read, Generic)

instance FromJSON ActTypeProxy

actProxyToAct :: ActTypeProxy -> AT.ActivityType
actProxyToAct Playing = AT.Game
actProxyToAct Listening = AT.Listening
actProxyToAct Watching = AT.Custom

--------------------------------------------------------------------------------

-- | Represents an activity for the bot
data BotActivity = BotActivity ActTypeProxy Text

instance FromJSON BotActivity where
    parseJSON = withObject "BotActivity" $ \v -> BotActivity
                    <$> v .: "type"
                    <*> v .: "text"

--------------------------------------------------------------------------------
