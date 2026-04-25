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
INSTALL_PAM_ENV_CONF = install-pam-env-conf
INSTALL_SSHD_PUBKEY_AUTH_CONF = install-sshd-pubkey-auth-conf
INSTALL_SYSCTL_CONF = install-sysctl-conf
INSTALL_NSSWITCH_CONF = install-nsswitch-conf
INSTALL_RESOLVED_CONF = install-resolved-conf
INSTALL_SYSTEMD_UNIT_FILES = install-systemd-unit-files
INSTALL_USER_ICON = install-user-icon
SYNC_FIREFOX_PREFS = sync-firefox-prefs
INSTALL_APPARMOR_MSMTP_RULES = install-apparmor-msmtp-rules
INSTALL_WALLPAPERS = install-wallpapers
INSTALL_FONTS = install-fonts
INSTALL_PLYMOUTH = install-plymouth
INSTALL_PLYMOUTH_THEMES = install-plymouth-themes
LOAD_GNOME_TERMINAL_PROFILES = load-gnome-terminal-profiles
INSTALL_NICE_TO_HAVES = install-nice-to-haves
SERVE_PRESEED_CONFIG = serve-preseed-config
CLEAN = clean

# executables
ENVSUBST = envsubst
PYTHON = python
PIP = pip
PRE_COMMIT = pre-commit
NPM = npm
APPARMOR_PARSER = apparmor_parser
executables = \
	${PYTHON}\
	${NPM}\
	${APPARMOR_PARSER}

_check_executables := $(foreach exec,${executables},$(if $(shell command -v ${exec}),pass,$(error "No ${exec} in PATH")))

.PHONY: ${HELP}
${HELP}:
	# inspired by the makefiles of the Linux kernel and Mercurial
>	@printf '%s\n' 'Common make targets:'
>	@printf '%s\n' '  ${SETUP}                              - install the distro-independent dependencies for this'
>	@printf '%s\n' '                                       repository'
>	@printf '%s\n' '  ${APPLY_GSETTINGS}                    - apply the GNOME settings found in gsettings.txt'
>	@printf '%s\n' '  ${SYNC_GSETTINGS}                     - sync the current desktop GNOME settings with what'\''s'
>	@printf '%s\n' '                                       in gsettings.txt'
>	@printf '%s\n' '  ${ADD_APT_SOURCES}                    - add APT data sources formatted according to sources.list(5)'
>	@printf '%s\n' '  ${PRINT_DUPKEYBINDS}                  - print GNOME keybinding settings that use the same value'
>	@printf '%s\n' '  ${INSTALL_GDM_CONFIGS}                - install the GNOME Display Manager configurations'
>	@printf '%s\n' '  ${INSTALL_VSCODE_WORKSPACES}          - install the Visual Studio Code workspaces'
>	@printf '%s\n' '  ${SET_NAUTILUS_ICONS}                 - set icons for files displayed by the Nautilus file manager'
>	@printf '%s\n' '  ${INSTALL_NAUTILUS_BOOKMARKS}         - install bookmarks for the Nautilus file manager'
>	@printf '%s\n' '  ${INSTALL_FIREFOX_CONFIGS}            - install the Firefox web browser configurations'
>	@printf '%s\n' '  ${INSTALL_PAM_ENV_CONF}               - install the pam_env.conf(5) environment variables file'
>	@printf '%s\n' '  ${INSTALL_SSHD_PUBKEY_AUTH_CONF}      - install the sshd_config(5) sshd_pubkey_auth.conf file'
>	@printf '%s\n' '  ${INSTALL_SYSCTL_CONF}                - install the sysctl.conf(5) kernel parameters file'
>	@printf '%s\n' '  ${INSTALL_NSSWITCH_CONF}              - install the nsswitch.conf(5) sources file'
>	@printf '%s\n' '  ${INSTALL_RESOLVED_CONF}              - install the resolved.conf(5) sources file'
>	@printf '%s\n' '  ${INSTALL_SYSTEMD_UNIT_FILES}         - install the systemd.unit(5) files'
>	@printf '%s\n' '  ${INSTALL_USER_ICON}                  - install my operating system user'\''s icon'
>	@printf '%s\n' '  ${SYNC_FIREFOX_PREFS}                 - sync the Firefox preferences from the prefs.js file with'
>	@printf '%s\n' '                                       what'\''s in the user.js file'
>	@printf '%s\n' '  ${INSTALL_APPARMOR_MSMTP_RULES}       - install additional apparmor.d(5) rules for usr.bin.msmtp'
>	@printf '%s\n' '  ${INSTALL_WALLPAPERS}                 - install my selection of desktop wallpapers'
>	@printf '%s\n' '  ${INSTALL_FONTS}                      - install the system text fonts'
>	@printf '%s\n' '  ${INSTALL_PLYMOUTH}                   - install packages built from my maintained copy of Plymouth'
>	@printf '%s\n' '  ${INSTALL_PLYMOUTH_THEMES}            - install my Plymouth themes'
>	@printf '%s\n' '  ${LOAD_GNOME_TERMINAL_PROFILES}       - load the GNOME Terminal profiles'
>	@printf '%s\n' '  ${INSTALL_NICE_TO_HAVES}              - install nice-to-have, small quality of life packages'
>	@printf '%s\n' '  ${SERVE_PRESEED_CONFIG}               - serve the Debian preseed configuration file over HTTP'
>	@printf '%s\n' '  ${CLEAN}                              - remove files generated from targets'

