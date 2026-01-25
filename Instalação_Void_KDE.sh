#!/usr/bin/env bash
# shellcheck shell=bash

# =============================================================================
# Instalação automatizada do KDE Plasma no Void Linux
# Com verificações de dependências + VERIFICAÇÃO DE KERNEL (LTS ou MAINLINE)
# Baseado em: https://github.com/VoidLinuxBR/tutoriais/blob/main/DE/tutorial-void-plasma.md
# =============================================================================

set -euo pipefail

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

error()   { echo -e "${RED}ERRO:${NC} $*" >&2; exit 1; }
warning() { echo -e "${YELLOW}AVISO:${NC} $*" >&2; }
success() { echo -e "${GREEN}OK:${NC} $*"; }

# ─── Funções auxiliares ───────────────────────────────────────────────────────

package_installed() {
    xbps-query -l "$1" >/dev/null 2>&1
}

packages_installed() {
    local -a pkgs=("$@")
    for pkg in "${pkgs[@]}"; do
        package_installed "$pkg" || return 1
    done
    return 0
}

ensure_package_group() {
    local group_name="$1"
    shift
    local -a pkgs=("$@")

    if packages_installed "${pkgs[@]}"; then
        success "[$group_name] Já instalado → pulando"
        return 0
    fi

    echo "→ Instalando $group_name..."
    sudo xbps-install -y "${pkgs[@]}" || error "Falha ao instalar $group_name"
    success "[$group_name] Instalado"
}

repo_enabled() {
    xbps-query -L | grep -q "$1"
}

# ─── VERIFICAÇÃO DE KERNEL + VERSÃO MÍNIMA ────────────────────────────────

check_kernel() {
    echo
    echo "→ Verificação de kernel atual:"
    current_kernel=$(uname -r)
    echo "Kernel em uso ........: $current_kernel"

    kernel_version=$(echo "$current_kernel" | cut -d'.' -f1-2 | tr -d '[:alpha:]')

    if [[ $current_kernel == *lts* ]]; then
        success "Kernel LTS detectado → ótima escolha para estabilidade com Plasma"
    elif [[ $current_kernel == *mainline* ]]; then
        success "Kernel mainline detectado → versões mais recentes, bom suporte a hardware novo"
    else
        warning "Kernel padrão detectado"
    fi

    echo
    echo "Requisitos recomendados para KDE Plasma no Void Linux (2025/2026):"
    echo "  • Mínimo aceitável .........: ≥ 5.15"
    echo "  • Recomendado (Wayland/PipeWire/hardware recente): ≥ 6.1"
    echo "  • linux-mainline ...........: geralmente traz a versão stable mais nova"
    echo

    if ! [[ "$kernel_version" =~ ^[0-9]+\.[0-9]+$ ]]; then
        warning "Não foi possível extrair a versão do kernel de forma confiável"
        return
    fi

    major=$(echo "$kernel_version" | cut -d'.' -f1)
    minor=$(echo "$kernel_version" | cut -d'.' -f2)

    if (( major < 5 )) || (( major == 5 && minor < 15 )); then
        error "Kernel muito antigo ($kernel_version)! Mínimo aceitável: 5.15"
        error "Plasma pode falhar (Wayland, drivers gráficos, etc.)"
        error "Instale linux-lts ou linux-mainline e reinicie ANTES de continuar."
    elif (( major < 6 )) || (( major == 6 && minor < 1 )); then
        warning "Kernel um pouco antigo ($kernel_version)"
        warning "→ Funciona, mas pode ter problemas com Wayland, PipeWire ou hardware recente"
        warning "→ Recomenda-se linux-lts ou linux-mainline"
    else
        success "Versão do kernel OK ($kernel_version) — ≥ 6.1"
    fi

    echo
}

offer_install_kernel() {
    echo "Qual kernel você deseja instalar/atualizar?"
    echo "  1) linux-lts     → estabilidade comprovada (recomendado para a maioria)"
    echo "  2) linux-mainline → versões mais recentes (bom para hardware novo)"
    echo "  0) Pular / manter atual"
    echo -n "Opção: "
    read -r kernel_option

    local kernel_pkg=""
    case "$kernel_option" in
        1)
            kernel_pkg="linux-lts"
            ;;
        2)
            kernel_pkg="linux-mainline"
            ;;
        0|"")
            if (( major < 6 )); then
                warning "Continuando com kernel antigo — pode haver problemas com Plasma"
            fi
            echo "Pulando instalação de kernel alternativo"
            return
            ;;
        *)
            warning "Opção inválida → pulando"
            return
            ;;
    esac

    echo "→ Instalando $kernel_pkg + headers..."
    sudo xbps-install -y "${kernel_pkg}" "${kernel_pkg}-headers" || error "Falha ao instalar $kernel_pkg"

    echo "→ Reconfigurando initramfs..."
    sudo xbps-reconfigure -f "$kernel_pkg" || error "Falha ao reconfigurar initramfs"

    if [[ -d /boot/grub ]]; then
        echo "→ Atualizando GRUB..."
        sudo grub-mkconfig -o /boot/grub/grub.cfg || warning "Falha ao atualizar grub.cfg — faça manualmente se necessário"
    else
        warning "GRUB não detectado → atualize seu bootloader manualmente"
    fi

    success "$kernel_pkg instalado com sucesso!"
    warning "→ Reinicie o sistema agora"
    warning "→ No GRUB, selecione o novo kernel se houver múltiplas opções"
    warning "→ Após o reboot, execute este script novamente para continuar a instalação do Plasma"
    exit 0  # Força saída → usuário deve rebootar antes de prosseguir
}

