module Bot.Events.MessageEdit where

import Calamity.Types.Model.Channel.Message

import Bot.Import

onMessageEdit :: BotC r => Message -> Message -> Sem r ()
onMessageEdit = undefined
