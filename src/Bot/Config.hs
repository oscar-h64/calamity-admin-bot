--------------------------------------------------------------------------------
-- Calamity Admin Bot                                                         --
--------------------------------------------------------------------------------
-- This source code is licensed under the BSD3 licence found in the LICENSE   --
-- file in the root directory of this source tree.                            --
--                                                                            --
-- Copyright 2020 Oscar Harris (oscar@oscar-h.com)                            --
--------------------------------------------------------------------------------
module Bot.Config where

import Calamity
import Data.Text

data BotConfig = BotConfig {
    botSecret :: Token,
    logChannel :: Snowflake Channel,
    muteRole :: Snowflake Role,
    toMuteRoles :: [Snowflake Role],
    inviteLink :: Text,
    serverName :: Text
}

tempConf :: BotConfig
tempConf = BotConfig {
    botSecret = BotToken "BOT_SECRET",
    logChannel = Snowflake 000000000000000000,
    muteRole = Snowflake 000000000000000000,
    toMuteRoles = [Snowflake 000000000000000000],
    inviteLink = "INVITE_LINK",
    serverName = "SERVER_NAME"
}

-- -- Replace BOT_SECRET with your client secret
-- botSecret :: Token
-- botSecret = BotToken "BOT_SECRET"

-- -- Replace 000000000000000000 with the ID of the roles able to 
-- -- mute members
-- toMuteRoles :: [Snowflake Role]
-- toMuteRoles = [Snowflake 000000000000000000]

-- -- Replace 000000000000000000 with the ID of your log channel
-- logChannel :: Snowflake Channel
-- logChannel = Snowflake 000000000000000000

-- -- Replace 000000000000000000 with the ID of your mute role
-- muteRole :: Snowflake Role
-- muteRole = Snowflake 000000000000000000

-- -- Replace INVITE_LINK with the invite link of your server
-- inviteLink :: Text
-- inviteLink = "INVITE_LINK"

-- -- Replace SERVER_NAME with the name of your server
-- serverName :: Text
-- serverName = "SERVER_NAME"