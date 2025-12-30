#!/bin/bash

            ###Void Linux by distrobox###
            ###Atualização completa do sistema###

##Comandos no Super User##
#sudo xbps-installer -u xbps;
sudo xbps-installer -Su;
#sudo xbps-install -S -y void-repo-nonfree void-repo-multilib void-repo-multilib-nonfree;
#sudo xbps-installer -S -y flatpak curl xtools;
#curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sudo sh;
#flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo;
xcheckrestart;

        ##Instalação de pacotes##
#sudo xbps-installer -S -y fastfetch simple-scan thunderbird audacious gimp transmission-gtk rpi-imager firefox gwenview kate kdenlive yt-dlp xfburn audacity inkscape lutris kitty rsync;

        ##Instalação dos pacotes flatpaks##
#sudo flatpak install flathub com.spotify.Client -y; sudo flatpak install flathub com.valvesoftware.Steam -y; sudo flatpak install flathub us.zoom.Zoom -y; sudo flatpak install flathub org.onlyoffice.desktopeditors -y; sudo flatpak install flathub com.adobe.Flash-Player-Projector -y; sudo flatpak install flathub com.github.IsmaelMartinez.teams_for_linux -y; sudo flatpak install flathub org.chromium.Chromium -y; sudo flatpak install flathub org.fedoraproject.MediaWriter -y; sudo flatpak install flathub org.kde.kget -y; sudo flatpak install flathub org.videolan.VLC -y; sudo flatpak install flathub net.mkiol.SpeechNote -y; sudo flatpak install flathub com.saivert.pwvucontrol -y;

        ##Bluetooth##
#rfkill unblock bluetooth; sudo xbps-installer -S -y bluez bluez-alsa libspa-bluetooth; sudo sv restart bluetoothd; sudo sv restart dbus; sudo sv restart sshd;


        ##Atualização do Flatpak##
flatpak update -y;

systemctl reboot

        ##Baixar um vídeo em melhor qualidade:##
#distrobox enter archlinux -- yt-dlp URL
        ##Baixar só áudio (MP3):
#distrobox enter archlinux -- yt-dlp -x --audio-format mp3 URL

        ##Realização de backup##
#sudo rsync -avzrp --delete /home/robsonnakane/'Robson Nakane'/ robsonnakane@192.168.15.15:/home/robsonnakane/lenovo/
        ##Recuperação de backup
#sudo rsync -avzrp --delete robsonnakane@192.168.15.15:/home/robsonnakane/lenovo/ /home/robsonnakane/'Robson Nakane'/
