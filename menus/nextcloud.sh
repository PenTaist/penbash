# --------------------------------------------
# DÉPENDANCES
# --------------------------------------------

source env/nextcloud.env

# --------------------------------------------
# MENU NEXTCLOUD
# --------------------------------------------

function nextcloud_menu() {
    clear

    echo ' '
    echo -e "$blue$nextcloud_menu_ascii$end_color"
    echo ' '

    nextcloud_install
}

# --------------------------------------------
# LANCEMENT DE L'INSTALLATION
# --------------------------------------------

function nextcloud_install() {
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
        echo -e "$blue$nextcloud_menu_ascii$end_color"
        echo ' '
    fi
    echo '🌀 INSTALLATION DES PACKETS...'

    apt install php8.2 php8.2-curl php8.2-cli php8.2-mysql php8.2-gd php8.2-common php8.2-xml php8.2-json php8.2-intl php8.2-pear php8.2-imagick php8.2-dev php8.2-common php8.2-mbstring php8.2-zip php8.2-soap php8.2-bz2 php8.2-bcmath php8.2-gmp php8.2-apcu libmagickcore-dev -y > /dev/null 2>&1

    echo '✅ PACKETS INSTALLÉS'

    echo '🌀 CONFIGURATION DE LA BASE DE DONNÉES...'

    mysql -u root -proot -Bse "CREATE DATABASE $DB_NAME;" > /dev/null 2>&1
    mysql -u root -proot -Bse "CREATE USER $DB_USER@localhost IDENTIFIED BY '$DB_PASS';" > /dev/null 2>&1
    mysql -u root -proot -Bse "GRANT ALL PRIVILEGES ON $DB_NAME.* TO $DB_USER@localhost;" > /dev/null 2>&1
    mysql -u root -proot -Bse "FLUSH PRIVILEGES;" > /dev/null 2>&1

    echo '✅ BASE DE DONNÉES CONFIGURÉE'

    echo '🌀 CONFIGURATION DE PHP'

    sed -i 's/;date.timezone =/date.timezone = Europe\/Paris/g' /etc/php/8.2/apache2/php.ini
    sed -i 's/upload_max_filesize = 2M/upload_max_filesize 500M/g' /etc/php/8.2/apache2/php.ini
    sed -i 's/post_max_size = 8M/post_max_size = 600M/g' /etc/php/8.2/apache2/php.ini
    sed -i 's/memory_limit = 128M/memory_limit = 512M/g' /etc/php/8.2/apache2/php.ini
    sed -i 's/max_execution_time = 30/max_execution_time = 300/g' /etc/php/8.2/apache2/php.ini
    sed -i 's/output_buffering = 4096/output_buffering = Off/g' /etc/php/8.2/apache2/php.ini
    sed -i 's/;zend_extension=opcache/zend_extension=opcache/g' /etc/php/8.2/apache2/php.ini
    sed -i 's/;opcache.enable=1/opcache.enable = 1/g' /etc/php/8.2/apache2/php.ini
    sed -i 's/;opcache.interned_strings_buffer=8/opcache.interned_strings_buffer = 8/g' /etc/php/8.2/apache2/php.ini
    sed -i 's/;opcache.max_accelerated_files=10000/opcache.max_accelerated_files = 10000/g' /etc/php/8.2/apache2/php.ini
    sed -i 's/;opcache.memory_consumption=128/opcache.memory_consumption = 128/g' /etc/php/8.2/apache2/php.ini
    sed -i 's/;opcache.save_comments=1/opcache.save_comments = 1/g' /etc/php/8.2/apache2/php.ini
    sed -i 's/;opcache.revalidate_freq=2/opcache.revalidate_freq = 1/g' /etc/php/8.2/apache2/php.ini

    echo '✅ PHP CONFIGURÉ'

    echo '🌀 TÉLÉCHARGEMENT DE NEXTCLOUD'

    cd /var/www
    curl -o nextcloud.zip https://download.nextcloud.com/server/releases/latest.zip > /dev/null 2>&1
    unzip nextcloud.zip > /dev/null 2>&1
    rm nextcloud.zip
    chown -R www-data:www-data /var/www

    echo '✅ TÉLÉCHARGEMENT TERMINÉ'

    echo '🌀 CONFIGURATION DE APACHE...'

    rm -drf /var/www/html
    a2dissite 000-default > /dev/null 2>&1
    rm /etc/apache2/sites-available/000-default.conf
    rm /etc/apache2/sites-available/default-ssl.conf

    echo "<VirtualHost *:$HTTP_PORT>
        ServerName $DOMAIN
        DocumentRoot /var/www/nextcloud/

        # Logs
        ErrorLog /var/log/apache2/error_nextcloud.log
        CustomLog /var/log/apache2/access_nextcloud.log combined

        <Directory /var/www/nextcloud/>
            Options +FollowSymlinks
            AllowOverride All

            <IfModule mod_dav.c>
                Dav off
            </IfModule>

            SetEnv HOME /var/www/nextcloud
            SetEnv HTTP_HOME /var/www/nextcloud
        </Directory>
    </VirtualHost>" > /etc/apache2/sites-available/nextcloud.conf
    a2ensite nextcloud.conf > /dev/null 2>&1
    systemctl restart apache2.service

    echo '✅ APACHE CONFIGURÉ'

    echo '🌀 DÉPLOIEMENT DE LA BASE DE DONNÉES DANS NEXTCLOUD...'

    cd /var/www/nextcloud
    sudo -u www-data php occ maintenance:install \
    --database "mysql" \
    --database-name "$DB_NAME" \
    --database-user "$DB_USER" \
    --database-pass "$DB_PASS" \
    --admin-user "$NEXTCLOUD_ADMIN_USER" \
    --admin-pass "$NEXTCLOUD_ADMIN_PASS"
    sudo -u www-data php occ config:system:set trusted_domains 0 --value="*"

    echo '✅ DÉPLOIEMENT TERMINÉ'

    echo ' '
    echo -e "${b_white}Nom d'utilisateur : ${b_yellow}$NEXTCLOUD_ADMIN_USER"
    echo -e "${b_white}Mot de passe : ${b_yellow}$NEXTCLOUD_ADMIN_PASS$end_color"

    echo ' '
    read -n1 -s -r -p 'Appuyez sur une touche pour continuer...'
}