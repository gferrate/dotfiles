#!/bin/zsh
set -e

BACKUPS_DIR="$PWD/backups"
mkdir -p "$BACKUPS_DIR"

is_macos() {
  [[ "$(uname)" == "Darwin" ]]
}

setup_oh_my_zsh() {
  if [ -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]; then
    echo "✅ Oh My Zsh is already installed. Skipping installation."
  else
    COMPUTER_ZSHRC="$HOME/.zshrc"
    # Create backup of existing .zshrc if it exists
    if [ -f "$COMPUTER_ZSHRC" ]; then
      BACKUP_FILE="$COMPUTER_ZSHRC.before_ohmyzsh_backup.$(date +%Y%m%d_%H%M%S)"
      echo "Creating backup of existing .zshrc at $BACKUP_FILE..."
      cp "$COMPUTER_ZSHRC" "$BACKUP_FILE"
      echo "✅ Created backup of existing .zshrc"
    fi

    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc
    echo "✅ Oh My Zsh installed successfully!"
  fi
}

setup_zsh() {
  echo "Setting up ZSH configuration..."
  COMPUTER_ZSHRC="$HOME/.zshrc"
  DOTFILES_ZSHRC="$PWD/zshrc.sh"
  echo "ZSH config file: $COMPUTER_ZSHRC"

  # Create backup of existing .zshrc if it exists
  if [ -f "$COMPUTER_ZSHRC" ]; then
    BACKUP_FILE="$COMPUTER_ZSHRC.backup.$(date +%Y%m%d_%H%M%S)"
    echo "Creating backup of existing .zshrc at $BACKUP_FILE..."
    cp "$COMPUTER_ZSHRC" "$BACKUP_FILE"
    echo "✅ Created backup of existing .zshrc"
  fi

  echo "Creating dotfiles directory if it doesn't exist..."

  # Create the file if it doesn't exist
  touch "$COMPUTER_ZSHRC"

  # Check if the source line already exists in .zshrc
  if grep -q "source $DOTFILES_ZSHRC" "$COMPUTER_ZSHRC"; then
    echo "✅ Source command already exists in $COMPUTER_ZSHRC"
  else
    echo "Adding source command to $COMPUTER_ZSHRC..."
    echo "" >>"$COMPUTER_ZSHRC"
    echo "# Added by dotfiles setup script" >>"$COMPUTER_ZSHRC"
    echo "source $DOTFILES_ZSHRC" >>"$COMPUTER_ZSHRC"
    echo "✅ Added custom commands to $COMPUTER_ZSHRC"
  fi

  if is_macos; then
    # Remove sticky notes from the dock
    defaults write com.apple.dock wvous-br-corner -int 0
    defaults write com.apple.dock wvous-br-modifier -int 0
    killall Dock # Restart the Dock
    echo "✅ Removed sticky notes from the dock"
  fi
}

setup_cursor() {
  if ! command -v cursor &>/dev/null; then
    echo "❌ Cursor command not found. Cursor setup skipped."
    echo ""
    return
  fi

  # Check if running on macOS
  if is_macos; then
    CURSOR_SETTINGS_DIR="$HOME/Library/Application Support/Cursor/User"
  elif [[ "$(uname)" == "Linux" ]]; then
    CURSOR_SETTINGS_DIR="$HOME/.config/Cursor/User"
  else
    echo "❌ Unsupported operating system. Cursor setup skipped."
    echo ""
    return
  fi

  CURSOR_SETTINGS_FILE="$CURSOR_SETTINGS_DIR/settings.json"

  mkdir -p "$CURSOR_SETTINGS_DIR"
  mkdir -p "$BACKUPS_DIR/cursor"

  # Create settings file if it doesn't exist or backup existing
  if [ -f "$CURSOR_SETTINGS_FILE" ]; then
    echo "Backing up existing Cursor settings..."
    BACKUP_TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    BACKUP_FILE="$BACKUPS_DIR/cursor/settings.$BACKUP_TIMESTAMP.json"
    cp "$CURSOR_SETTINGS_FILE" "$BACKUP_FILE"
    echo "✅ Settings also backed up to $BACKUP_FILE"
  else
    echo "Creating new Cursor settings file..."
    touch "$CURSOR_SETTINGS_FILE"
  fi

  # Copy your custom settings
  echo "Applying custom Cursor settings..."
  cp "$PWD/cursor/settings.json" "$CURSOR_SETTINGS_FILE"
  # Add JetBrains Mono Nerd Font to Cursor settings
  jq '.["editor.fontFamily"] = "JetBrainsMono Nerd Font"' "$CURSOR_SETTINGS_FILE" >tmp.$$.json && mv tmp.$$.json "$CURSOR_SETTINGS_FILE"

  echo "Applying VS Code extensions recommendations..."
  EXTENSIONS_FILE="$PWD/cursor/extensions.txt"
  while read -r line; do
    echo "Installing $line..."
    if ! cursor --install-extension "$line"; then
      echo "⚠️ Failed to install extension: $line"
    fi
  done <"$EXTENSIONS_FILE"

  echo "✅ Cursor settings configured successfully!\n\n"
}

