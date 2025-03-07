set -e

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
  VSCODE_EXTENSIONS_FILE="$VSCODE_SETTINGS_DIR/extensions.json"

  mkdir -p "$VSCODE_SETTINGS_DIR"
  mkdir -p "$PWD/vscode/backups"

  # Create settings file if it doesn't exist or backup existing
  if [ -f "$VSCODE_SETTINGS_FILE" ]; then
    echo "Backing up existing VS Code settings..."
    BACKUP_TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    BACKUP_FILE="$PWD/vscode/backups/settings.$BACKUP_TIMESTAMP.backup.json"
    cp "$VSCODE_SETTINGS_FILE" "$BACKUP_FILE"
    echo "✅ Settings also backed up to $BACKUP_FILE"
  else
    echo "Creating new VS Code settings file..."
    touch "$VSCODE_SETTINGS_FILE"
  fi

  # Copy your custom settings
  echo "Applying custom VS Code settings..."
  cp "$PWD/vscode/settings.json" "$VSCODE_SETTINGS_FILE"

  # Copy the extensions.json file
  echo "Applying VS Code extensions recommendations..."
  cp "$PWD/vscode/extensions.json" "$VSCODE_EXTENSIONS_FILE"

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
  PACKAGES=("git" "gh" "neovim" "zsh" "zsh-completions" "autojump")

  # Install packages one by one
  echo "Installing required packages..."
  for package in "${PACKAGES[@]}"; do
    echo "Installing $package..."
    brew install "$package"
    echo "✅ $package installed successfully!\n"
  done

  echo "✅ Homebrew setup completed successfully!\n"
}

all() {
  echo "Running all setup functions...\n"
  setup_brew
  setup_zsh
  setup_vscode
  echo "✅ Setup completed successfully!"
}

all
