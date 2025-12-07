#!/bin/bash

set -e

#
# Check if Homebrew is installed
#
echo "Checking if Homebrew is installed..."
if ! command -v brew &>/dev/null; then
  echo "Homebrew is not installed. Installing Homebrew..."

  # Install Homebrew
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Check for errors during installation
  if [ $? -ne 0 ]; then
    echo "Homebrew installation failed. Exiting."
    exit 1
  fi

  echo "Homebrew installed successfully."

  # Post-installation setup
  if [[ "$OSTYPE" == "darwin"* ]]; then
    # For macOS
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    echo "Unsupported OS type: $OSTYPE. Exiting."
    exit 1
  fi
else
  echo "Homebrew is already installed."
fi

# Ensure Homebrew is up to date
brew update && brew upgrade

# Confirm success
echo "Homebrew is ready to use!"

#
# Install applications and tools via Homebrew
#
echo "Installing applications and tools via Homebrew..."
brew install \
  bash \
  dockutil \
  fd \
  fzf \
  gh \
  gnupg \
  mongosh \
  neovim \
  nvm \
  pass \
  ripgrep \
  s3cmd \
  stow \
  stylua \
  tmux \
  tree \
  watchman \
  wget \
  yazi 

# Install additional tools from taps
brew tap mongodb/brew
brew install mongodb-community@5.0
# brew services start mongodb-community@5.0
# brew services stop mongodb-community@5.0

# Install cask applications
brew install --cask \
    android-platform-tools \
    brave-browser \
    claude-code \
    docker \
    ghostty \
    localsend \
    mullvad-vpn \
    obsidian \
    postman \
    the-unarchiver \
    vlc 

# Post-install message
echo "Installation complete. Review output for any issues."

# Optional: Cleanup
brew cleanup

#
# Check if Rosetta 2 is installed
#
echo "Checking if Rosetta 2 is installed..."
if /usr/bin/pgrep oahd &>/dev/null; then
  echo "Rosetta 2 is already installed."
else
  echo "Rosetta 2 is not installed. Installing Rosetta 2..."

  # Prompt for Rosetta installation
  /usr/sbin/softwareupdate --install-rosetta --agree-to-license

  # Check if the installation succeeded
  if [ $? -eq 0 ]; then
    echo "Rosetta 2 installed successfully."
  else
    echo "Failed to install Rosetta 2. Please try manually."
    exit 1
  fi
fi

#
# Post install
#
brew services restart mongodb-community@5.0
brew services list

#
# macos defaults
#
echo "Setting macOS defaults..."

# Show hidden files in Finder
defaults write com.apple.finder AppleShowAllFiles YES
# use touchID for sudo
# sudo sh -c 'echo "auth       sufficient     pam_tid.so" >> /etc/pam.d/sudo'

# Show columns view as default
defaults write com.apple.Finder FXPreferredViewStyle clmv

# Restart Finder
open -a Finder
killall Finder

#
# nvm post install
#
NVM_SETUP='
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion"  # This loads nvm bash_completion
'

# Check if lines already exist
if ! grep -qF 'export NVM_DIR="$HOME/.nvm"' ~/.zshrc; then
  echo "$NVM_SETUP" >>~/.zshrc
  echo "NVM setup added to ~/.zshrc"
else
  echo "NVM setup already exists in ~/.zshrc"
fi

#
# git configs
#
#git config --global user.name "Bengt Bengtsson"
#git config --global user.email "bengt.bengtsson@gmail.com"

git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status

git config --global --list

#
# configue dock
#
# Remove all apps from dock
dockutil --remove all --no-restart
# Add desired applications
echo "Adding desired applications to Dock..."
dockutil --add "/Applications/Brave Browser.app" --no-restart
dockutil --add "/System/Applications/System Settings.app" --no-restart

# Restart the Dock to apply changes
echo "Restarting Dock..."
killall Dock

echo "Dock setup complete!"

# Install manually