install_brew() {
  echo "Setting up Homebrew packages..."
  export HOMEBREW_NO_AUTO_UPDATE=1

  # Check if Homebrew is installed
  if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    if is_macos; then
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
      # Linux installation
      NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

      # Add Homebrew to PATH for Linux
      echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >>"$HOME/.zshrc"
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

      source "$HOME/.zshrc"
    fi
  else
    echo "Homebrew is already installed."
  fi

  # Define array of packages to install
  PACKAGES=("git" "gh" "neovim" "zsh" "zsh-completions" "ripgrep" "autojump")

  # Install packages one by one
  echo "Installing required packages..."
  for package in "${PACKAGES[@]}"; do
    echo "Installing $package..."
    brew install "$package"
    echo "✅ $package installed successfully!\n"
  done

  echo "✅ Homebrew setup completed successfully!\n"
}

setup_vimchad() {
  mkdir -p "$HOME/.config"
  COMPUTER_NVIM_DIR="$HOME/.config/nvim"

  mkdir -p "$BACKUPS_DIR/nvim"

  # Backup existing Neovim configuration
  if [ -d $COMPUTER_NVIM_DIR ]; then
    echo "Backing up existing Neovim configuration..."
    BACKUP_TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    BACKUP_DIR="$BACKUPS_DIR/nvim/nvim.$BACKUP_TIMESTAMP.backup"
    mkdir -p "$BACKUP_DIR"
    cp -r $COMPUTER_NVIM_DIR/* "$BACKUP_DIR"
    echo "✅ Backup created at $BACKUP_DIR"

    echo "Removing existing Neovim configuration..."
    rm -rf $COMPUTER_NVIM_DIR
  fi

  ln -s $PWD/nvim/ "$HOME/.config"

  # nvim --headless +MasonInstallAll +qall
}

install_jetbrains_nerd_font() {
  echo "Installing JetBrains Mono Nerd Font..."
  FONT_DIR="$HOME/.local/share/fonts"
  mkdir -p "$FONT_DIR"

  # Check if JetBrainsMono directory already exists
  if [ -d "$FONT_DIR/JetBrainsMono" ]; then
    echo "✅ JetBrains Mono Nerd Font already installed. Skipping download."
  else
    # Download and install the font
    cd "$FONT_DIR"
    echo "Downloading JetBrains Mono Nerd Font..."
    curl -fLo "JetBrainsMono.zip" https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/JetBrainsMono.zip
    echo "Extracting font files..."
    unzip -q JetBrainsMono.zip -d JetBrainsMono
    rm JetBrainsMono.zip
    echo "Font files extracted successfully."

    # Check if fc-cache is installed
    if ! command -v fc-cache &>/dev/null; then
      echo "fc-cache not found, installing fontconfig..."
      if [[ "$(uname)" == "Darwin" ]]; then
        brew install fontconfig
      else
        sudo apt-get install -y fontconfig
      fi
    fi

    # Update font cache
    echo "Updating font cache..."
    fc-cache -fv
    echo "✅ JetBrains Mono Nerd Font installation completed successfully!"
  fi
}

all() {
  echo "Running all setup functions...\n"
  install_brew
  setup_oh_my_zsh
  setup_zsh
  setup_cursor
  setup_vimchad
  install_jetbrains_nerd_font
  echo "✅ Setup completed successfully!"
}

all
