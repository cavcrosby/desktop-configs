# special makefile variables
.DEFAULT_GOAL := help
.RECIPEPREFIX := >

# recursively expanded variables
SHELL = /usr/bin/sh

# targets
HELP = help
SETUP = setup
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
INSTALL_SSHD_PUBKEY_AUTH_CONF = install-sshd-pubkey-auth-conf
INSTALL_SYSCTL_CONF = install-sysctl-conf

# executables
ENVSUBST = envsubst
PYTHON = python
PIP = pip
PRE_COMMIT = pre-commit
executables = \
	${PYTHON}

_check_executables := $(foreach exec,${executables},$(if $(shell command -v ${exec}),pass,$(error "No ${exec} in PATH")))

.PHONY: ${HELP}
${HELP}:
	# inspired by the makefiles of the Linux kernel and Mercurial
>	@printf '%s\n' 'Common make targets:'
>	@printf '%s\n' '  ${SETUP}                              - installs the distro-independent dependencies for this'
>	@printf '%s\n' '                                       repository'
>	@printf '%s\n' '  ${APPLY_GSETTINGS}                    - apply the GNOME settings found in gsettings.txt'
>	@printf '%s\n' '  ${SYNC_GSETTINGS}                     - sync the current desktop GNOME settings with what'\''s'
>	@printf '%s\n' '                                       in gsettings.txt'
>	@printf '%s\n' '  ${ADD_APT_SOURCES}                    - add apt data sources formatted according to sources.list(5)'
>	@printf '%s\n' '  ${PRINT_DUPKEYBINDS}                  - print GNOME keybinding settings that use the same value'
>	@printf '%s\n' '  ${INSTALL_CRONTAB}                    - install the crontab(5) tables from crontab.txt'
>	@printf '%s\n' '  ${INSTALL_GDM_CONFIGS}                - install the GNOME Display Manager configurations'
>	@printf '%s\n' '  ${INSTALL_VSCODE_WORKSPACES}          - install the Visual Studio Code workspaces'
>	@printf '%s\n' '  ${SET_NAUTILUS_ICONS}                 - set icons for files displayed by the Nautilus file manager'
>	@printf '%s\n' '  ${INSTALL_NAUTILUS_BOOKMARKS}         - install bookmarks for the Nautilus file manager'
>	@printf '%s\n' '  ${INSTALL_FIREFOX_CONFIGS}            - install the Firefox web browser configurations'
>	@printf '%s\n' '  ${INSTALL_PAM_ENV_FILE}               - install the pam_env.conf(5) environment variables file'
>	@printf '%s\n' '  ${INSTALL_SSHD_PUBKEY_AUTH_CONF}      - install the sshd_config(5) sshd_pubkey_auth.conf file'
>	@printf '%s\n' '  ${INSTALL_SYSCTL_CONF}                - install the sysctl.conf(5) kernel parameters file'

.PHONY: ${SETUP}
${SETUP}:
>	${PYTHON} -m ${PIP} install --upgrade "${PIP}"
>	${PYTHON} -m ${PIP} install --requirement "./requirements-dev.txt"
>	${PRE_COMMIT} install

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
${INSTALL_FIREFOX_CONFIGS}: local_config_files_vars = \
								$${HTTP_PROXY_HOSTNAME}\
								$${HTTP_PROXY_PORT}
${INSTALL_FIREFOX_CONFIGS}: export HTTP_PROXY_HOSTNAME = proxy.homelab.cavcrosby.net
${INSTALL_FIREFOX_CONFIGS}: export HTTP_PROXY_PORT = 39600
${INSTALL_FIREFOX_CONFIGS}: ./firefox/1m544c8z.default-release/user.js
>	./scripts/install-firefox-configs

.PHONY: ${INSTALL_PAM_ENV_FILE}
${INSTALL_PAM_ENV_FILE}:
>	sudo install --mode 644 "./pam_env.conf" "/etc/security/pam_env.conf"
>	sudo truncate --size 0 "/etc/environment"

.PHONY: ${INSTALL_SSHD_PUBKEY_AUTH_CONF}
${INSTALL_SSHD_PUBKEY_AUTH_CONF}:
>	sudo install --mode 644 "./sshd_pubkey_auth.conf" "/etc/ssh/sshd_config.d"
>	sudo systemctl restart "sshd.service"

.PHONY: ${INSTALL_SYSCTL_CONF}
${INSTALL_SYSCTL_CONF}:
>	sudo install --mode 644 "./sysctl.conf" "/etc/sysctl.d/99-desktop-configs.conf"

%:: %.shtpl
>	${ENVSUBST} '${local_config_files_vars}' < "$<" > "$@"
