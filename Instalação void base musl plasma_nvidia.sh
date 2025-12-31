#!/bin/bash

# 🐧 Void Linux + KDE Plasma + PipeWire — Tutorial
# ⚠️ **IMPORTANTE — LEIA ANTES DE COMEÇAR**
# Este tutorial **NÃO deve ser executado como `root`**, exceto quando **explicitamente indicado**.
# Todos os comandos foram pensados para serem executados por **um usuário comum**, utilizando `sudo` quando necessário.
# Executar todo o tutorial logado como `root`:
# - quebra a lógica de permissões
# - invalida etapas como configuração de `sudo`
# - pode gerar erros silenciosos ou comportamentos inesperados
# 👉 **Recomendação**  
# Se você acabou de instalar o sistema e está logado como `root`:
# 1. Crie um usuário comum
# 2. Faça login com esse usuário
# 3. Siga o tutorial normalmente
# Regra clássica de sistemas Unix/Linux:
# **`root` é exceção. Usuário comum é regra.**

## 0. Configurar sudo - (grupo wheel) - evita ficar pedindo senha de root
#sudo usermod -aG wheel "$USER"
#sudo tee -a /etc/sudoers.d/g_wheel #/dev/null << EOF
#%wheel ALL=(ALL:ALL) NOPASSWD: ALL
#EOF
#Permissões obrigatórias
#sudo chmod 440 /etc/sudoers.d/g_wheel

##baixar o shell script do github
#sudo xbps-install -S -y git;
#git clone https://github.com/robsonnakane/Void-Linux.git;

## 1. Atualizar o sistema
sudo xbps-install -u xbps;
sudo xbps-install -Syu;
sudo xbps-install -S -y xtools seatd;
xcheckrestart;

## 2. Instalar o Plasma completo (meta-pacote)
sudo xbps-install -S -y kde-plasma noto-fonts-emoji;


## 3. Instalar o SDDM (display manager oficial do KDE)
sudo xbps-install -S -y sddm;

## 4. Instalar áudio com PipeWire (som completo)
### PipeWire + WirePlumber + ALSA + Pulse compat
sudo xbps-install -S -y pipewire wireplumber alsa-pipewire libjack-pipewire alsa-utils pavucontrol;

## 5. Drivers de vídeo (escolher para o notebook)
### Intel
#sudo xbps-install -S -y mesa-dri linux-firmware-intel;

### AMD nova (amdgpu)
#sudo xbps-install -S -y mesa-dri xf86-video-amdgpu;
### AMD antiga 
#sudo xbps-install -S -y mesa-dri xf86-video-ati;


### Nvidia (driver aberto) (escolher para o desktop)
sudo xbps-install -S -y mesa-nouveau-dri;

### Nvidia (proprietário)
#sudo xbps-install -S -y void-repo-nonfree;
#sudo xbps-install -S -y nvidia;

## 6. Forçar resolução segura no SDDM para monitores antigos (LG LX40 - 1280x1024 nativo)
sudo mkdir -p /etc/sddm/scripts
sudo tee /etc/sddm/scripts/Xsetup << EOF
#!/bin/sh
# Força resolução compatível com monitores antigos 5:4
xrandr --output $(xrandr | grep connected | cut -d' ' -f1) --mode 1280x1024 --rate 60
EOF

sudo chmod +x /etc/sddm/scripts/Xsetup

## 7. Ativar serviços obrigatórios (runit)
sudo ln -s /etc/sv/dbus /var/service/;
sudo ln -s /etc/sv/seatd /var/service/;
sudo ln -s /etc/sv/polkitd /var/service/;
sudo ln -s /etc/sv/NetworkManager /var/service/;
sudo ln -s /etc/sv/sddm /var/service/
