package src

import "core:fmt"
import "core:os"

// VERSION follows the simple scheme: 0.1 to 0.9, then 0.10, 0.11...
// Perpetual beta until all issues cleared and have stayed clear for a while.
VERSION :: "0.1"

// Crash course notes (Odin best practices):
// - All .odin files in this directory that declare `package src` are part of the
//   same package. They can see each other's unexported (lowercase) identifiers
//   directly — no import needed inside the package.
// - This is how we get modularity without a giant single file.
// - The root `odin-doctor.odin` (package main) imports "src" as a separate package
//   and calls the exported Run() entry point.
// - `core:os` for files/env, `core:strings` for text, `core:fmt` for output.
// - defer for cleanup, context.allocator for explicit memory.
// - See https://odin-lang.org/docs/ and the code comments for more.

Run :: proc() {
	fmt.println("odin-doctor", VERSION)
	fmt.println("A safe tool for Odin. (Perpetual beta for now)")

	// Demo using the config functions now living in src/config.odin (same package)
	config_path := get_config_path()
	defer delete(config_path)

	config, _ := load_config(config_path)
	if config.default_command == "" {
		config.default_command = "check"
		save_config(config_path, config)
		fmt.println("Created default config at", config_path)
	}

	fmt.printf("Default command: %s\n", config.default_command)

	// TODO: real "check current local version vs online version"
	fmt.println("\n[stub] Would check local 'odin version' vs latest GitHub release")

	// TODO: real subcommands, --help, etc.
	fmt.println("\nRun with subcommand ideas: check, update, install, status, etc.")
}

// TODO (next modularity steps):
// - Move version checking logic to src/version/version.odin
// - Move command dispatching to src/cmd/
// - Keep this file as the high-level coordinator for the Run() entry point.

// Crash course reminders:
// - Build / run: odin run . -file   (or odin run odin-doctor.odin -file)
// - Test the src package: odin test src
// - Release binary: odin build odin-doctor.odin -o:build/odin-doctor
