# dotfiles

My Linux desktop and CLI configuration.

This repository intentionally uses a flat layout instead of mirroring `$HOME`:

```text
gitconfig  -> ~/.gitconfig
zshrc      -> ~/.zshrc
zshenv     -> ~/.zshenv
hypr/      -> ~/.config/hypr/
waybar/    -> ~/.config/waybar/
kitty/     -> ~/.config/kitty/
opencode/  -> ~/.config/opencode/
opendeck/  -> ~/.config/opendeck/
bin/*      -> ~/.local/bin/*
```

## Install

```sh
./install.sh
```

The installer backs up existing files before creating symlinks.

## Security

This is a public repository. Local state, generated dependencies, plugins, logs,
tokens, credentials, and private Slack/status automation scripts are excluded.
