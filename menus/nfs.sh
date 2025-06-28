# --------------------------------------------
# DÉPENDANCES
# --------------------------------------------

source env/nfs.env

# --------------------------------------------
# MENU NFS
# --------------------------------------------

function nfs_menu() {
    clear

    echo ' '
    echo -e "$purple$nfs_menu_ascii$end_color"
    echo ' '

    nfs_install
}

# --------------------------------------------
# LANCEMENT DE L'INSTALLATION
# --------------------------------------------

function nfs_install() {
    echo '🌀 INSTALLATION DU SERVEUR NFS...'

    apt install nfs-kernel-server -y > /dev/null 2>&1
    systemctl enable nfs-server.service > /dev/null 2>&1

    echo '✅ SERVEUR INSTALLÉ'

    echo '🌀 CRÉATION DU PARTAGE...'

    mkdir /nfs/$SHARE_NAME
    chown nobody:nogroup /nfs/$SHARE_NAME
    chmod 755 /nfs/$SHARE_NAME

    echo "/nfs/$SHARE_NAME *(rw,sync,anonuid=65534,anongid=65534,no_subtree_check)" >> /etc/exports

    echo '✅ PARTAGE CRÉE'

    echo ' '
    read -n1 -s -r -p 'Appuyez sur une touche pour continuer...'
}