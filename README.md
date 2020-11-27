# auto_install_linux
Le programme va: 
    
    - Demander le mot de passe root
    - Checker si il y a une connexion à internet
    - Faire les mises à jours des sources apt
    - Faire les mises à jours des paquets
    - changer le port ssh et pouvoir se connecter avec un certificat
    - 
------------------------------
### Lancer la configuration: 
    wget https://raw.githubusercontent.com/balazzss/auto_install_linux/main/install.sh
    sudo chmod +x $HOME/install.sh && sh $HOME/install.sh
    
    curl -L https://raw.githubusercontent.com/balazzss/auto_install_linux/main/install.sh | bash
!!! Lancer le programme avec le compte utilisateur !!!

### Custom deluser with backup file of the user file
    curl -L https://raw.githubusercontent.com/balazzss/auto_install_linux/main/deluser.sh | bash
    
### MOTD custom
    curl -L https://raw.githubusercontent.com/balazzss/auto_install_linux/main/motd.sh | sudo bash
    
### A ajouter
- user -> suoders
