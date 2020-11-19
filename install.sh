#!/bin/bash
#ajout d'une interface graphique
whiptail --title "Bienvenue" --msgbox "Bienvenue dans l'installation des outils pour votre machine, cliquez sur OK pour continuier" 8 78

rootpass () {
root_pass=$(whiptail --nocancel --passwordbox "Pour continuer veuillez entrer le mot de passe administrateur:" 10 60 3>&1 1>&2 2>&3 3>&1)
if [ -z "root_pass" ]; then
        whiptail --title "Pas de mot de passe" --msgbox "Aucun mot de passe root. Veuillez relancer le programme puis entrer le mot de passe root" 8 78
        clear && exit
fi
}

#Vérifier la connexion à internet, si aucune alors quitte le programme
network () {
whiptail --title "Internet" --msgbox "Virification si nous avons bien accès à internet" 8 78
nc -z 8.8.8.8 53  >/dev/null 2>&1
online=$?
if [ $online -eq 0 ]; then
        whiptail --title "Connecté" --msgbox "Vous êtes bien connecté à internet!" 8 78
else
        whiptail --title "Non connecté" --msgbox "Vérifier la connexion à internet pour pouvoir continuer." 8 78
        clear
fi
}

update_upgrade () {
whiptail --title "Mise à jour des paquets" --msgbox "Mises à jour des paquets." 8 78
        clear
        if ! { sudo apt update 2>&1 || echo E: update failed; } | grep -q '^[WE]:'; then
            echo :::apt update success
        else
            echo :::apt update failure
        fi
        if ! { sudo apt upgrade -y 2>&1 || echo E: update failed; } | grep -q '^[WE]:'; then
            echo :::apt upgrade success
        else
            echo :::apt upgrade failure
        fi
        if ! { sudo apt dist-upgrade -y 2>&1 || echo E: update failed; } | grep -q '^[WE]:'; then
            echo :::apt dist-upgrade success
        else
            echo :::apt dist-upgrade failure
        fi
        if ! { sudo apt autoremove -y 2>&1 || echo E: update failed; } | grep -q '^[WE]:'; then
            echo apt autoremove success
        else
            echo apt autoremove failure
        fi
whiptail --title "Mise à jour des paquets" --msgbox "Mises à jour des paquets terminé" 8 78  
}

programms_install () {
whiptail --title "Installation des programmes" --msgbox "Installation des programmes nécessaire" 8 78
        sudo apt install vim -y
        sudo apt install tmux -y
        sudo apt install openssh-server -y
        sudo apt install fail2ban -y
        sudo apt install rsync -y
        sudo apt install curl wget git -y
        sudo timedatectl set-timezone Europe/Brussels
}
#nouvelle fonction à vérifier
#set_keyboard () {
#keyboard=$(whiptail --inputbox "Set your keyboard" 8 78  --title "Enter the language of your keyboard" 3>&1 1>&2 2>&3)
#        sudo sed -i 's/XKBLAYOUT="gb"/XKBLAYOUT=be/g' /etc/default/keyboard
#}

function_changeSSHport () {
SSHPORT=$(whiptail --inputbox "Change SSH port" 8 78  --title "Entrer le numéro du port que vous souhaitez utiliser pour vous connecter en SSH." 3>&1 1>&2 2>&3)
echo $SSHPORT
sudo sed -i "s/#Port 22/Port "$SSHPORT"/g" /etc/ssh/sshd_config

if (whiptail --title "Public Key" --yesno "Voulez-vous utiliser une clé publique pour vous authentifier avec SSH?" 8 78); then
        sudo sed -i 's/#PubkeyAuthentication no/PubkeyAuthentication yes/g' /etc/ssh/sshd_config
else
        sudo sed -i 's/#PubkeyAuthentication no/PubkeyAuthentication no/g' /etc/ssh/sshd_config
fi
        
}

add_user () {
NEW_NAME=$(whiptail --inputbox "Adding user" 8 78 Name --title "Entrer le nom d'utilistaur" 3>&1 1>&2 2>&3)
exitstatus=$?
if [ $exitstatus = 0 ]; then
         #NEW_MDP=$(whiptail --passwordbox "please enter your secret password" 8 78 --title "password dialog" 3>&1 1>&2 2>&3)
         PASS1=$(whiptail --nocancel --passwordbox "Enter a password for that user." 8 78 3>&1 1>&2 2>&3 3>&1)
         PASS2=$(whiptail --nocancel --passwordbox "Retype password." 8 78 3>&1 1>&2 2>&3 3>&1)
         while ! [ "$pass1" = "$pass2" ]; do
             unset pass2
             PASS1=$(whiptail --nocancel --passwordbox "Passwords do not match.\\n\\nEnter password again." 10 60 3>&1 1>&2 2>&3 3>&1)
             PASS2=$(whiptail --nocancel --passwordbox "Retype password." 10 60 3>&1 1>&2 2>&3 3>&1)
         done
         exitstatus=$?
         if [ $exitstatus = 0 ]; then
                 echo "$root_pass" | sudo -S adduser $NEW_NAME --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
                 echo "$root_pass" | sudo -S echo "$NEW_NAME:$PASS1" | sudo chpasswd
         else
                 echo "User selected Cancel."
         fi
fi
}

#user_sudoers () {
#        if [ -z "$NEW_NAME" ]; then
#                echo "::: Pas de nouvel utilisateur"
#        else
#                sudo sed -i 's/XKBLAYOUT="gb"/XKBLAYOUT=be/g' /etc/default/keyboard
#        fi
#}

install_log2ram () {
whiptail --title "Log2ram" --msgbox "Téléchargement et installation de log2ram" 8 78
sudo curl -Lo log2ram.tar.gz https://github.com/azlux/log2ram/archive/master.tar.gz
sudo tar xf log2ram.tar.gz
#cd log2ram-master
sudo chmod +x /home/$USER/log2ram-master/install.sh && sudo sh /home/$USER/log2ram-master/install.sh
#cd ~
sudo rm -r log2ram*
}

#lacer ces commandes sans sudo... car la commande se lance dans le dossier root.
config_tmux () {
whiptail --title "TMUX" --msgbox "Configuration de Tmux" 8 78
cat << 'EOF' >> ~/.tmux.conf
set -g default-terminal "screen-256color"
set -g history-limit 10000
set -g status-bg red
set -g status-fg black
set -g mouse on 
EOF
}

end () {
whiptail --title "Configuration completed" --msgbox "La configuration de votre machine est terminé." 8 78
}
main () {
        rootpass || error "User exited."
        network || error "User exited."
        update_upgrade || error "User exited."
        programms_install || error "User exited."
        function_changeSSHport || error "User exited."
        add_user || error "User exited."
        #user_sudoers || error "User exited."
        config_tmux || error "User exited."
        install_log2ram || error "User exited."
        end
        clear
}
main