.PHONY: ${SETUP}
${SETUP}:
>	${PYTHON} -m ${PIP} install --upgrade "${PIP}"
>	${PYTHON} -m ${PIP} install --requirement "./requirements-dev.txt"
>	${NPM} install
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

.PHONY: ${INSTALL_GDM_CONFIGS}
${INSTALL_GDM_CONFIGS}:
>	./scripts/install-gdm-configs

.PHONY: ${INSTALL_VSCODE_WORKSPACES}
${INSTALL_VSCODE_WORKSPACES}:
>	install --mode 644 "./src/vscode/personal.code-workspace" ".."

.PHONY: ${SET_NAUTILUS_ICONS}
${SET_NAUTILUS_ICONS}:
>	./scripts/set-nautilus-icons

.PHONY: ${INSTALL_NAUTILUS_BOOKMARKS}
${INSTALL_NAUTILUS_BOOKMARKS}: local_config_files_vars = \
								$${HOME}
${INSTALL_NAUTILUS_BOOKMARKS}: ./src/bookmarks
>	install --mode 664 "$^" "$${HOME}/.config/gtk-3.0/bookmarks"

.PHONY: ${INSTALL_FIREFOX_CONFIGS}
${INSTALL_FIREFOX_CONFIGS}: local_config_files_vars = \
								$${HTTP_PROXY_HOST}\
								$${HTTP_PROXY_PORT}
${INSTALL_FIREFOX_CONFIGS}: export HTTP_PROXY_HOST = proxy.homelab.cavcrosby.net
${INSTALL_FIREFOX_CONFIGS}: export HTTP_PROXY_PORT = 39600
${INSTALL_FIREFOX_CONFIGS}: ./src/firefox/1m544c8z.default-release/user.js
>	./scripts/install-firefox-configs

.PHONY: ${INSTALL_PAM_ENV_CONF}
${INSTALL_PAM_ENV_CONF}:
>	sudo install --mode 644 "./src/pam_env.conf" "/etc/security/pam_env.conf"
>	sudo truncate --size 0 "/etc/environment"

.PHONY: ${INSTALL_SSHD_PUBKEY_AUTH_CONF}
${INSTALL_SSHD_PUBKEY_AUTH_CONF}:
>	sudo install --mode 644 "./src/sshd_pubkey_auth.conf" "/etc/ssh/sshd_config.d"
>	sudo systemctl restart "sshd.service"

.PHONY: ${INSTALL_SYSCTL_CONF}
${INSTALL_SYSCTL_CONF}:
>	sudo install --mode 644 "./src/sysctl.conf" "/etc/sysctl.d/99-desktop-configs.conf"

.PHONY: ${INSTALL_NSSWITCH_CONF}
${INSTALL_NSSWITCH_CONF}:
>	sudo install --mode 644 "./src/nsswitch.conf" "/etc/nsswitch.conf"

.PHONY: ${INSTALL_RESOLVED_CONF}
${INSTALL_RESOLVED_CONF}:
>	sudo install \
		-D \
		--mode 644 \
		"./src/resolved.conf" \
		"/etc/systemd/resolved.conf.d/00-desktop-configs.conf"

.PHONY: ${INSTALL_SYSTEMD_UNIT_FILES}
${INSTALL_SYSTEMD_UNIT_FILES}: local_config_files_vars = \
								$${SYSTEMD_SENDMAIL_SCRIPT_PATH}
${INSTALL_SYSTEMD_UNIT_FILES}: export SYSTEMD_SENDMAIL_SCRIPT_PATH = ${HOME}/.local/libexec/systemd/sendmail
${INSTALL_SYSTEMD_UNIT_FILES}: ./src/systemd/sendmail@.service
${INSTALL_SYSTEMD_UNIT_FILES}:
>	./scripts/install-systemd-unit-files

