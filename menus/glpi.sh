# --------------------------------------------
# DÉPENDANCES
# --------------------------------------------

source env/glpi.env

# --------------------------------------------
# MENU GLPI
# --------------------------------------------

function glpi_menu() {
    clear

    echo ' '
    echo -e "$red$glpi_menu_ascii$end_color"
    echo ' '

    glpi_install
}

# --------------------------------------------
# LANCEMENT DE L'INSTALLATION
# --------------------------------------------

function glpi_install() {
    if dpkg -s jq &> /dev/null; then
        echo '✅ PACKETS DE BASE INSTALLÉS'
    else
        source menus/base.sh
        install_base_packages
    fi

    if dpkg -s apache2 &> /dev/null; then
        echo '✅ PILE LAMP INSTALLÉE'
    else
        source menus/lamp.sh
        lamp_menu
        clear
        echo ' '
        echo -e "$red$glpi_menu_ascii$end_color"
        echo ' '
    fi

    echo '🌀 INSTALLATION DES PACKETS...'
    
    apt install php-xml php-common php-json php-mysql php-mbstring php-curl php-gd php-intl php-zip php-bz2 php-imap php-apcu php8.2-fpm -y > /dev/null 2>&1

    echo '✅ PACKETS INSTALLÉS'

    echo '🌀 CONFIGURATION DE LA BASE DE DONNÉES...'

    mysql -u root -proot -Bse "CREATE DATABASE $DB_NAME;" > /dev/null 2>&1
    mysql -u root -proot -Bse "CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';" > /dev/null 2>&1
    mysql -u root -proot -Bse "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';" > /dev/null 2>&1
    mysql -u root -proot -Bse "FLUSH PRIVILEGES;" > /dev/null 2>&1

    echo '✅ BASE DE DONNÉES CONFIGURÉE'

    echo "🌀 TÉLÉCHARGEMENT DE GLPI v$VERSION..."

    cd /var/www
    wget https://github.com/glpi-project/glpi/releases/download/$VERSION/glpi-$VERSION.tgz > /dev/null 2>&1
    tar xf glpi-$VERSION.tgz > /dev/null 2>&1
    rm glpi-$VERSION.tgz

    echo '✅ TÉlÉCHARGEMENT TERMINÉ'

    echo '🌀 CONFIGURATION DE APACHE...'

    rm -drf /var/www/html
    a2dissite 000-default > /dev/null 2>&1
    rm /etc/apache2/sites-available/000-default.conf
    rm /etc/apache2/sites-available/default-ssl.conf

    mkdir /etc/glpi
    mv /var/www/glpi/config /etc/glpi
    mkdir /var/lib/glpi
    mv /var/www/glpi/files /var/lib/glpi
    mkdir /var/log/glpi

    echo "<?php
    define('GLPI_CONFIG_DIR', '/etc/glpi/');
    if (file_exists(GLPI_CONFIG_DIR . '/local_define.php')) {
        require_once GLPI_CONFIG_DIR . '/local_define.php';
    }" > /var/www/glpi/inc/downstream.php
    echo "<?php
    define('GLPI_VAR_DIR', '/var/lib/glpi/files');
    define('GLPI_LOG_DIR', '/var/log/glpi');" > /etc/glpi/local_define.php

    chown -R www-data:www-data /var/www
    chown -R www-data:www-data /etc/glpi
    chown -R www-data:www-data /var/lib/glpi
    chown -R www-data:www-data /var/log/glpi

    echo "<VirtualHost *:$HTTP_PORT>
        ServerName $DOMAIN
        DocumentRoot /var/www/glpi

        <Directory /var/www/glpi>
            Require all granted

            RewriteEngine On

            RewriteCond %{REQUEST_FILENAME} !-f
            RewriteRule ^(.*)$ index.php [QSA,L]
        </Directory>

    #    <FilesMatch \.php$>
    #        SetHandler \"proxy:unix:/run/php/php8.2-fpm.sock|fcgi://localhost/\"
    #    </FilesMatch>
    </VirtualHost>" > /etc/apache2/sites-available/glpi.conf

    a2ensite glpi > /dev/null 2>&1
    a2enmod rewrite > /dev/null 2>&1
    sed -i 's/session.cookie_httponly =/session.cookie_httponly = on/g' /etc/php/8.2/fpm/php.ini
    sed -i 's/session.cookie_httponly =/session.cookie_httponly = on/g' /etc/php/8.2/apache2/php.ini
    systemctl restart php8.2-fpm.service
    systemctl restart apache2.service

    echo '✅ APACHE CONFIGURÉ'

    echo "🌀 MONTAGE DE LA BASE DE DONNÉES DANS GLPI..."

    cd /var/www/glpi
    php bin/console db:install --db-name=$DB_NAME --db-user=$DB_USER --db-password=$DB_PASS --no-interaction > /dev/null 2>&1
    sudo rm -rf /var/www/glpi/install
    chown -R www-data:www-data /var/log/glpi

    echo '✅ MONTAGE TERMINÉ'

    echo ' '
    read -n1 -s -r -p 'Appuyez sur une touche pour continuer...'
}