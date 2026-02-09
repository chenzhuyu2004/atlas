# ==============================================================================
# Atlas Monorepo Makefile
# Delegates to docker/atlas/Makefile
# ==============================================================================

.DEFAULT_GOAL := help

.PHONY: help
help:
	@$(MAKE) -C docker/atlas help

%:
	@$(MAKE) -C docker/atlas $@
