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
PRINT_DUPKEYBINDS = print-dupkeybinds
INSTALL_CRONTAB = install-crontab
INSTALL_GDM_CONFIGS = install-gdm-configs
INSTALL_VSCODE_WORKSPACES = install-vscode-workspaces
SET_NAUTILUS_ICONS = set-nautilus-icons

.PHONY: ${HELP}
${HELP}:
	# inspired by the makefiles of the Linux kernel and Mercurial
>	@printf '%s\n' 'Common make targets:'
>	@printf '%s\n' '  ${APPLY_GSETTINGS}               - apply the GNOME settings found in gsettings.txt'
>	@printf '%s\n' '  ${SYNC_GSETTINGS}                - sync the current desktop GNOME settings with what'\''s'
>	@printf '%s\n' '                                  in gsettings.txt'
>	@printf '%s\n' '  ${ADD_APT_SOURCES}               - add apt data sources formatted according to sources.list(5)'
>	@printf '%s\n' '  ${PRINT_DUPKEYBINDS}             - print GNOME keybinding settings that use the same value'
>	@printf '%s\n' '  ${INSTALL_CRONTAB}               - install the crontab(5) tables from crontab.txt'
>	@printf '%s\n' '  ${INSTALL_GDM_CONFIGS}           - install the GNOME Display Manager configurations'
>	@printf '%s\n' '  ${INSTALL_VSCODE_WORKSPACES}     - install the Visual Studio Code workspaces'
>	@printf '%s\n' '  ${SET_NAUTILUS_ICONS}            - set icons for files displayed by the Nautilus file manager'

.PHONY: ${APPLY_GSETTINGS}
${APPLY_GSETTINGS}:
>	./scripts/apply-gsettings

.PHONY: ${SYNC_GSETTINGS}
${SYNC_GSETTINGS}:
>	./scripts/sync-gsettings

.PHONY: ${ADD_APT_SOURCES}
${ADD_APT_SOURCES}:
>	./scripts/add-apt-sources

.PHONY: ${PRINT_DUPKEYBINDS}
${PRINT_DUPKEYBINDS}:
>	./scripts/print-dupkeybinds

.PHONY: ${INSTALL_CRONTAB}
${INSTALL_CRONTAB}:
>	crontab "./crontab.txt"

.PHONY: ${INSTALL_GDM_CONFIGS}
${INSTALL_GDM_CONFIGS}:
>	./scripts/install-gdm-configs

.PHONY: ${INSTALL_VSCODE_WORKSPACES}
${INSTALL_VSCODE_WORKSPACES}:
>	install --mode 644 "./vscode/personal.code-workspace" ".."

.PHONY: ${SET_NAUTILUS_ICONS}
${SET_NAUTILUS_ICONS}:
>	./scripts/set-nautilus-icons
