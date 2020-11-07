# Calamity Admin Bot

![Haskell CI](https://github.com/oscar-h64/calamity-admin-bot/workflows/Haskell%20CI/badge.svg)

This is a discord bot written in Haskell using the [calamity library](https://hackage.haskell.org/package/calamity). Its aim is to be a server administration bot with the following features:

- The following commands:
    - `!ping`: The command every bot needs - simply replies with "pong"
    - `!invite`: Returns an invite link to the server
    - `!kick :u :r`: Kicks the user `u`, optionally with the reason `r`
    - `!mute :u :r`: Mutes the user `u`, optionally with the reason `r` (by giving user a `Muted` role)
    - `!unmute :u :r`: Unmutes the user `u`, optionally with the reason `r`
    - `!tempmute :u :t :r`: Mutes the user `u` for `t` time optionally with reason `r`. The time is of the format `10m` or `7d`. Acceptable suffixes are `s`, `m`, `h`, and `d`.
    - `!ban :u :r`: Bans the user `u` optionally with reason `r`
    - `!unban :u :r`: Unbans the user `u`, optionally with reason `r`
    - `!bulkban :u1 :u2 ... :un :r`: Bans all the given users, optionally with reason `r`. Accepts any number of users
    - Note that all commands that take users accept either mentions or IDs. Banning will work even if the user is not in the server
    - Mute related commands require the user to have one of the listed roles. Kick/ban related commands require the user to have kick or ban permissions respectively
- Message edits and deletes are logged into a log channel
- Administrator actions (commands from `kick` onwards) are logged into the log channel, and a suitable reason is provided with the request for Discord's audit log
- Filtering based on message content
- Custom activity for the bot
- Reaction roles (NOT YET COMPLETE)

See [here](https://github.com/oscar-h64/calamity-admin-bot/issues?q=is%3Aissue+is%3Aopen+label%3Aenhancement) for a list of features planned. If there is a feature you would like feel free to open an issue (or a pull request!) with the label `enhancement` 

## Setup
1. Copy `config/settings.sample.yaml` to `config/settings.yaml` and enter the settings for your server (the file is commented to assist with this)
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
5. Run the executable to start the bot. Note the `settings.yaml` file must be in a folder called `config` in the folder you run the executable (so the `config` folder should be in the same folder as the executable if launching from a file manager, and in your current directory if launching from a terminal)

## Contributing
Issues and pull requests are always welcome - see [CONTRIBUTING.md](CONTRIBUTING.md) for more details
