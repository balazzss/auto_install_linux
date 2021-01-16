#!/bin/sh                                                                                                                                                                                                          
                                                                                                                                                                                                                   
file_check () {                                                                                                                                                                                                                                                                                                  
    FILENAME=ordinateur_de_$USERNAME                                                                                                                                                                                   
    if [ -e "$FILENAME" ]; then                                                                                                                                                                                    
        echo "Vous avez déjà lancé ce programme une fois. Pour le relancer veuillez supprimer le fichier ordinateur_de_$USERNAME\n Si vous n'y parvenez pas, contactez votre administrateur système." && exit           
    fi                                                                                                                                                                                                             
}                                                                                                                                                                                                                  
file_check  
                                                                                                                                                                                                                   
main () {                                                                                                                                                                                                          
    NAME=$(whiptail --inputbox --nocancel "Merci d'entrer votre NOM : " 8 78 --title "Utilisateur" 3>&1 1>&2 2>&3)                                                                                                
    whiptail --title "Bienvenue" --msgbox "Bienvenue $NAME.\nVeuillez bien lire les instructions, Merci" 8 78                                                                                                      
    HOSTNAME=$(hostname)                                                                                                                                                                                           
    UBUNTU_VERSION=$(lsb_release -sr)                                                                                                                                                                              
    FIREFOX=$(firefox -v)                                                                                                                                                                                          
    THUNDERBIRD=$(thunderbird -v)                                                                                                                                                                                  
    LIBRE_OFFICE=$(libreoffice --version)                                                                                                                                                                          
    MAC_ADDR=$(ip link | awk '{print $2}')                                                                                                                                                                         
    IP_ADDR=$(ip a | grep "scope" | grep -Po '(?<=inet )[\d.]+')
    USERNAME=$(users)
    ALL_USERS=$(awk -F'[/:]' '{if ($3 >= 1000 && $3 != 65534) print $1}' /etc/passwd)
                                                                                                                                                                                                                   
    echo "L'utilisateur de l'ordinateur est : $NAME" >> Infos 
    echo "Le nom d'utilisateur est : $USERNAME" >> Infos
    echo "liste des utilisateurs : $ALL_USERS" >> Infos 
    echo "------------------------------------------------" >> Infos
    echo "Nom d'hôte : $HOSTNAME" >> Infos
    echo "------------------------------------------------" >> Infos
    echo "Numéro d'inventaire : $ID_GLPI" >> Infos
    echo "------------------------------------------------" >> Infos
    echo "La version d'Ubunutu est : Ubuntu $UBUNTU_VERSION" >> Infos 
    echo "------------------------------------------------" >> Infos
    echo "MAC address:\n $MAC_ADDR" >> Infos
    echo "------------------------------------------------" >> Infos
    echo "IP address:\n $IP_ADDR" >> Infos
    echo "------------------------------------------------" >> Infos
    echo "Version des logiciels" >> Infos
    echo "$FIREFOX" >> Infos                                                                                                                                                                                       
    echo "$THUNDERBIRD" >> Infos                                                                                                                                                                                   
    echo "$LIBRE_OFFICE" >> Infos                                                                                                                                                                                  
    cat Infos | sed -e 's/^[ \t]*//' > ordinateur_de_$USERNAME                                                                                                                                                         
    rm -r Infos                                                                                                                                                                                                    
                                                                                                                                                                                                                                                                                                                                                                                                    
                                                                                                                                                                                                                   
    whiptail --title "Terminé" --msgbox "Vous trouverez un fichier nommé ordinateur_de_$USERNAME dans votre dossier Dossier Personnel.\nIl suffit d'envoyer le fichier par mail à Balàzs. \n.\nMerci et à bientôt.\n" 12 78                                                                                                                                    
                                                                                                                                                                                                                   
    #If need to delete the file uncomment the folowing line:                                                                                                                                                       
    #rm -- "$0"                                                                                                                                                                                                    
                                                                                                                                                                                                                   
}                                                                                                                                                                                                                  
main
exit
