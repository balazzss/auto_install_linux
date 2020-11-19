NAME=$(whiptail --inputbox "Suppression d'un utilisateur" 8 78 Name --title "Entrer le nom d'un utilistaur à supprimer définitivement" 3>&1 1>&2 2>&3)
sudo usermod --expiredate 1 $NAME
#sudo usermod --expiredate "" $NAME
sudo tar -zcvf $HOME/$NAME.backup.tar.gz /home/$NAME
sudo killall -KILL -u $NAME
sudo crontab -r -u $NAME
#sudo lprm $NAME
sudo userdel -r $NAME
