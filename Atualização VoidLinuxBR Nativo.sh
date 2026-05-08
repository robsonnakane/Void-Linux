#!/bin/bash

      ###Void Linux by distrobox###
      ###Atualização completa do sistema###

##Configuração do 'doas' como su (copiar e colar no terminal antes da instalação, passo a passo)
#xbps-install -uy xbps
#xbps-install -Suy
#xbps-install -Sy opendoas
#usermod -aG wheel robsonnakane
#echo "permit persist :wheel" > /etc/doas.conf
#chown root:root /etc/doas.conf
#chmod 400 /etc/doas.conf
#log out

##Atualização do Void Linux##
doas xbps-pkgdb -a;
doas xbps-install -Sy;
doas xbps-install -Suy;
doas rkhunter --propupd --update;
doas rkhunter --check  --skip-keypress --report-warnings-only;
doas cat /var/log/rkhunter.log | grep -E "Warning";
xcheckrestart;


##Consulta do log rkhunter##
#doas cat /var/log/rkhunter.log | grep -E "Warning|None found"

#doas xbps-install -Sy flatpak xtools rsync nano void-repo-nonfree void-repo-multilib-nonfree void-repo-multilib fastfetch simple-scan thunderbird audacious gimp transmission-gtk rpi-imager firefox gwenview kate kdenlive yt-dlp xfburn audacity inkscape lutris gnome-boxes xfce4-screenshooter kdeconnect xfce4-whiskermenu-plugin speedtest-cli ethtool tailscale rkhunter ufw;

##Ativar o ufw firewall##
#doas ufw status;
#doas ufw enable;
#doas ufw allow ssh;

##Ativação do tailscale##
#doas ln -s /etc/sv/tailscaled /var/service/
#doas tailscale up --ssh --accept-dns --force-reauth;

    ##Pacotes Voidbr / Chililinux##
#doas xbps-install -Sy voidbr-distrobox podman docker crun voidbr-lynxfetch chili-iso2usb chili-tradutor-go voidbr-vinstall;

#flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo;

##Instalação da Steam com vinstall##
#vinstall -Sy steam libgcc-32bit libstdc++-32bit libdrm-32bit libglvnd-32bit mono mesa-32bit vulkan-loader mesa-dri-32bit gstreamer1 winetricks vulkan-headers vulkan-tools lib32-vulkan-loader cpupower gamescope mesa-vulkan-intel mesa-vulkan-intel-32bit;

##Depois de instalar a Steam executar no terminal##

#doas mkdir -p /etc/sv/cpu-performance
#doas tee /etc/sv/cpu-performance/run > /dev/null << 'EOF'
##!/bin/sh
#exec 2>&1
#cpupower frequency-set -g performance
#EOF
#doas chmod +x /etc/sv/cpu-performance/run
#doas ln -s /etc/sv/cpu-performance /var/service/
#cpupower frequency-info

    ##Instalação dos pacotes flatpaks##
#flatpak install flathub com.spotify.Client -y; flatpak install flathub com.valvesoftware.Steam -y; flatpak install flathub us.zoom.Zoom -y; flatpak install flathub org.onlyoffice.desktopeditors -y; flatpak install flathub com.adobe.Flash-Player-Projector -y; flatpak install flathub com.github.IsmaelMartinez.teams_for_linux -y; flatpak install flathub org.chromium.Chromium -y; flatpak install flathub org.fedoraproject.MediaWriter -y; flatpak install flathub org.kde.kget -y; flatpak install flathub org.videolan.VLC -y; flatpak install flathub net.mkiol.SpeechNote -y; flatpak install flathub com.saivert.pwvucontrol -y flatpak install flathub org.jousse.vincent.Pomodorolm -y; flatpak install flathub com.rustdesk.RustDesk -y; flatpak install flathub it.andreafontana.hideout -y;

###Rustdesk com tailscale###
##Na opção Segurança nas Configurações do RustDesk
#Permissões: Acesso completo
#Senha: Utilizar senha permanente / configurar senha permanente
#Segurança: habilitar a opção "Habilitar Acesso IP Direto"

    ##Atualização do Flatpak##
flatpak update -y;

vinstall -Sycc;
doas poweroff

    ##Baixar um vídeo em melhor qualidade:##
#distrobox enter archlinux -- yt-dlp URL
    ##Baixar só áudio (MP3):
#distrobox enter archlinux -- yt-dlp -x --audio-format mp3 URL

##Backup/Acesso via Rsync + Tailscale##
##voidlinuxserver
#doas rsync -avzrp --delete /home/robsonnakane/'Robson Nakane'/ robsonnakane@100.73.4.37:/home/robsonnakane/lenovo/
##Acesso voidlinuxserver
#ssh robsonnakane@100.73.4.37

##capengapc
#doas rsync -avzrp --delete /home/robsonnakane/'Robson Nakane'/ robsonnakane@100.125.34.59:/home/robsonnakane/'Robson Nakane'/
## Acesso capengapc
#ssh robsonnakane@100.125.34.59
