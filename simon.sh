#!/bin/bash

update_upgrade () {
echo "Lancement des mises à jours: "
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
            echo :::apt autoremove success
        else
            echo :::apt autoremove failure
        fi
echo "Fin des mises à jours"
echo "--------------------------------------------------------"
sleep 2
}

programms_install () {
whiptail --title "Installation des programmes" --msgbox "Installation des programmes nécessaire" 8 78
        sudo apt install vim -y
        sudo apt install tmux -y
        sudo apt install openssh-server -y
        sudo apt install curl wget -y
        
}


main () {
        update_upgrade || error "User exited."
        programms_install || error "User exited."
        end
        clear
}
main
