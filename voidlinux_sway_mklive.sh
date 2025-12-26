#!/bin/bash
# Script automatizado para gerar ISO Void Linux custom com Sway + Flatpak pré-configurado
# Agora com boot direto para interface gráfica (Sway) no live environment (autologin + auto-start Sway)
# Rode em um sistema Void Linux instalado (glibc ou musl)
# Requisitos: git, bash, curl, conexão à internet

set -e  # Aborta se algum comando falhar

# Configurações (edite aqui se quiser mudar)
ARCH="x86_64-musl"                  # ou "x86_64" para glibc
OUTPUT_ISO="void-custom-sway-$(date +%Y%m%d).iso"
INCLUDE_DIR="include-dir"           # Diretório único de inclusão
KEYMAP="br"
LOCALE="pt_BR.UTF-8"

# Pacotes para um ambiente Sway completo + Flatpak + apps úteis + Bluetooth
PACKAGES="sway seatd dbus polkit foot Waybar swayidle swaylock grim slurp light wofi mako \
          pipewire wireplumber blueman fastfetch simple-scan thunderbird audacious gimp \
          transmission-gtk rpi-imager firefox gwenview kate kdenlive yt-dlp xfburn audacity \
          inkscape lutris kitty rsync flatpak xdg-desktop-portal xdg-desktop-portal-gtk \
          xdg-desktop-portal-wlr bluez libspa-bluetooth gnome-boxes"

# Serviços a ativar no live
SERVICES="seatd dbus bluetoothd"

echo "Clonando void-mklive..."
git clone https://github.com/void-linux/void-mklive.git
cd void-mklive

echo "Preparando diretório de inclusão ($INCLUDE_DIR)..."
rm -rf ../$INCLUDE_DIR  # Limpa se já existir (evita conflitos)
mkdir -p ../$INCLUDE_DIR/etc/skel/.config/sway
mkdir -p ../$INCLUDE_DIR/etc/flatpak/remotes.d
mkdir -p ../$INCLUDE_DIR/etc/skel/.bash_profile.d  # Para auto-start Sway

# === Configs do Sway ===
echo "Criando configuração básica do Sway (compatível com seus pacotes)..."

cat > ../$INCLUDE_DIR/etc/skel/.config/sway/config << 'EOF'
# Configuração básica do Sway para Void Linux custom
# Teclado brasileiro
input * xkb_layout br
input * xkb_variant abnt2

# Terminal padrão: kitty
set $term kitty

# Launcher: wofi
set $menu wofi --show drun -i

# Mod key: Super (Windows)
set $mod Mod4

# Atalhos básicos
bindsym $mod+Return exec $term
bindsym $mod+d exec $menu
bindsym $mod+Shift+q kill
bindsym $mod+Shift+c reload
bindsym $mod+Shift+e exec swaymsg exit

# Movimentação entre janelas
bindsym $mod+h focus left
bindsym $mod+j focus down
bindsym $mod+k focus up
bindsym $mod+l focus right

# Mover janelas
bindsym $mod+Shift+h move left
bindsym $mod+Shift+j move down
bindsym $mod+Shift+k move up
bindsym $mod+Shift+l move right

# Estilo
for_window [class=".*"] border pixel 2
gaps inner 10
gaps outer 5

# Barra de status
bar {
    swaybar_command Waybar
}

# Programas ao iniciar
exec Waybar
exec swaybg -i /usr/share/backgrounds/sway/Sway_Wallpaper_Blue_1920x1080.png -m fill || true

# Bloqueio de tela
exec swayidle -w timeout 300 'swaylock -f' timeout 600 'swaymsg "output * dpms off"' resume 'swaymsg "output * dpms on"'

include /etc/sway/config.d/*
EOF

echo "Configuração básica do Sway criada com sucesso."

# === Auto-start Sway no live (autologin no tty1 + iniciar Sway automaticamente) ===
echo "Configurando boot direto para Sway (autologin + auto-start)..."
cat > ../$INCLUDE_DIR/etc/skel/.bash_profile << 'EOF'
# Auto-start Sway se estiver no tty1 e não houver DISPLAY (Wayland/X)
if [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    exec sway
fi
EOF

# === Config Flatpak ===
echo "Adicionando remote Flathub para Flatpak (usando curl)..."
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
echo "Agora o live environment inicia diretamente na interface gráfica Sway!"
echo "Usuário live: anon (senha: voidlinux) – login automático no tty1 e Sway inicia sozinho."
echo "Flatpak configurado com Flathub."
echo "Bluetooth ativado (bluetoothd)."
echo "Teste a ISO em uma VM!"
echo "=================================="
