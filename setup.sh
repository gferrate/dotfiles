set -e

BACKUPS_DIR="$PWD/backups"
mkdir -p "$BACKUPS_DIR"

setup_zsh() {
  echo "Setting up ZSH configuration..."
  ZSHRC="$HOME/.zshrc"
  echo "ZSH config file: $ZSHRC"

  echo "Creating dotfiles directory if it doesn't exist..."

  # Create the file if it doesn't exist
  touch "$ZSHRC"

  # Check if the source line already exists in .zshrc
  if grep -q "source $PWD/zshrc.sh" "$ZSHRC"; then
    echo "✅ Source command already exists in $ZSHRC"
  else
    echo "Adding source command to $ZSHRC..."
    echo "" >>"$ZSHRC"
    echo "# Added by dotfiles setup script" >>"$ZSHRC"
    echo "source $PWD/zshrc.sh" >>"$ZSHRC"
    echo "✅ Added custom commands to $ZSHRC"
  fi
}

setup_vscode() {
  echo "Setting up VS Code configuration..."

  # Check if running on macOS
  if [[ "$(uname)" == "Darwin" ]]; then
    VSCODE_SETTINGS_DIR="$HOME/Library/Application Support/Code/User"
  elif [[ "$(uname)" == "Linux" ]]; then
    VSCODE_SETTINGS_DIR="$HOME/.config/Code/User"
  else
    echo "❌ Unsupported operating system. VS Code setup skipped."
    return 1
  fi

  VSCODE_SETTINGS_FILE="$VSCODE_SETTINGS_DIR/settings.json"

  mkdir -p "$VSCODE_SETTINGS_DIR"
  mkdir -p "$BACKUPS_DIR/vscode"

  # Create settings file if it doesn't exist or backup existing
  if [ -f "$VSCODE_SETTINGS_FILE" ]; then
    echo "Backing up existing VS Code settings..."
    BACKUP_TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    BACKUP_FILE="$BACKUPS_DIR/vscode/settings.$BACKUP_TIMESTAMP.json"
    cp "$VSCODE_SETTINGS_FILE" "$BACKUP_FILE"
    echo "✅ Settings also backed up to $BACKUP_FILE"
  else
    echo "Creating new VS Code settings file..."
    touch "$VSCODE_SETTINGS_FILE"
  fi

  # Copy your custom settings
  echo "Applying custom VS Code settings..."
  cp "$PWD/vscode/settings.json" "$VSCODE_SETTINGS_FILE"
  # Add JetBrains Mono Nerd Font to VS Code settings
  jq '.["editor.fontFamily"] = "JetBrainsMono Nerd Font"' "$VSCODE_SETTINGS_FILE" >tmp.$$.json && mv tmp.$$.json "$VSCODE_SETTINGS_FILE"

  echo "Applying VS Code extensions recommendations..."
  EXTENSIONS_FILE="$PWD/vscode/extensions.txt"
  while read -r line; do
    echo "Installing $line..."
    code --install-extension "$line"
  done <"$EXTENSIONS_FILE"

  echo "✅ VS Code settings configured successfully!"
  echo "✅ VS Code extensions file configured successfully!\n\n"
}

setup_brew() {
  # Check if running on macOS
  if [[ "$(uname)" != "Darwin" ]]; then
    echo "Not running on macOS, skipping Homebrew setup."
    return 0
  fi

  echo "Setting up Homebrew packages..."

  # Check if Homebrew is installed
  if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    echo "Homebrew is already installed."
  fi

  # Define array of packages to install
  PACKAGES=("git" "gh" "neovim" "zsh" "zsh-completions" "autojump" "ripgrep")

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

  # mkdir -p $COMPUTER_NVIM_DIR
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
  setup_brew
  setup_zsh
  setup_vscode
  setup_vimchad
  install_jetbrains_nerd_font
  echo "✅ Setup completed successfully!"
}

all
