# special makefile variables
.DEFAULT_GOAL := help
.RECIPEPREFIX := >

# recursively expanded variables
SHELL = /usr/bin/sh

# targets
HELP = help
APPLY_GSETTINGS = apply-gsettings
SYNC_GSETTINGS = sync-gsettings
ADD_APT_SOURCES = add-apt-sources

.PHONY: ${HELP}
${HELP}:
	# inspired by the makefiles of the Linux kernel and Mercurial
>	@printf '%s\n' 'Common make targets:'
>	@printf '%s\n' '  ${APPLY_GSETTINGS}     - apply the GNOME settings found in gsettings.txt'
>	@printf '%s\n' '  ${SYNC_GSETTINGS}      - sync the current desktop GNOME settings with what'\''s'
>	@printf '%s\n' '                        in gsettings.txt'
>	@printf '%s\n' '  ${ADD_APT_SOURCES}     - add apt data sources formatted according to sources.list(5)'

.PHONY: ${APPLY_GSETTINGS}
${APPLY_GSETTINGS}:
>	./scripts/apply-gsettings

.PHONY: ${SYNC_GSETTINGS}
${SYNC_GSETTINGS}:
>	./scripts/sync-gsettings

.PHONY: ${ADD_APT_SOURCES}
${ADD_APT_SOURCES}:
>	./scripts/add-apt-sources
