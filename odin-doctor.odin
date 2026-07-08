package main

import "src"

// Thin entry point so that `odin run .` (or `odin run . -file`) works naturally
// and we can keep all real code under src/ for modularity.
//
// This is a common best-practice pattern for Odin projects that want a clean
// src/ layout while still supporting convenient root-level invocation.

main :: proc() {
	src.Run()
}
