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
doas xbps-install -Suy; #rodar a primeira atualização sem a instalação dos pacotes#
doas xbps-install -Sycc;
xcheckrestart;

    ##Instalação de pacotes KDE oficial##
doas xbps-install -Sy kitty podman docker crun rsync flatpak xtools nano gnome-disk-utility;

    ##Pacotes Voidbr / Chililinux##
doas xbps-install -Sy voidbr-distrobox voidbr-lynxfetch chili-iso2usb chili-tradutor-go voidbr-vinstall;

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo;

##Após o reboot##
        ##Criação dos containeres no distrobox##
        ##Debian Testing##
#distrobox create -Y --name debian --image docker.io/library/debian:testing
        ##Archlinux##
#distrobox create -Y --name archlinux --image docker.io/library/archlinux:latest;
        ##Fedora##
#distrobox create -Y --name fedora --image quay.io/fedora/fedora:rawhide;

#distrobox-upgrade --all -v;

        ##Instalação dos pacotes nos containeres distrobox##
#distrobox enter archlinux -- sudo pacman -S --noconfirm fastfetch simple-scan thunderbird audacious gimp transmission-gtk rpi-imager firefox gwenview kate kdenlive yt-dlp xfburn kcalc spectacle;
#distrobox enter fedora -- sudo dnf5 install -y audacity inkscape gnome-boxes;

        ##Exportação dos pacotes instalados no distrobox archlinux##
#distrobox enter archlinux -- distrobox-export --app simple-scan; distrobox enter archlinux -- distrobox-export --app thunderbird; distrobox enter archlinux -- distrobox-export --app audacious; distrobox enter archlinux -- distrobox-export --app gimp; distrobox enter archlinux -- distrobox-export --app transmission-gtk; distrobox enter archlinux -- distrobox-export --app rpi-imager; distrobox enter archlinux -- distrobox-export --app firefox; distrobox enter archlinux -- distrobox-export --app gwenview; distrobox enter archlinux -- distrobox-export --app kate; distrobox enter archlinux -- distrobox-export --app kdenlive; distrobox enter archlinux -- distrobox-export --app xfburn; distrobox enter archlinux -- distrobox-export --app kcalc; distrobox enter archlinux -- distrobox-export --app spectacle;

        ##Exportação dos pacotes instalados no distrobox fedora##
#distrobox enter fedora -- distrobox-export --app audacity; distrobox enter fedora -- distrobox-export --app inkscape; distrobox enter fedora -- distrobox-export --app gnome-boxes;

        ##Instalação do lutris dentro do terminal distrobox debian##
#echo -e "Types: deb\nURIs: https://download.opensuse.org/repositories/home:/strycore/Debian_12/\nSuites: ./\nComponents: \nSigned-By: /etc/apt/keyrings/lutris.gpg" | sudo tee /etc/apt/sources.list.d/lutris.sources > /dev/null
#wget -q -O- https://download.opensuse.org/repositories/home:/strycore/Debian_12/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/lutris.gpg
#sudo apt update;
#apt install -y lutris
#distrobox-export --app lutris

        ##Instalação dos pacotes flatpaks##
#flatpak install flathub com.spotify.Client -y;flatpak install flathub us.zoom.Zoom -y; flatpak install flathub org.onlyoffice.desktopeditors -y; flatpak install flathub com.adobe.Flash-Player-Projector -y; flatpak install flathub com.github.IsmaelMartinez.teams_for_linux -y; flatpak install flathub org.chromium.Chromium -y; flatpak install flathub org.fedoraproject.MediaWriter -y; flatpak install flathub org.kde.kget -y; flatpak install flathub org.videolan.VLC -y; flatpak install flathub net.mkiol.SpeechNote -y; flatpak install flathub com.saivert.pwvucontrol -y; flatpak install flathub io.github.dvlv.boxbuddyrs -y; flatpak install flathub org.telegram.desktop -y; flatpak install flathub com.obsproject.Studio -y;

    ##Atualização do Flatpak##
#flatpak update -y;

doas reboot

    ##Baixar um vídeo em melhor qualidade:##
#distrobox enter archlinux -- yt-dlp URL
    ##Baixar só áudio (MP3):
#distrobox enter archlinux -- yt-dlp -x --audio-format mp3 URL

##Instalação de iso na vm chili
#chili-fr -s voidlinux.iso vda.qcow2
##Abrir a vm instalada
#chili-fr -s vda.qcow2

    ##Realização de backup##
#doas rsync -avzrp --delete /home/robsonnakane/'Robson Nakane'/ robsonnakane@192.168.15.15:/home/robsonnakane/lenovo/
    ##Recuperação de backup
#doas rsync -avzrp --delete robsonnakane@192.168.15.15:/home/robsonnakane/lenovo/ /home/robsonnakane/'Robson Nakane'/
