# Calamity Admin Bot

![Haskell CI](https://github.com/oscar-h64/calamity-admin-bot/workflows/Haskell%20CI/badge.svg)

This is a discord bot written in Haskell using the [calamity library](https://hackage.haskell.org/package/calamity). Its aim is to be a server administration bot with the following features:

- The following commands:
    - `!ping`: The command every bot needs - simply replies with "pong"
    - `!invite`: Returns an invite link to the server
    - `!kick :u :r`: Kicks the user `u`, optionally with the reason `r`
    - `!mute :u :r`: Mutes the user `u`, optionally with the reason `r` (by giving user a `Muted` role)
    - `!unmute :u :r`: Unmutes the user `u`, optionally with the reason `r`
    - `!tempmute :u :t :r`: Mutes the user `u` for `t` time optionall with reason `r` (NOT YET COMPLETE)
    - `!ban :u :r`: Bans the user `u` optionally with reason `r`
    - `!unban :u :r`: Unbans the user `u`, optionally with reason `r`
    - `!bulkban :u1 :u2 ... :un :r`: Bans all the given users, optionally with reason `r`. Accepts any number of users
    - Note that all commands that take a user/users accept either a mention or just the ID. Banning will work even if the user is not in the server
    - Commands from `kick` onwards require the user to have an "Administrator" role
- Message edits and deletes are logged into a log channel
- Administrator actions (commands from `kick` onwards) are logged into the log channel, and a suitable reason is provided with the request for Discord's audit log
- Filtering based on message content (NOT YET COMPLETE)
- Custom activity for the bot (NOT YET COMPLETE)
- Reaction roles (NOT YET COMPLETE)

See [here](https://github.com/oscar-h64/calamity-admin-bot/issues?q=is%3Aissue+is%3Aopen+label%3Aenhancement) for a list of features planned. If there is a feature you would like feel free to open an issue (or a pull request!) with the label `enhancement` 

## Setup
1. Update `src/Bot/Config.hs` with the settings for your server (the file is commented to assist with this)
2. Install the Haskell `stack` tool - see [here](https://docs.haskellstack.org/en/stable/install_and_upgrade/)
3. Clone this repository:
```bash
git clone https://github.com/oscar-h64/calamity-admin-bot.git
```
4. Build the bot
```bash
# Replace bin/ with where you want the executable to be stored
stack install --local-bin-path=bin/
```
5. Run the executable to start the bot

## Contributing
Issues and pull requests are always welcome - see [CONTRIBUTING.md](CONTRIBUTING.md) for more details
