.PHONY: help clear-aot-cache analyze-example analyze-example-dcl analyze-example-all

PLUGIN_CACHE_DIR ?= $(HOME)/.dartServer/.plugin_manager
EXAMPLE_MAIN ?= example/lib/main.dart

help:
	@echo "Available targets:"
	@echo "  clear-aot-cache  	   Remove analyzer plugin AOT cache"
	@echo "  analyze-example       Run dart analyzer for $(EXAMPLE_MAIN)"
	@echo "  analyze-example-dcl   Run DCL analyzer for $(EXAMPLE_MAIN)"
	@echo "  analyze-example-all   Run both analyzer and DCL analyzer"

clear-aot-cache:
	@echo "Clearing analyzer plugin cache at $(PLUGIN_CACHE_DIR)"
	@rm -rf "$(PLUGIN_CACHE_DIR)"

analyze-example:
	dart analyze "$(EXAMPLE_MAIN)"

analyze-example-dcl:
	dart run dart_code_linter:metrics analyze "$(EXAMPLE_MAIN)"

analyze-example-all: analyze-example analyze-example-dcl
