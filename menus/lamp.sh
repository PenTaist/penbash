# --------------------------------------------
# MENU LAMP
# --------------------------------------------

function lamp_menu() {
    clear

    echo ' '
    echo -e "$cyan$lamp_menu_ascii$end_color"
    echo ' '

    lamp_install
}

# --------------------------------------------
# LANCEMENT DE L'INSTALLATION
# --------------------------------------------

function lamp_install() {
    echo '🌀 INSTALLATION DES PACKETS...'

    apt install apache2 libapache2-mod-php8.2 mariadb-server php-xml php-common php-json php-mysql php-mbstring php-curl php-gd php-intl php-zip php-bz2 php-imap php-apcu php8.2-fpm -y > /dev/null 2>&1

    echo '✅ PACKETS INSTALLÉS'

    echo '🌀 CONFIGURATION DE LA BASE DE DONNÉES...'

    apt install expect -y > /dev/null 2>&1

    expect -c "
        set timeout 10
        spawn mysql_secure_installation
        expect \"Enter current password for root (enter for none):\"
        send \"$MYSQL\r\"
        expect \"Change the root password?\"
        send \"n\r\"
        expect \"Remove anonymous users?\"
        send \"y\r\"
        expect \"Disallow root login remotely?\"
        send \"y\r\"
        expect \"Remove test database and access to it?\"
        send \"y\r\"
        expect \"Reload privilege tables now?\"
        send \"y\r\"
        expect eof
    " > /dev/null 2>&1

    echo '✅ BASE DE DONNÉES CONFIGURÉE'

    echo ' '
    read -n1 -s -r -p 'Appuyez sur une touche pour continuer...'
}