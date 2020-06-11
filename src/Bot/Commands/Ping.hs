module Bot.Commands.Ping where

import Bot.Import

ping :: (BotC r) => CommandContext -> Sem r ()
ping = void . flip tellt "pong"
