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
INSTALL_NAUTILUS_BOOKMARKS = install-nautilus-bookmarks
INSTALL_FIREFOX_CONFIGS = install-firefox-configs
INSTALL_PAM_ENV_FILE = install-pam-env-file

# executables
ENVSUBST = envsubst

.PHONY: ${HELP}
${HELP}:
	# inspired by the makefiles of the Linux kernel and Mercurial
>	@printf '%s\n' 'Common make targets:'
>	@printf '%s\n' '  ${APPLY_GSETTINGS}                 - apply the GNOME settings found in gsettings.txt'
>	@printf '%s\n' '  ${SYNC_GSETTINGS}                  - sync the current desktop GNOME settings with what'\''s'
>	@printf '%s\n' '                                    in gsettings.txt'
>	@printf '%s\n' '  ${ADD_APT_SOURCES}                 - add apt data sources formatted according to sources.list(5)'
>	@printf '%s\n' '  ${PRINT_DUPKEYBINDS}               - print GNOME keybinding settings that use the same value'
>	@printf '%s\n' '  ${INSTALL_CRONTAB}                 - install the crontab(5) tables from crontab.txt'
>	@printf '%s\n' '  ${INSTALL_GDM_CONFIGS}             - install the GNOME Display Manager configurations'
>	@printf '%s\n' '  ${INSTALL_VSCODE_WORKSPACES}       - install the Visual Studio Code workspaces'
>	@printf '%s\n' '  ${SET_NAUTILUS_ICONS}              - set icons for files displayed by the Nautilus file manager'
>	@printf '%s\n' '  ${INSTALL_NAUTILUS_BOOKMARKS}      - install bookmarks for the Nautilus file manager'
>	@printf '%s\n' '  ${INSTALL_FIREFOX_CONFIGS}         - install the Firefox web browser configurations'
>	@printf '%s\n' '  ${INSTALL_PAM_ENV_FILE}            - install the pam_env.conf(5) environment variables file'

.PHONY: ${APPLY_GSETTINGS}
${APPLY_GSETTINGS}:
>	./scripts/apply-gsettings

.PHONY: ${SYNC_GSETTINGS}
${SYNC_GSETTINGS}:
>	./scripts/sync-gsettings

.PHONY: ${ADD_APT_SOURCES}
${ADD_APT_SOURCES}:
>	sudo ./scripts/add-apt-sources

.PHONY: ${PRINT_DUPKEYBINDS}
${PRINT_DUPKEYBINDS}:
>	./scripts/print-dupkeybinds

.PHONY: ${INSTALL_CRONTAB}
${INSTALL_CRONTAB}:
>	crontab "./crontab.txt"

.PHONY: ${INSTALL_GDM_CONFIGS}
${INSTALL_GDM_CONFIGS}:
>	sudo ./scripts/install-gdm-configs

.PHONY: ${INSTALL_VSCODE_WORKSPACES}
${INSTALL_VSCODE_WORKSPACES}:
>	install --mode 644 "./vscode/personal.code-workspace" ".."

.PHONY: ${SET_NAUTILUS_ICONS}
${SET_NAUTILUS_ICONS}:
>	./scripts/set-nautilus-icons

.PHONY: ${INSTALL_NAUTILUS_BOOKMARKS}
${INSTALL_NAUTILUS_BOOKMARKS}: local_config_files_vars = \
								$${HOME}
${INSTALL_NAUTILUS_BOOKMARKS}: ./nautilus/bookmarks
>	install --mode 664 "$^" "$${HOME}/.config/gtk-3.0/bookmarks"

.PHONY: ${INSTALL_FIREFOX_CONFIGS}
${INSTALL_FIREFOX_CONFIGS}:
>	install \
		-D \
		--mode 644 \
		"./firefox/1m544c8z.default-release/user.js" \
		"${HOME}/.mozilla/firefox/1m544c8z.default-release/user.js"

>	install \
		-D \
		--mode 644 \
		"./firefox/owjmdw8l.default/.gitignore" \
		"${HOME}/.mozilla/firefox/owjmdw8l.default/.gitignore"

>	install \
		-D \
		--mode 664 \
		"./firefox/installs.ini" \
		"${HOME}/.mozilla/firefox/installs.ini"

>	install \
		-D \
		--mode 664 \
		"./firefox/profiles.ini" \
		"${HOME}/.mozilla/firefox/profiles.ini"

.PHONY: ${INSTALL_PAM_ENV_FILE}
${INSTALL_PAM_ENV_FILE}:
>	sudo install --mode 644 "./environment" "/etc/environment"

%:: %.shtpl
>	${ENVSUBST} '${local_config_files_vars}' < "$<" > "$@"
