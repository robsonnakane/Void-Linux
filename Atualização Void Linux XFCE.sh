#!/bin/bash

      ###Void Linux by distrobox###
      ###Atualização completa do sistema###

##Configuração do 'doas' como su (copiar e colar no terminal antes da instalação, passo a passo)
#xbps-install -u -y xbps
#xbps-install -Su -y
#xbps-install -S -y opendoas
#usermod -aG wheel robsonnakane
#echo "permit persist :wheel" > /etc/doas.conf
#chown root:root /etc/doas.conf
#chmod 400 /etc/doas.conf
#log out

##Atualização do Void Linux##
doas xbps-install -Su -y; #rodar a primeira atualização sem a instalação dos pacotes#
#doas xbps-install -S -y flatpak xtools rsync nano;
#flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo;
xcheckrestart;

    ##Instalação de pacotes##
#doas xbps-install -S -y fastfetch simple-scan thunderbird audacious gimp transmission-gtk rpi-imager firefox gwenview kate kdenlive yt-dlp xfburn audacity inkscape lutris kitty bluez bluez-alsa blueman bluez-deprecated wireplumber libspa-bluetooth xfce4-whiskermenu-plugin;

## Bluetooth
#doas sv up bluetoothd dbus; doas usermod -aG bluetooth robsonnakane; doas ln -s /etc/sv/bluetoothd /var/service/;

    ##Instalação dos pacotes flatpaks##
#flatpak install flathub com.spotify.Client -y; flatpak install flathub com.valvesoftware.Steam -y; flatpak install flathub us.zoom.Zoom -y; flatpak install flathub org.onlyoffice.desktopeditors -y; flatpak install flathub com.adobe.Flash-Player-Projector -y; flatpak install flathub com.github.IsmaelMartinez.teams_for_linux -y; flatpak install flathub org.chromium.Chromium -y; flatpak install flathub org.fedoraproject.MediaWriter -y; flatpak install flathub org.kde.kget -y; flatpak install flathub org.videolan.VLC -y; flatpak install flathub net.mkiol.SpeechNote -y; flatpak install flathub com.saivert.pwvucontrol -y;

    ##Atualização do Flatpak##
doas flatpak update -y;

doas reboot

    ##Baixar um vídeo em melhor qualidade:##
#distrobox enter archlinux -- yt-dlp URL
    ##Baixar só áudio (MP3):
#distrobox enter archlinux -- yt-dlp -x --audio-format mp3 URL

    ##Realização de backup##
#doas rsync -avzrp --delete /home/robsonnakane/'Robson Nakane'/ robsonnakane@192.168.15.15:/home/robsonnakane/lenovo/
    ##Recuperação de backup
#doas rsync -avzrp --delete robsonnakane@192.168.15.15:/home/robsonnakane/lenovo/ /home/robsonnakane/'Robson Nakane'/
