#!/bin/sh

file_check () {
    FILENAME=ordinateur_de_$USERNAME
    if [ -e "$FILENAME" ]; then
        echo "Vous avez déjà lancé ce programme une fois. Pour le relancer veuillez supprimer le fichier ordinateur_de_$USERNAME\nSi vous n'y parvenez pas, contactez votre administrateur système." && exit 
    fi
}
file_check

main () {
    NAME=$(whiptail --inputbox --nocancel "Merci d'entrer votre NOM : " 8 78 --title "Utilisateur" 3>&1  1>&2 2>&3)
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
    DATE=$(date '+%d/%m/%Y')
    ROOTACCESS=$(grep '^sudo:.*$' /etc/group | cut -d: -f4)
    HDWNAME=$(sudo dmidecode | grep -A3 '^System Information' | grep 'Product Name')

    echo  "L'utilisateur de l'ordinateur est : $NAME" >> Infos 
    echo  "------------------------------------------------" >> Infos
    echo  "Type d'ordinateur : " >> Infos
    echo  "Date d'achat : " >> Infos
    echo  "IP : \n$IP_ADDR" >> Infos
    echo  "MacAddress RJ45 : \n$MAC_ADDR" >> Infos
    echo  "MacAddress Wifi : " >> Infos
    echo  "VPN : " >> Infos
    echo  "Utilisateurs : \n$ALL_USERS" >> Infos 
    echo  "Accès au compte root : $ROOTACCESS" >> Infos
    echo  "Numéro d'inventaire GLPI : $ID_GLPI" >> Infos
    echo  "Version OS : Ubuntu $UBUNTU_VERSION" >> Infos 
    echo  "Version LibreOffice : $LIBRE_OFFICE" >> Infos 
    echo  "Version Thunderbird : $THUNDERBIRD" >> Infos 
    echo  "Version Firefox : $FIREFOX" >> Infos 
    echo  "Date des dernières mises à jour : $DATE" >> Infos
    echo  "------------------------------------------------" >> Infos
    echo  "------------------------------------------------" >> Infos
    echo "Le nom d'utilisateur est : $USERNAME" >> Infos
    echo "Nom d'hôte : $HOSTNAME" >> Infos
    cat Infos | sed -e 's/^[ \t]*//' > ordinateur_de_$NAME
    rm -r Infos

    whiptail --title "Terminé" --msgbox "Vous trouverez un fichier nommé ordinateur_de_NAME dans    votre dossier Dossier Personnel.\nIl suffit de l'envoyer par mail à Balàzs pour qu'il puisse encoder la  machine.\nSi vous ne le trouvez pas, n'hésitez pas à contacter Balàzs.\nMerci.\n" 12 78

    #If need to delete the file uncomment the folowing line:
    #rm -- "$0"

}
main
