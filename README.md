# mac-dev-bootstrap

Bootstrap a fresh macOS machine for PHP development (with some Node/JS tooling). This repository installs command‑line tools, GUI apps, PHP runtimes and extensions, Composer tooling, Node via NVM, and a terminal prompt via Starship.

The setup is **reproducible and scriptable** using Homebrew Bundle and a small `Makefile`.

---

## Quick-start cheat sheet

For a new Mac, the simplest setup:

```bash
# 1. Install Xcode Command Line Tools (if not already installed)
xcode-select --install

# 2. Install Homebrew (if not already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$($(brew --prefix)/bin/brew shellenv)"' >> ~/.zprofile
eval "$($(brew --prefix)/bin/brew shellenv)"

# 3. Clone and bootstrap this repo
git clone https://github.com/your-user/mac-dev-bootstrap.git
cd mac-dev-bootstrap
make bootstrap

# 4. Configure your shell
# Add the shell snippet from README (NVM, Composer, Starship)
# Then restart terminal or source ~/.zshrc
```

With this, you’ll have all required CLI tools, Node versions, PHP extensions, and GUI apps installed.

---

## What gets installed

**Core CLI tools:** `git`, `gh`, `jq`, `ripgrep`, `fd`, `htop`, `watch`, `tree`, `starship`
**PHP:** `php` (latest), `php@8.2`, `composer`, `sphp`
**Symfony:** `symfony-cli`
**Node/JS:** `nvm`
**Containers/infra:** `docker`, `caddy`, `mkcert`
**Database clients:** `mysql-client`, `postgresql@16`
**GUI apps:** `iterm2`, `jetbrains-toolbox`, `cursor`, `dbeaver-community`, `postman`, `font-jetbrains-mono`, `handbrake`, `microsoft-teams`, `1password`, `ngrok`

**Composer global tools:** `phpunit/phpunit`, `symfony/phpunit-bridge`, `friendsofphp/php-cs-fixer`, `phpstan/phpstan`, `symfony/maker-bundle`, `symfony/console`, `symfony/var-dumper`, `psy/psysh`

**Node global tools:** TypeScript, ESLint, Prettier, Expo CLI, React Native CLI

---

## Prerequisites

- **Xcode Command Line Tools**: Needed for building PHP/PECL extensions
```bash
xcode-select --install
```
- **Homebrew**:  
```bash
/bin/bash -c "$(curl -fsSL [https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh](https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh))"
echo 'eval "$($(brew --prefix)/bin/brew shellenv)"' >> ~/.zprofile
eval "$($(brew --prefix)/bin/brew shellenv)"
````

> The Makefile will check for both Xcode CLTs and Homebrew and guide you if something is missing.

---

## Optional step-by-step

- Install Homebrew packages only:
```bash
make brew
````

* Install Node versions individually:

```bash
make node-16
make node-22
make node-latest
make node-default
```

* Check PHP versions:

```bash
make php-check
```

* Install PHP extensions:

```bash
make php-ext        # installs redis + xdebug
make php-ext-redis
make php-ext-xdebug
```

* Install Composer global tools:

```bash
make composer-global
```

* Install Node global tools:

```bash
make node-global
```

---

## Shell configuration

Add the following to your `~/.zshrc` (or use the provided `zsh/.zshrc` as a template):

```bash
# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# Starship
eval "$(starship init zsh)"
```

Copy Starship config:

```bash
mkdir -p ~/.config
cp -n starship/starship.toml ~/.config/starship.toml
```

---

## Optional: Trust local HTTPS with mkcert

```bash
mkcert -install
mkcert localhost
```

---

## Make targets

* `make bootstrap` — Full setup: Homebrew, Node, PHP extensions
* `make brew` — Install Homebrew packages
* `make node` — Install all Node versions
* `make php-check` — Show PHP versions
* `make php-ext` — Install PHP extensions

Run `make help` to see all targets.

---

## Updating

* **Homebrew packages:** `brew update && brew upgrade`
* **Composer global tools:** `make composer-global`
* **Node globals:** `make node-global`

---

## FAQ

**Do I have to install all GUI apps?**
No — you can comment out lines in the Brewfile if you don’t need them.

**Can I pin PHP versions?**
Yes — update `PHP_VERSIONS` in the Makefile. Extensions will be installed for all listed versions.

**Where do Composer global tools install?**
Typically under `~/.config/composer` (Composer 2) or `~/.composer` (older versions). Make sure `vendor/bin` is on your `PATH`.

---

## License

ISC. Adjust as needed.

### Coming soon:
 - git hub cli
 - gh cli set up
 - multi project downloader
 - aws cli and set up
 - lf vpn stuff
 - can we create a script to import all the database config
