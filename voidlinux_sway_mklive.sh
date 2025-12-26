#!/bin/bash
# Script automatizado para gerar ISO Void Linux custom com Sway + Flatpak pré-configurado
# Com boot direto para Sway + correção para XDG_RUNTIME_DIR
# Rode em um sistema Void Linux instalado (glibc ou musl)
# Requisitos: git, bash, curl, conexão à internet

set -e  # Aborta se algum comando falhar

# Configurações (edite aqui se quiser mudar)
ARCH="x86_64-musl"                  # ou "x86_64" para glibc
OUTPUT_ISO="void-custom-sway-$(date +%Y%m%d).iso"
INCLUDE_DIR="include-dir"           # Diretório único de inclusão
KEYMAP="br"
LOCALE="pt_BR.UTF-8"

# Pacotes (mantidos os mesmos)
PACKAGES="sway seatd dbus polkit foot Waybar swayidle swaylock grim slurp light wofi mako \
          pipewire wireplumber blueman fastfetch simple-scan thunderbird audacious gimp \
          transmission-gtk rpi-imager firefox gwenview kate kdenlive yt-dlp xfburn audacity \
          inkscape lutris kitty rsync flatpak xdg-desktop-portal xdg-desktop-portal-gtk \
          xdg-desktop-portal-wlr bluez libspa-bluetooth"

# Serviços a ativar no live
SERVICES="seatd dbus bluetoothd"

echo "Clonando void-mklive..."
git clone https://github.com/void-linux/void-mklive.git
cd void-mklive

echo "Preparando diretório de inclusão ($INCLUDE_DIR)..."
rm -rf ../$INCLUDE_DIR  # Limpa se já existir
mkdir -p ../$INCLUDE_DIR/etc/skel/.config/sway
mkdir -p ../$INCLUDE_DIR/etc/flatpak/remotes.d

# === Configs do Sway ===
echo "Criando configuração básica do Sway..."
cat > ../$INCLUDE_DIR/etc/skel/.config/sway/config << 'EOF'
# Configuração básica do Sway para Void Linux custom
input * xkb_layout br
input * xkb_variant abnt2

set $term kitty
set $menu wofi --show drun -i
set $mod Mod4

bindsym $mod+Return exec $term
bindsym $mod+d exec $menu
bindsym $mod+Shift+q kill
bindsym $mod+Shift+c reload
bindsym $mod+Shift+e exec swaymsg exit

bindsym $mod+h focus left
bindsym $mod+j focus down
bindsym $mod+k focus up
bindsym $mod+l focus right

bindsym $mod+Shift+h move left
bindsym $mod+Shift+j move down
bindsym $mod+Shift+k move up
bindsym $mod+Shift+l move right

for_window [class=".*"] border pixel 2
gaps inner 10
gaps outer 5

bar { swaybar_command Waybar }

exec Waybar
exec swaybg -i /usr/share/backgrounds/sway/Sway_Wallpaper_Blue_1920x1080.png -m fill || true

exec swayidle -w timeout 300 'swaylock -f' timeout 600 'swaymsg "output * dpms off"' resume 'swaymsg "output * dpms on"'

include /etc/sway/config.d/*
EOF

# === Auto-start Sway com correção XDG_RUNTIME_DIR ===
echo "Configurando boot direto para Sway com XDG_RUNTIME_DIR..."
cat > ../$INCLUDE_DIR/etc/skel/.bash_profile << 'EOF'
# Corrige XDG_RUNTIME_DIR se não existir (essencial para Wayland/Sway no live)
if [ -z "${XDG_RUNTIME_DIR}" ]; then
    export XDG_RUNTIME_DIR=/tmp/$(id -u)-runtime-dir
    if [ ! -d "${XDG_RUNTIME_DIR}" ]; then
        mkdir -p "${XDG_RUNTIME_DIR}"
        chmod 0700 "${XDG_RUNTIME_DIR}"
    fi
fi

# Inicia Sway automaticamente no tty1 (live tem autologin no tty1)
if [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    exec sway
fi
EOF

# === Config Flatpak ===
echo "Adicionando remote Flathub para Flatpak..."
curl -L -o ../$INCLUDE_DIR/etc/flatpak/remotes.d/flathub.flatpakrepo \
     https://dl.flathub.org/repo/flathub.flatpakrepo

echo "Gerando a ISO... (isso pode demorar várias horas)"
./mkiso.sh -a $ARCH -b base \
           -- -p "$PACKAGES" \
              -S "$SERVICES" \
              -I ../$INCLUDE_DIR \
              -k $KEYMAP -l $LOCALE \
              -o ../$OUTPUT_ISO

echo "=================================="
echo "ISO gerada com sucesso: ../$OUTPUT_ISO"
echo "Correção aplicada: XDG_RUNTIME_DIR criado automaticamente no live."
echo "Agora o Sway inicia sem o erro 'XDG_RUNTIME_DIR is not set'."
echo "Teste em VM – boot direto para gráfico!"
echo "=================================="
