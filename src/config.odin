package src

import "core:fmt"
import "core:os"
import "core:strings"

// Config holds user preferences loaded from ~/.config/odin-doctor/odin-doctor.conf
// Simple key=value format for now. The app seeds defaults on first run.
Config :: struct {
	default_command: string, // e.g. "check", "update", etc.
	// Add more fields here as the tool grows. Keep it simple.
}

// get_config_path returns the full path to the user's config file.
// It ensures the ~/.config/odin-doctor/ directory exists.
get_config_path :: proc() -> string {
	home := os.get_env_alloc("HOME", context.allocator)
	if home == "" {
		delete(home)
		home = os.get_env_alloc("USERPROFILE", context.allocator)
	}
	if home == "" {
		fmt.eprintln("Could not determine home directory")
		os.exit(1)
	}
	defer delete(home)

	config_dir := strings.concatenate([]string{home, "/.config/odin-doctor"})
	defer delete(config_dir)

	if !os.is_dir(config_dir) {
		err := os.make_directory(config_dir)
		if err != os.ERROR_NONE {
			fmt.eprintf("Failed to create config dir %s: %v\n", config_dir, err)
			os.exit(1)
		}
	}

	return strings.concatenate([]string{config_dir, "/odin-doctor.conf"})
}

// load_config reads a simple key=value config file.
// Returns a zero-value Config (and ok=false) if the file doesn't exist or can't be parsed.
// Callers should apply defaults in that case.
load_config :: proc(path: string) -> (config: Config, ok: bool) {
	data, err := os.read_entire_file(path, context.allocator)
	if err != nil {
		return {}, false
	}
	defer delete(data)

	it := string(data)
	for line in strings.split_lines_iterator(&it) {
		trimmed := strings.trim_space(line)
		if trimmed == "" || strings.has_prefix(trimmed, "#") {
			continue
		}
		if idx := strings.index(trimmed, "="); idx >= 0 {
			key := strings.trim_space(trimmed[:idx])
			value := strings.trim_space(trimmed[idx+1:])

			switch key {
			case "default_command":
				config.default_command = strings.clone(value)
			}
		}
	}

	return config, true
}

// save_config writes the config back in simple key=value format.
// Creates or overwrites the file.
save_config :: proc(path: string, config: Config) -> bool {
	builder := strings.builder_make()
	defer strings.builder_destroy(&builder)

	if config.default_command != "" {
		strings.write_string(&builder, "default_command=")
		strings.write_string(&builder, config.default_command)
		strings.write_string(&builder, "\n")
	}

	data := strings.to_string(builder)
	err := os.write_entire_file(path, transmute([]byte)data)
	return err == nil
}
