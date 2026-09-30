# Dotfiles

Personal configuration files managed with [GNU Stow](https://www.gnu.org/software/stow/).

The repository contains one Stow package named `home`. Everything below
`home/` is laid out as it should appear below `$HOME`:

```text
~/.dotfiles/home/.config/fish/config.fish
                         │
                         └──> ~/.config/fish/config.fish
```

Stow creates symbolic links; it does not copy the files. Editing either the
file in `~/.dotfiles` or its linked path in `~/.config` edits the same file.

## Quick start on Ubuntu or WSL

Install the prerequisites:

```bash
sudo apt update
sudo apt install git stow
```

Clone the repository if it is not already present:

```bash
git clone <repository-url> ~/.dotfiles
cd ~/.dotfiles
```

Preview what Stow will do:

```bash
stow --no-folding --simulate --verbose --target="$HOME" home
```

If the preview reports no conflicts, create the links:

```bash
stow --no-folding --verbose --target="$HOME" home
```

Verify a link if needed:

```bash
readlink ~/.config/fish/config.fish
```

`--no-folding` links individual files instead of replacing an entire config
directory with one directory symlink. This allows untracked, machine-local
files to live beside the managed files without placing them inside the Git
working tree.

## Existing-file conflicts

Stow will stop instead of overwriting a real file. Compare and back up a
conflicting file before running Stow again:

```bash
diff -u ~/.config/fish/config.fish \
  ~/.dotfiles/home/.config/fish/config.fish
mv ~/.config/fish/config.fish ~/.config/fish/config.fish.pre-stow
stow --no-folding --target="$HOME" home
```

Merge anything worth keeping into the version in the repository, then remove
the backup only after confirming the linked config works. Avoid `stow
--adopt` unless you understand it: that option moves the destination files
into the repository and can overwrite the repository's versions.

## Machine-local configuration

Files that contain secrets or settings specific to one computer should not be
committed. Create missing local files from the examples and edit the copies
(`cp -n` preserves existing files):

```bash
cp -n ~/.config/fish/local.fish.example ~/.config/fish/local.fish
cp -n ~/.config/hypr/local.lua.example ~/.config/hypr/local.lua
cp -n ~/.config/niri/local.kdl.example ~/.config/niri/local.kdl
cp -n ~/.config/noctalia/local.toml.example ~/.config/noctalia/local.toml
```

The main Fish and Hyprland configs load these files only when they exist.
Niri (26.04 or newer) includes `local.kdl` optionally at the end of
`config.kdl`, so local settings override shared settings. Put monitor layout,
input-device tuning, hardware-specific keybindings, private environment values,
and distribution-specific startup commands there. See the
[niri include documentation](https://niri-wm.github.io/niri/Configuration:-Include.html).

Noctalia v5 automatically loads root `*.toml` files alphabetically.
`config.toml` contains shared settings; optional `local.toml` loads afterwards
and overrides them. This uses Noctalia's native config loader; no startup
wrapper is needed. Keep this naming order and automatic loading enabled.
Put local icon paths, wallpaper paths, output-specific settings, location,
account details, and private commands in `local.toml`.

Noctalia's GUI overrides in `~/.local/state/noctalia/settings.toml` load last
and can override both files. That file and the rest of Noctalia's runtime
state (including clipboard and notification history) stay local. To share a
future GUI change, review it and copy only the portable settings into
`config.toml`; do not blindly commit a full export. Custom color palettes
under `home/.config/noctalia/palettes/` are shared. See the
[Noctalia configuration documentation](https://docs.noctalia.dev/noctalia/configuration/).

Local overrides and config backups are also excluded by `.gitignore` as a
precaution. Keep using `--no-folding` so real local files stay outside the
repository. Back up local files separately if you need to restore them later.

Validate changes before committing:

```bash
niri validate
noctalia config validate
```

## Editing and saving changes

Because the installed files are symlinks, edit them in the usual location:

```bash
$EDITOR ~/.config/fish/config.fish
cd ~/.dotfiles
git diff
git add home/.config/fish/config.fish
git commit -m "Update Fish config"
git push
```

New config files must be created below `~/.dotfiles/home/` so Git can track
them. After adding, removing, or renaming files, restow the package:

```bash
cd ~/.dotfiles
stow --no-folding --restow --verbose --target="$HOME" home
```

`--restow` removes stale links and creates the links currently described by
the package.

## Updating another machine

```bash
cd ~/.dotfiles
git pull --ff-only
stow --no-folding --restow --verbose --target="$HOME" home
```

Review `git status` before pulling if the machine has uncommitted dotfile
changes.

## Removing the links

To remove only the symlinks managed by this package while keeping the files in
the repository:

```bash
cd ~/.dotfiles
stow --no-folding --delete --verbose --target="$HOME" home
```

This does not delete the tracked files in `~/.dotfiles` or unrelated files in
`~/.config`.

## Command cheat sheet

| Task | Command |
| --- | --- |
| Preview | `stow --no-folding -n -v -t "$HOME" home` |
| Install links | `stow --no-folding -v -t "$HOME" home` |
| Refresh links | `stow --no-folding -R -v -t "$HOME" home` |
| Remove links | `stow --no-folding -D -v -t "$HOME" home` |
