#!/bin/bash
set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly ZED_THEMES_DIR="$HOME/.config/zed/themes"
readonly BACKUP_DIR="$HOME/.config/zed/themes/backup-$(date +%Y%m%d-%H%M%S)"

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*" >&2
}

create_backup() {
    if [[ -d "$ZED_THEMES_DIR" ]]; then
        log "Creating backup at: $BACKUP_DIR"
        mkdir -p "$BACKUP_DIR"
        cp -r "$ZED_THEMES_DIR"/* "$BACKUP_DIR"/ 2>/dev/null || true
    fi
}

install_themes() {
    log "Installing Phantumbra themes..."
    mkdir -p "$ZED_THEMES_DIR"

    cp "$SCRIPT_DIR/zed/phantumbra-cyberpunk-blur.json" "$ZED_THEMES_DIR/"
    cp "$SCRIPT_DIR/zed/phantumbra-cyberpunk-variants.json" "$ZED_THEMES_DIR/"

    log "Themes installed successfully"
    log "Available themes:"
    log "  - Phantumbra Neon Cyberpunk [Dark] (pure cyberpunk neon)"
    log "  - Phantumbra Cyber Light [Light] (violet pastel with enhanced UI)"
    log "  - Phantumbra Deep Blur [Dark] (deep purple cyberpunk)"
}

update_zed_config() {
    local zed_config="$HOME/.config/zed/settings.json"

    if [[ -f "$zed_config" ]]; then
        log "Found existing Zed config"
        log "To use theme, add to settings.json:"
        log '  "theme": "Phantumbra Neon Cyberpunk [Dark]"'
    else
        log "Creating new Zed config with theme"
        mkdir -p "$(dirname "$zed_config")"
        cat > "$zed_config" << 'EOF'
{
  "theme": "Phantumbra Neon Cyberpunk [Dark]",
  "buffer_font_family": "JetBrains Mono",
  "buffer_font_size": 14,
  "ui_font_size": 16,
  "wrap_guides": [80, 120],
  "soft_wrap": "editor_width",
  "show_whitespaces": "selection",
  "relative_line_numbers": true,
  "vim_mode": false,
  "auto_update": true,
  "telemetry": {
    "metrics": false,
    "diagnostics": false
  }
}
EOF
        log "Created $zed_config with Phantumbra theme"
    fi
}

main() {
    log "S1B Phantumbra Theme Installer"
    log "Installing cyberpunk blur themes for Zed..."

    if ! command -v zed &> /dev/null; then
        log "Warning: Zed editor not found in PATH"
        log "Install from: https://zed.dev"
    fi

    create_backup
    install_themes
    update_zed_config

    log "Installation complete!"
    log "Restart Zed to see the new themes"
    log "Backup created at: $BACKUP_DIR"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
