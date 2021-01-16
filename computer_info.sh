#!/bin/sh                                                                                                                                                                                                          
                                                                                                                                                                                                                   
file_check () {                                                                                                                                                                                                    
    NAME=$(whiptail --inputbox --nocancel "Merci d'entrer votre NOM : " 8 78 --title "Utilisateur" 3>&1 1>&2 2>&3)                                                                                                 
    FILENAME=ordinateur_de_$NAME                                                                                                                                                                                   
    if [ -e "$FILENAME" ]; then                                                                                                                                                                                    
        echo "Vous avez déjà lancé ce programme une fois. Pour le relancer veuillez supprimer le fichier ordinateur_de_$NAME\nSi vous n'y parvenez pas, contactez votre administrateur système." && exit           
    fi                                                                                                                                                                                                             
}                                                                                                                                                                                                                  
file_check                                                                                                                                                                                                         
                                                                                                                                                                                                                   
main () {                                                                                                                                                                                                          
    #NAME=$(whiptail --inputbox --nocancel "Merci d'entrer votre NOM : " 8 78 --title "Utilisateur" 3>&1 1>&2 2>&3)                                                                                                
    whiptail --title "Bienvenue" --msgbox "Bienvenue $NAME.\nVeuillez bien lire les instructions, Merci" 8 78                                                                                                      
    HOSTNAME=$(hostname)                                                                                                                                                                                           
    UBUNTU_VERSION=$(lsb_release -sr)                                                                                                                                                                              
    FIREFOX=$(firefox -v)                                                                                                                                                                                          
    THUNDERBIRD=$(thunderbird -v)                                                                                                                                                                                  
    LIBRE_OFFICE=$(libreoffice --version)                                                                                                                                                                          
    MAC_ADDR=$(ip link | awk '{print $2}')                                                                                                                                                                         
    IP_ADDR=$(ip a | grep "scope" | grep -Po '(?<=inet )[\d.]+')
    USERNAME=$(users)
                                                                                                                                                                                                                   
    echo "L'utilisateur de l'ordinateur est : $NAME" >> Infos 
    echo "Le nom d'utilisateur est : $USERNAME" >> Infos
    echo "Nom d'hôte : $HOSTNAME" >> Infos
    echo "Numéro d'inventaire : $ID_GLPI" >> Infos
    echo "La version d'Ubunutu est : Ubuntu $UBUNTU_VERSION" >> Infos                                                                                                                                              
    echo "MAC address:\n$MAC_ADDR" >> Infos                                                                                                                                                                        
    echo "IP address:\n$IP_ADDR" >> Infos                                                                                                                                                                          
    echo "$FIREFOX" >> Infos                                                                                                                                                                                       
    echo "$THUNDERBIRD" >> Infos                                                                                                                                                                                   
    echo "$LIBRE_OFFICE" >> Infos                                                                                                                                                                                  
    cat Infos | sed -e 's/^[ \t]*//' > ordinateur_de_$NAME                                                                                                                                                         
    rm -r Infos                                                                                                                                                                                                    
                                                                                                                                                                                                                   
    #ip addr show >> Info_IMEP                                                                                                                                                                                     
                                                                                                                                                                                                                   
    whiptail --title "Terminé" --msgbox "Vous trouverez un fichier nommé ordinateur_de_$NAME dans votre dossier Dossier Personnel.\nIl suffit d'envoyer le fichier par mail à Balàzs. \n.\nMerci et à bientôt.\n" 12 78                                                                                                                                    
                                                                                                                                                                                                                   
    #If need to delete the file uncomment the folowing line:                                                                                                                                                       
    rm -- "$0"                                                                                                                                                                                                    
                                                                                                                                                                                                                   
}                                                                                                                                                                                                                  
main
exit
