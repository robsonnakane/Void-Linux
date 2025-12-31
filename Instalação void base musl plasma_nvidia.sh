#!/bin/bash

# 🐧 Void Linux + KDE Plasma + PipeWire — Tutorial
# ⚠️ **IMPORTANTE — LEIA ANTES DE COMEÇAR**
# Este tutorial **NÃO deve ser executado como `root`**, exceto quando **explicitamente indicado**.
# Todos os comandos foram pensados para serem executados por **um usuário comum**, utilizando `root` quando necessário.
# Executar todo o tutorial logado como `root`:
# - quebra a lógica de permissões
# - invalida etapas como configuração de `root`
# - pode gerar erros silenciosos ou comportamentos inesperados
# 👉 **Recomendação**  
# Se você acabou de instalar o sistema e está logado como `root`:
# 1. Crie um usuário comum
# 2. Faça login com esse usuário
# 3. Siga o tutorial normalmente
# Regra clássica de sistemas Unix/Linux:
# **`root` é exceção. Usuário comum é regra.**

## 0. Configurar doas - (grupo wheel) - evita ficar pedindo senha de root
#doas usermod -aG wheel "$USER"
#doas tee -a /etc/doasers.d/g_wheel #/dev/null << EOF
#%wheel ALL=(ALL:ALL) NOPASSWD: ALL
#EOF
#Permissões obrigatórias
#doas chmod 440 /etc/doasers.d/g_wheel

##baixar o shell script do github
#doas xbps-install -S -y git;
#git clone https://github.com/robsonnakane/Void-Linux.git;

## 1. Atualizar o sistema
doas xbps-install -u xbps;
doas xbps-install -Syu;
doas xbps-install -S -y xtools seatd;

## 2. Instalar o Plasma completo (meta-pacote)
doas xbps-install -S -y kde-plasma noto-fonts-emoji xorg-minimal;


## 3. Instalar o SDDM (display manager oficial do KDE)
#doas xbps-install -S -y sddm; #Tela de login para o notebook
doas xbps-install -S -y lightdm lightdm-gtk3-greeter; #Tela de login para o desktop

## 4. Instalar áudio com PipeWire (som completo)
### PipeWire + WirePlumber + ALSA + Pulse compat
doas xbps-install -S -y pipewire wireplumber alsa-pipewire libjack-pipewire alsa-utils pavucontrol;

## 5. Drivers de vídeo (escolher para o notebook)
### Intel
#doas xbps-install -S -y mesa-dri linux-firmware-intel;

### AMD nova (amdgpu)
#doas xbps-install -S -y mesa-dri xf86-video-amdgpu;
### AMD antiga 
#doas xbps-install -S -y mesa-dri xf86-video-ati;


### Nvidia (driver aberto) (escolher para o desktop)
doas xbps-install -S -y mesa-nouveau-dri;

### Nvidia (proprietário)
#doas xbps-install -S -y void-repo-nonfree;
#doas xbps-install -S -y nvidia;

xcheckrestart;

## 6. Ativar serviços obrigatórios (runit)
doas rm -rf /var/service/dbus;
doas ln -s /etc/sv/dbus /var/service/;

doas rm -rf /var/service/seatd;
doas ln -s /etc/sv/seatd /var/service/;

doas rm -rf /var/service/polkitd;
doas ln -s /etc/sv/polkitd /var/service/;

doas rm -rf /var/service/NetworkManager;
doas ln -s /etc/sv/NetworkManager /var/service/;

#Tela de login para o notebook
#doas rm -rf /var/service/sddm;
#doas ln -s /etc/sv/sddm /var/service/;
#doas sv restart sddm

#Tela de login para o desktop
doas rm -rf /var/service/lightdm;
doas ln -s /etc/sv/lightdm /var/service/;
doas sv restart lightdm
