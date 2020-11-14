#!/bin/bash
#ajout d'une interface graphique
whiptail --title "Bienvenue" --msgbox "Bienvenue dans l'installation des outils pour votre machine, cliquez sur OK pour continuier" 8 78

#Vérifier la connexion à internet, si aucune alors quitte le programme
network () {
nc -z 8.8.8.8 53  >/dev/null 2>&1
online=$?
if [ $online -eq 0 ]; then
            whiptail --title "Connecté" --msgbox "Vous êtes bien connecté à internet!" 8 78
else
            whiptail --title "Pas connecté" --msgbox "Vérifier la connexion à internet." 8 78
            exit
fi
}
network 

whiptail --title "Mise à jour des paquets" --msgbox "Mises à jour des paquets." 8 78
update_upgrade () {
        sudo apt update
        sudo apt upgrade -y
        sudo apt dist-upgrade -y
        sudo apt autoremove -y
        sudo apt install rsync -y
}
update_upgrade
whiptail --title "Mise à jour des paquets" --msgbox "Mises à jour des paquets terminé avec succès" 8 78

read -rsp $'Install vim, tmux, openssh-server, press any key to continue\n' -n1 key
programms_install () {
        sudo apt install vim -y
        sudo apt install tmux -y
        sudo apt install openssh-server -y
        sudo apt install fail2ban -y
        sudo timedatectl set-timezone Europe/Brussels
}
programms_install

function_changeSSHport () {
SSHPORT=$(whiptail --inputbox "Adding user" 8 78  --title "Entrer le numéro du port" 3>&1 1>&2 2>&3)
echo $SSHPORT
sed -i "s/#Port 22/Port "$SSHPORT"/g" /etc/ssh/sshd_config

if (whiptail --title "Public Key" --yesno "Voulez-vous utiliser une clé publique pour vous authentifier avec SSH?" 8 78); then
        sed -i 's/#PubkeyAuthentication no/PubkeyAuthentication yes/g' /etc/ssh/sshd_config
else
        sed -i 's/#PubkeyAuthentication no/PubkeyAuthentication no/g' /etc/ssh/sshd_config
fi
        
}
function_changeSSHport

add_user () {
NAME=$(whiptail --inputbox "Adding user" 8 78 Name --title "Entrer le nom d'utilistaur" 3>&1 1>&2 2>&3)
exitstatus=$?
if [ $exitstatus = 0 ]; then
        adduser $NAME
else
    echo "User selected Cancel."
fi
echo "(Exit status was $exitstatus)"
}
adduser

######### tmux ############
cat << 'EOL' >> ~/.tmux.conf

set -g default-terminal "screen-256color"
set -g status-bg red
set -g status-fg black
set -g mouse on 

EOL
##########################
echo "Installation of log2ram"
sleep 2
curl -Lo log2ram.tar.gz https://github.com/azlux/log2ram/archive/master.tar.gz
tar xf log2ram.tar.gz

cd log2ram-master
chmod +x install.sh && sudo ./install.sh
cd ~
sudo rm -r log2ram*
