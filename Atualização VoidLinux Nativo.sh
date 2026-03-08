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
#doas xbps-install -Sy flatpak xtools rsync nano void-repo-nonfree void-repo-multilib-nonfree void-repo-multilib;
#flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo;
xcheckrestart;

    ##Instalação de pacotes XFCE oficial##
#doas xbps-install -Sy fastfetch simple-scan thunderbird audacious gimp transmission-gtk rpi-imager firefox gwenview kate kdenlive yt-dlp xfburn audacity inkscape lutris gnome-boxes xfce4-screenshooter kdeconnect xfce4-whiskermenu-plugin speedtest-cli ethtool;

    ##Pacotes Voidbr / Chililinux##
#doas xbps-install -Sy voidbr-distrobox podman docker crun voidbr-lynxfetch chili-iso2usb chili-tradutor-go vinstall;

##Instalação da Steam com vinstall##
#vinstall -Sy steam libgcc-32bit libstdc++-32bit libdrm-32bit libglvnd-32bit mono mesa-32bit vulkan-loader mesa-dri-32bit gstreamer1 winetricks vulkan-headers vulkan-tools lib32-vulkan-loader cpupower gamescope mesa-vulkan-intel mesa-vulkan-intel-32bit;

##Depois de instalar a Steam executar no terminal##

#sudo mkdir -p /etc/sv/cpu-performance
#sudo tee /etc/sv/cpu-performance/run > /dev/null << 'EOF'
##!/bin/sh
#exec 2>&1
#cpupower frequency-set -g performance
#EOF
#sudo chmod +x /etc/sv/cpu-performance/run
#sudo ln -s /etc/sv/cpu-performance /var/service/
#cpupower frequency-info

    ##Instalação dos pacotes flatpaks##
#flatpak install flathub com.spotify.Client -y; flatpak install flathub com.valvesoftware.Steam -y; flatpak install flathub us.zoom.Zoom -y; flatpak install flathub org.onlyoffice.desktopeditors -y; flatpak install flathub com.adobe.Flash-Player-Projector -y; flatpak install flathub com.github.IsmaelMartinez.teams_for_linux -y; flatpak install flathub org.chromium.Chromium -y; flatpak install flathub org.fedoraproject.MediaWriter -y; flatpak install flathub org.kde.kget -y; flatpak install flathub org.videolan.VLC -y; flatpak install flathub net.mkiol.SpeechNote -y; flatpak install flathub com.saivert.pwvucontrol -y;

    ##Atualização do Flatpak##
flatpak update -y;

vinstall -Scc;
doas reboot

    ##Baixar um vídeo em melhor qualidade:##
#distrobox enter archlinux -- yt-dlp URL
    ##Baixar só áudio (MP3):
#distrobox enter archlinux -- yt-dlp -x --audio-format mp3 URL

    ##Realização de backup##
#doas rsync -avzrp --delete /home/robsonnakane/'Robson Nakane'/ robsonnakane@192.168.15.15:/home/robsonnakane/lenovo/
    ##Recuperação de backup
#doas rsync -avzrp --delete robsonnakane@192.168.15.15:/home/robsonnakane/lenovo/ /home/robsonnakane/'Robson Nakane'/