.PHONY: ${INSTALL_USER_ICON}
${INSTALL_USER_ICON}:
>	sudo install \
		--mode 644 \
		"./src/user-accountsservice" \
		"/var/lib/AccountsService/users/$${LOGNAME}"

>	sudo install \
		--mode 644 \
		"./src/user-icon" \
		"/var/lib/AccountsService/icons/$${LOGNAME}"

.PHONY: ${SYNC_FIREFOX_PREFS}
${SYNC_FIREFOX_PREFS}:
>	./scripts/sync-firefox-prefs.js

.PHONY: ${INSTALL_APPARMOR_MSMTP_RULES}
${INSTALL_APPARMOR_MSMTP_RULES}:
> 	sudo install \
		--mode 644 \
		"./src/usr.bin.msmtp" \
		"/etc/apparmor.d/local/usr.bin.msmtp"

>	sudo ${APPARMOR_PARSER} --replace "/etc/apparmor.d/usr.bin.msmtp"

.PHONY: ${INSTALL_WALLPAPERS}
${INSTALL_WALLPAPERS}: local_config_files_vars = \
						$${HOME}
${INSTALL_WALLPAPERS}: ./src/wallpapers.xml
>	./scripts/install-wallpapers

.PHONY: ${INSTALL_FONTS}
${INSTALL_FONTS}:
>	sudo ./scripts/install-fonts

.PHONY: ${INSTALL_PLYMOUTH}
${INSTALL_PLYMOUTH}:
>	./scripts/install-plymouth

.PHONY: ${INSTALL_PLYMOUTH_THEMES}
${INSTALL_PLYMOUTH_THEMES}:
>	sudo cp \
		--recursive \
		"./src/pop-basic" \
		"/usr/share/plymouth/themes/pop-basic"

>	sudo install \
		--mode 755 \
		"./src/plymouth-desktop-configs" \
		"/usr/share/initramfs-tools/hooks"

.PHONY: ${LOAD_GNOME_TERMINAL_PROFILES}
${LOAD_GNOME_TERMINAL_PROFILES}:
>	dconf load \
		"/org/gnome/terminal/legacy/profiles:/" \
		< "./src/gnome-terminal-profiles.txt"

.PHONY: ${INSTALL_NICE_TO_HAVES}
${INSTALL_NICE_TO_HAVES}:
>	sudo apt-get install \
		--assume-yes \
		"colortest" \
		"command-not-found" \
		"dconf-editor" \
		"fastfetch"

# - ENCRYPTED_PASSWORD = Passw0rd!
# - d-i partman/early_command string debconf-set partman-auto/disk $$(readlink -f /dev/disk/by-id/${DISK_ID})
#   - replace ${DISK_ID} with something like nvme-WD_BLACK_SN850X_HS_2000GB_25244C800799
.PHONY: ${SERVE_PRESEED_CONFIG}
${SERVE_PRESEED_CONFIG}: local_config_files_vars = \
							$${HOSTNAME_}\
							$${ENCRYPTED_PASSWORD}\
							$${PARTMAN_AUTO_DISK_PARAM_LINE}\
							$${ENCRYPTION_PASSPHRASE}
${SERVE_PRESEED_CONFIG}: export HOSTNAME_ = debian
${SERVE_PRESEED_CONFIG}: export ENCRYPTED_PASSWORD = $$6$$496388125$$lkA4dPUIN/ueRva.PE3bfRTsq6DRKUw7Ir02VygOih9ufg2.SI.4c9L2xOEh4qgGojD3x1NttO8Fu6WygqxII/
${SERVE_PRESEED_CONFIG}: export PARTMAN_AUTO_DISK_PARAM_LINE = d-i partman-auto/disk string /dev/vda
${SERVE_PRESEED_CONFIG}: export ENCRYPTION_PASSPHRASE = Passw0rd!
${SERVE_PRESEED_CONFIG}: ./src/preseed.cfg
${SERVE_PRESEED_CONFIG}:
>	${PYTHON} -m "http.server" --directory "./src"

.PHONY: ${CLEAN}
${CLEAN}:
>	rm \
		--force \
		"./src/bookmarks" \
		"./src/firefox/1m544c8z.default-release/user.js" \
		"./src/systemd/sendmail@.service" \
		"./src/wallpapers.xml" \
		"./src/preseed.cfg"

%:: %.shtpl
>	${ENVSUBST} '${local_config_files_vars}' < "$<" > "$@"
