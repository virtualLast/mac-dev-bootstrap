.DEFAULT_GOAL := help

# -----------------------------
# Paths / config
# -----------------------------

BREWFILE := Brewfile

NVM_DIR := $(HOME)/.nvm
NVM := . /opt/homebrew/opt/nvm/nvm.sh

PHP_VERSIONS := 8.2 8.3 8.4 8.5
COMPOSER_PACKAGES := phpunit/phpunit symfony/phpunit-bridge friendsofphp/php-cs-fixer phpstan/phpstan symfony/maker-bundle symfony/console symfony/var-dumper psy/psysh
NODE_PACKAGES := typescript eslint prettier expo-cli react-native-cli yarn

# -----------------------------
# Help
# -----------------------------

.PHONY: help
help:
	@echo ""
	@echo "Bootstrap:"
	@echo "  make bootstrap       Full setup: brew, node, PHP extensions, Composer global"
	@echo "  make brew            Install Homebrew packages from Brewfile"
	@echo ""
	@echo "Node:"
	@echo "  make node            Install all required Node versions"
	@echo "  make node-16         Install Node 16"
	@echo "  make node-22         Install Node 22"
	@echo "  make node-latest     Install latest Node"
	@echo "  make node-default    Set default Node version"
	@echo "  make node-list       List installed Node versions"
	@echo "  make node-global     Install global Node packages"
	@echo ""
	@echo "PHP:"
	@echo "  make php-check       Show active PHP vs Symfony PHP"
	@echo "  make php-ext         Install all PHP extensions"
	@echo "  make php-ext-redis   Install redis extension"
	@echo "  make php-ext-xdebug  Install xdebug extension"
	@echo "  make composer-global Install global Composer packages"
	@echo ""

# -----------------------------
# Checks
# -----------------------------

.PHONY: brew-check

brew-check:
	@command -v brew >/dev/null 2>&1 || \
		(echo "" && \
		 echo "❌ Homebrew is not installed." && \
		 echo "" && \
		 echo "Install Homebrew by running:" && \
		 echo "" && \
		 echo "    /bin/bash -c \"\$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"" && \
		 echo "" && \
		 echo "Then add Homebrew to your shell environment and re-run make." && \
		 echo "" && \
		 exit 1)

.PHONY: xcode-check

xcode-check:
	@xcode-select -p >/dev/null 2>&1 || \
		(echo "" && \
		 echo "❌ Xcode Command Line Tools are not installed." && \
		 echo "" && \
		 echo "Run the following command, complete the installer," && \
		 echo "then re-run make:" && \
		 echo "" && \
		 echo "    xcode-select --install" && \
		 echo "" && \
		 exit 1)

# -----------------------------
# Homebrew
# -----------------------------

.PHONY: brew
brew: brew-check xcode-check
	@echo "Installing Homebrew packages from $(BREWFILE)..."
	@brew bundle --file=$(BREWFILE)

# -----------------------------
# Node / NVM
# -----------------------------

.PHONY: node node-16 node-22 node-latest node-default node-list node-global

node: brew node-16 node-22 node-latest node-default

node-16:
	@echo "Installing Node 16..."
	@bash -c '$(NVM) && nvm install 16'

node-22:
	@echo "Installing Node 22..."
	@bash -c '$(NVM) && nvm install 22'

node-latest:
	@echo "Installing latest Node..."
	@bash -c '$(NVM) && nvm install node'

node-default:
	@echo "Setting default Node version to 22..."
	@bash -c '$(NVM) && nvm alias default 22'

node-list:
	@bash -c '$(NVM) && nvm ls'

node-global:
	@echo "Installing global Node packages..."
	@bash -c '$(NVM) && npm install -g $(NODE_PACKAGES)'

# -----------------------------
# PHP sanity & extensions
# -----------------------------

.PHONY: php-check sphp php-ext php-ext-redis php-ext-xdebug

php-check:
	@echo ""
	@echo "System PHP:"
	@which php
	@php -v
	@echo ""
	@echo "Symfony PHP:"
	@symfony php -v

sphp:
	@echo "Installing sphp..."
	@curl -L https://raw.githubusercontent.com/rhukster/sphp.sh/main/sphp.sh > /opt/homebrew/bin/sphp
	@chmod +x /opt/homebrew/bin/sphp

php-ext: brew-check xcode-check sphp php-ext-redis php-ext-xdebug

php-ext-redis:
	@echo "Installing redis extension for PHP versions: $(PHP_VERSIONS)"
	@for v in $(PHP_VERSIONS); do \
		echo "→ PHP $$v"; \
		sphp $$v; \
		pecl install -f redis || true; \
	done

php-ext-xdebug:
	@echo "Installing xdebug extension for PHP versions: $(PHP_VERSIONS)"
	@for v in $(PHP_VERSIONS); do \
		echo "→ PHP $$v"; \
		sphp $$v; \
		pecl install -f xdebug || true; \
		echo "→ Configuring xdebug for PHP $$v"; \
		INI_DIR="/opt/homebrew/etc/php/$$v/conf.d"; \
		INI_FILE="$$INI_DIR/ext-xdebug.ini"; \
		mkdir -p "$$INI_DIR"; \
		echo "[xdebug]" > "$$INI_FILE"; \
		echo "zend_extension=\"xdebug.so\"" >> "$$INI_FILE"; \
		echo "xdebug.mode=debug" >> "$$INI_FILE"; \
		echo "xdebug.start_with_request=yes" >> "$$INI_FILE"; \
		echo "xdebug.client_host=localhost" >> "$$INI_FILE"; \
		echo "xdebug.client_port=9003" >> "$$INI_FILE"; \
		echo "xdebug.idekey=PHPSTORM" >> "$$INI_FILE"; \
		echo "✓ xdebug configured at $$INI_FILE"; \
	done
	@echo ""
	@echo "✅ xdebug installed and configured for all PHP versions"
	@echo "   - Mode: debug (always active)"
	@echo "   - Port: 9003 (default for Xdebug 3+)"
	@echo "   - IDE Key: PHPSTORM"
	@echo ""
	@echo "Ready to debug: Just start/stop listening in PhpStorm (port 9003)"
	@echo ""

# -----------------------------
# PHP packages
# -----------------------------

.PHONY: composer-global

composer-global:
	@echo "Installing global Composer packages..."
	@composer global require $(COMPOSER_PACKAGES)

# -----------------------------
# Bootstrap target
# -----------------------------

.PHONY: bootstrap

bootstrap: brew-check xcode-check brew node sphp php-ext composer-global node-global
	@echo ""
	@echo "✅ Bootstrap complete! Your Mac should now have:"
	@echo "   - Homebrew packages installed"
	@echo "   - Node runtimes installed (16, 22, latest)"
	@echo "   - Global Node packages installed"
	@echo "   - PHP extensions (redis + xdebug) installed for $(PHP_VERSIONS)"
	@echo "   - Global Composer packages installed"
	@echo ""
	@echo "Next steps:"
	@echo "  - Configure your shell profile for NVM & Starship"
	@echo "  - Run 'make help' to see more commands"