# ─── Início do script ─────────────────────────────────────────────────────────

echo "============================================"
echo "  Instalação KDE Plasma no Void Linux"
echo "  + Verificação de kernel + opção LTS ou MAINLINE"
echo "============================================"
echo

[[ $EUID -eq 0 ]] && error "Não execute como root. Use usuário comum com sudo."

command -v sudo >/dev/null 2>&1 || error "sudo não encontrado."

# Passo 0: sudo wheel sem senha
if ! groups | grep -qw wheel; then
    sudo usermod -aG wheel "$USER" || error "Falha ao adicionar ao grupo wheel"
fi

if ! sudo grep -qE '^%wheel.*NOPASSWD' /etc/sudoers /etc/sudoers.d/* 2>/dev/null; then
    echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/99-wheel-nopasswd >/dev/null
    sudo chmod 0440 /etc/sudoers.d/99-wheel-nopasswd
    success "sudo sem senha configurado"
    warning "Faça logout + login (ou newgrp wheel)"
fi

# Atualização inicial
sudo xbps-install -Syu || error "Falha na atualização do sistema"

# VERIFICAÇÃO E OFERTA DE KERNEL
check_kernel
offer_install_kernel

# Passo 2–4: Plasma, SDDM, PipeWire
ensure_package_group "KDE Plasma + emoji" plasma-desktop noto-fonts-emoji
ensure_package_group "SDDM" sddm
ensure_package_group "PipeWire + áudio" pipewire wireplumber alsa-pipewire libjack-pipewire alsa-utils pavucontrol

# Passo 5: Driver gráfico
echo
echo "Driver de vídeo (escolha):"
echo "  1) Intel          2) AMD amdgpu     3) AMD antiga"
echo "  4) Nouveau        5) Nvidia proprietário"
echo "  0) Pular / já tenho"
echo -n "Opção: "
read -r drv
case "$drv" in
    1) ensure_package_group "Intel" mesa-dri linux-firmware-intel ;;
    2) ensure_package_group "AMD amdgpu" mesa-dri xf86-video-amdgpu ;;
    3) ensure_package_group "AMD antiga" mesa-dri xf86-video-ati ;;
    4) ensure_package_group "Nouveau" mesa-nouveau-dri ;;
    5)
        repo_enabled nonfree || { echo "→ Ativando repositório nonfree..."; sudo xbps-install -y void-repo-nonfree; }
        ensure_package_group "Nvidia proprietário" nvidia
        ;;
    *) warning "Nenhum driver selecionado" ;;
esac

if ! package_installed mesa-dri; then
    warning "mesa-dri NÃO instalado → aceleração 3D pode não funcionar bem"
fi

# Passo 6: Serviços
services=(dbus elogind polkitd NetworkManager sddm)
for svc in "${services[@]}"; do
    if [[ -L "/var/service/$svc" ]]; then
        success "Serviço $svc já ativado"
    else
        sudo ln -s "/etc/sv/$svc" "/var/service/" && success "Serviço $svc ativado" || error "Falha ao ativar $svc"
    fi
done

# .xinitrc opcional
echo
echo -n "Criar ~/.xinitrc para uso com startx? (s/n): "
read -r resp
if [[ "$resp" =~ ^[sS]$ ]]; then
    if [[ -f "$HOME/.xinitrc" ]]; then
        warning "~/.xinitrc já existe → não será sobrescrito"
    else
        cat > "$HOME/.xinitrc" << 'EOF'
#!/usr/bin/env bash
setxkbmap -layout br -variant abnt2 &
exec startplasma-x11
EOF
        chmod +x "$HOME/.xinitrc"
        success "~/.xinitrc criado"
    fi
fi

# Resumo final
echo
echo "============================================"
echo "             CONCLUSÃO"
echo "============================================"
echo
echo "Kernel atual ................: $(uname -r)"
echo "Melhor experiência Plasma   : kernel ≥ 6.1 (LTS ou mainline)"
echo
echo "Pacotes principais instalados:"
package_installed plasma   && echo "  plasma     → sim" || echo "  plasma     → NÃO (!)"
package_installed sddm     && echo "  sddm       → sim" || echo "  sddm       → NÃO (!)"
package_installed mesa-dri && echo "  mesa-dri   → sim" || echo "  mesa-dri   → NÃO (!)"
echo
echo "Execute: sudo reboot"
echo "→ Com SDDM → login gráfico no Plasma"
echo "→ Sem SDDM → use 'startx' após login no console"
echo

exit 0
