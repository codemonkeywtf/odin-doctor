# odin-update

A safe, standalone Bash script to **install or update** the Odin programming language compiler from official pre-built releases.

It supports both **stable** (GitHub tagged releases) and **nightly** (daily builds) channels, with strong emphasis on safety: staging, verification, SHA256 checks, backups, and rollback.

`odin-update` is currently maintained as a standalone tool (even though it lives in the `tools/` directory of the larger `odin-doctor` project).

## Current Features

- Install or update Odin (stable or nightly)
- `--channel=stable|nightly` flag (default: stable)
- `--keep=N` flag to control how many previous backups to retain (default: 1)
- First-time installation with interactive prompt (defaults to `~/.local/Odin`)
- Downloads to a temporary staging directory
- Validates the archive and verifies SHA256 of the downloaded file
- Verifies the new binary actually runs and reports a version
- Automatic backup of the previous installation (timestamped `.bak.YYYYMMDD-HHMMSS`)
- Graceful rollback on failure (restores backup or cleans partial install)
- Smart sudo handling:
  - Detects if already running as root (no prompt)
  - Prompts for sudo only when needed for system locations
  - Returns ownership to the user after install
- Creates symlink `~/.local/bin/odin` if `~/.local/bin/` already exists
- Generates a config skeleton on first successful run
- Clear post-install instructions for setting `ODIN_ROOT` and `PATH`
- Reliable "Already up to date!" detection based on the actual binary version string (handles Odin's tag-vs-reported-version quirk)

## Usage

```bash
# Basic usage (stable channel)
./odin-update

# Nightly channel
./odin-update --channel=nightly

# Keep more backups
./odin-update --keep=3

# Combine flags
./odin-update --channel=nightly --keep=2
```

Run with `--help` for the current option summary.

## Requirements

- Bash
- `curl`, `tar`, `jq` (for stable channel), `sha256sum` or `shasum`
- Internet access (to fetch releases)

Tested on Linux and macOS.

## Installation

1. Download the `odin-update` script.
2. Make it executable:
   ```bash
   chmod +x odin-update
   ```
3. Optionally move it to a directory in your `$PATH` (e.g. `~/bin/` or `~/.local/bin/`).

You can also run it directly from its location.

## Next Steps / Near-term Improvements

These are the immediate planned enhancements discussed for the current standalone script (no far-future features):

- Switch to a proper JSON config file at `~/.config/odin/update.json`
- Create the config file with sensible defaults + comments on first successful run (if it doesn't exist)
- Read settings from the config file (channel, keep, install_dir, etc.)
- CLI flags will continue to override config values
- Use the config to provide non-interactive defaults when possible

These changes will make repeated runs more convenient while keeping the script self-contained and simple.

## Philosophy

- **Safety first**: Never leave your system in a broken state.
- **Predictable & transparent**: Clear output, explicit steps, easy rollback.
- **Minimal dependencies**: Works with tools most developers already have.
- **Standalone for now**: Focused on doing one thing well.

---

*Part of the broader odin-doctor effort, but currently developed and distributed as an independent tool.*