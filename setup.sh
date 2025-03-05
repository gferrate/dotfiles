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

  VSCODE_SETTINGS_DIR="$HOME/Library/Application Support/Code/User"
  VSCODE_SETTINGS_FILE="$VSCODE_SETTINGS_DIR/settings.json"
  VSCODE_EXTENSIONS_FILE="$VSCODE_SETTINGS_DIR/extensions.json"

  mkdir -p "$VSCODE_SETTINGS_DIR"
  mkdir -p "$PWD/vscode/backups"

  # Create settings file if it doesn't exist or backup existing
  if [ -f "$VSCODE_SETTINGS_FILE" ]; then
    echo "Backing up existing VS Code settings..."
    BACKUP_TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    cp "$VSCODE_SETTINGS_FILE" "$VSCODE_SETTINGS_FILE.backup_$BACKUP_TIMESTAMP"
    cp "$VSCODE_SETTINGS_FILE" "$PWD/vscode/backups/settings.json.backup_$BACKUP_TIMESTAMP"
    echo "✅ Settings backed up to $VSCODE_SETTINGS_FILE.backup_$BACKUP_TIMESTAMP"
    echo "✅ Settings also backed up to $PWD/vscode/backups/settings.json.backup_$BACKUP_TIMESTAMP"
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
  echo "✅ VS Code extensions file configured successfully!"
}

all() {
  echo "Running all setup functions..."
  setup_zsh
  setup_vscode
  echo "✅ Setup completed successfully!"
}

all
