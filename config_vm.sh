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
            echo apt autoremove success
        else
            echo apt autoremove failure
        fi
echo "Fin des mises à jours"
echo "--------------------------------------------------------"
sleep 5
}

programms_install () {
whiptail --title "Installation des programmes" --msgbox "Installation des programmes nécessaire" 8 78
        sudo apt install vim -y
        sudo apt install tmux -y
        sudo apt install openssh-server -y
        sudo apt install rsync -y
        sudo apt install curl wget git -y
        sudo timedatectl set-timezone Europe/Brussels
        
}

function_changeSSHport () {
sudo sed -i "s/#Port 22/Port 19993/g" /etc/ssh/sshd_config
sudo sed -i 's/#PubkeyAuthentication no/PubkeyAuthentication yes/g' /etc/ssh/sshd_config
sudo sed -i 's/#PermitEmptyPasswords no/PermitEmptyPasswords no/g' /etc/ssh/sshd_config
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/g' /etc/ssh/sshd_config
sudo systemctl restart ssh
}

config_tmux () {
cat << 'EOF' >> ~/.tmux.conf
set -g default-terminal "screen-256color"
set -g history-limit 10000
set -g status-bg red
set -g status-fg black
set -g mouse on 
EOF
}

node_exporter () {
curl -L https://raw.githubusercontent.com/balazzss/auto_install_linux/main/node_exporter.sh | sudo bash
sleep 5
}

main () {
        update_upgrade || error "User exited."
        programms_install || error "User exited."
        function_changeSSHport || error "User exited."
        config_tmux || error "User exited."
        node_exporter || error "User exited."
        end
        clear
}
main


#!/bin/bash

compare=`diff sha256sum_drive.txt sha256sum_disk1.txt`
#cp -r /home/balazsverduyn/googledrive /home/balazsverduyn/disk1
rsync -avz /home/balazsverduyn/googledrive/ /home/balazsverduyn/disk1
find /home/balazsverduyn/googledrive -type f -exec sha256sum {} \; > /home/balazsverduyn/sha256sum_drive.txt
find /home/balazsverduyn/disk1 -type f -exec sha256sum {} \; > /home/balazsverduyn/sha256sum_disk1.txt

sha256sum -c sha256sum_drive.txt
sha256sum -c sha256sum_disk1.txt

#remove directory to diff the files
sed 's/\s.*$//' sha256sum_disk1.txt > sha256sum_disk1_withoutspace.txt
mv sha256sum_disk1_withoutspace.txt sha256sum_disk1.txt
sed 's/\s.*$//' sha256sum_drive.txt > sha256sum_drive_withoutspace.txt
mv sha256sum_drive_withoutspace.txt sha256sum_drive.txt


if [[ $compare -eq 0 ]]
then
        echo "Checksum OK. Backup done!"
        rm /home/balazsverduyn/sha256sum_drive.txt
        rm /home/balazsverduyn/sha256sum_disk1.txt
else
#       echo $variable | mail -s switch_HARDWARE_CHECK  recipeint_email_address    
        echo "shasum is not correct! Please check the backup."  
fi

