# --------------------------------------------
# DÉPENDANCES
# --------------------------------------------

source env/wordpress.env

# --------------------------------------------
# MENU WORDPRESS
# --------------------------------------------

function wordpress_menu() {
    clear

    echo ' '
    echo -e "$green$wordpress_menu_ascii$end_color"
    echo ' '

    wordpress_install
}

# --------------------------------------------
# LANCEMENT DE L'INSTALLATION
# --------------------------------------------

function wordpress_install() {
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
        echo -e "$green$wordpress_menu_ascii$end_color"
        echo ' '
    fi

    echo '🌀 INSTALLATION DES PACKETS...'

    apt install php8.2 php8.2-cli php8.2-common php8.2-imap php8.2-redis php8.2-snmp php8.2-xml php8.2-mysqli php8.2-zip php8.2-mbstring php8.2-curl unzip openssl -y > /dev/null 2>&1

    echo '✅ PACKETS INSTALLÉS'

    echo '🌀 CONFIGURATION DE LA BASE DE DONNÉES...'

    mysql -u root -proot -Bse "CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';" > /dev/null 2>&1
    mysql -u root -proot -Bse "CREATE DATABASE $DB_NAME;" > /dev/null 2>&1
    mysql -u root -proot -Bse "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';" > /dev/null 2>&1
    mysql -u root -proot -Bse "FLUSH PRIVILEGES;" > /dev/null 2>&1

    echo '✅ BASE DE DONNÉES CONFIGURÉE'

    echo '🌀 TÉLÉCHARGEMENT DE WORDPRESS...'

    cd /var/www
    wget https://wordpress.org/latest.zip > /dev/null 2>&1
    unzip latest.zip > /dev/null 2>&1
    rm latest.zip

    echo '✅ TÉLÉCHARGEMENT TERMINÉ'

    echo '🌀 CONFIGURATION DE APACHE...'

    rm -drf /var/www/html
    a2dissite 000-default > /dev/null 2>&1
    rm /etc/apache2/sites-available/000-default.conf
    rm /etc/apache2/sites-available/default-ssl.conf
    
    echo 'ServerName 127.0.0.1' >> /etc/apache2/apache2.conf

    chown -R www-data:www-data wordpress
    cd wordpress
    find . -type d -exec chmod 755 {} \;
    find . -type f -exec chmod 644 {} \;
    mv wp-config-sample.php wp-config.php
    sed -i "s/define( 'DB_NAME', 'database_name_here' );/define( 'DB_NAME', '$DB_NAME' );/g" wp-config.php
    sed -i "s/define( 'DB_USER', 'username_here' );/define( 'DB_USER', '$DB_USER' );/g" wp-config.php
    sed -i "s/define( 'DB_PASSWORD', 'password_here' );/define( 'DB_PASSWORD', '$DB_PASS' );/g" wp-config.php

    echo "<VirtualHost *:$HTTP_PORT>
        ServerName $DOMAIN
        DocumentRoot /var/www/wordpress

        <Directory /var/www/wordpress>
            AllowOverride All
        </Directory>

        ErrorLog ${APACHE_LOG_DIR}/wordpress_error.log
        CustomLog ${APACHE_LOG_DIR}/wordpress_access.log combined
    </VirtualHost>" > /etc/apache2/sites-available/wordpress.conf
    sed -i 's/upload_max_filesize = 2M/upload_max_filesize 2048M/g' /etc/php/8.2/apache2/php.ini
    sed -i 's/post_max_size = 8M/post_max_size = 2048M/g' /etc/php/8.2/apache2/php.ini
    sed -i 's/memory_limit = 128M/memory_limit = 2048M/g' /etc/php/8.2/apache2/php.ini
    sed -i 's/max_execution_time = 30/max_execution_time = 300/g' /etc/php/8.2/apache2/php.ini
    sed -i 's/max_input_time = 60/max_input_time = 300/g' /etc/php/8.2/apache2/php.ini

    a2ensite wordpress.conf > /dev/null 2>&1
    a2enmod rewrite > /dev/null 2>&1
    systemctl restart apache2.service

    echo '✅ APACHE CONFIGURÉ'

    echo ' '
    read -n1 -s -r -p 'Appuyez sur une touche pour continuer...'
}