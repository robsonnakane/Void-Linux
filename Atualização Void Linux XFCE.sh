#!/bin/bash

            ###Void Linux by distrobox###
            ###Atualização completa do sistema###

##Comandos no Super User##
#sudo xbps-install -u xbps;
sudo xbps-install -Su;
#sudo xbps-install -S -y xtools;
#flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo;
xcheckrestart;

#sudo xbps-install -S -y fastfetch simple-scan thunderbird audacious gimp transmission-gtk rpi-imager firefox gwenview kate kdenlive yt-dlp xfburn audacity inkscape lutris;

        ##Instalação dos pacotes flatpaks##
#sudo flatpak install flathub com.spotify.Client -y; sudo flatpak install flathub com.valvesoftware.Steam -y; sudo flatpak install flathub us.zoom.Zoom -y; sudo flatpak install flathub org.onlyoffice.desktopeditors -y; sudo flatpak install flathub com.adobe.Flash-Player-Projector -y; sudo flatpak install flathub com.github.IsmaelMartinez.teams_for_linux -y; sudo flatpak install flathub org.chromium.Chromium -y; sudo flatpak install flathub org.fedoraproject.MediaWriter -y; sudo flatpak install flathub org.kde.kget -y; sudo flatpak install flathub org.videolan.VLC -y; sudo flatpak install flathub net.mkiol.SpeechNote -y; sudo flatpak install flathub com.saivert.pwvucontrol -y; sudo flatpak install flathub io.github.dvlv.boxbuddyrs -y;

        ##Atualização do Flatpak##
flatpak update -y;

sudo reboot

        ##Realização de backup
#sudo rsync -avzrp --delete /home/robsonnakane/'Robson Nakane'/ robsonnakane@192.168.15.15:/home/robsonnakane/lenovo/
        ##Recuperação de backup
#sudo rsync -avzrp --delete robsonnakane@192.168.15.15:/home/robsonnakane/lenovo/ /home/robsonnakane/'Robson Nakane'/
