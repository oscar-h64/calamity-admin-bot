--------------------------------------------------------------------------------
-- Discord Test Bot                                                           --
--------------------------------------------------------------------------------
-- This source code is licensed under the BSD3 licence found in the LICENSE   --
-- file in the root directory of this source tree.                            --
--                                                                            --
-- Copyright 2020 Oscar Harris (oscar@oscar-h.com)                            --
--------------------------------------------------------------------------------
module Bot.Config where

import Calamity
import Data.Text

-- Replace 000000000000000000 with the ID of your log channel
logChannel :: Snowflake Channel
logChannel = Snowflake 000000000000000000

-- Replace 000000000000000000 with the ID of your mute role
muteRole :: Snowflake Role
muteRole = Snowflake 000000000000000000

-- Replace 000000000000000000 with the ID of your admin role
adminRole :: Snowflake Role
adminRole = Snowflake 000000000000000000

-- Replace SERVER_NAME with the name of your server
serverName :: Text
serverName = "SERVER_NAME"