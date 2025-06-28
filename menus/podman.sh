# --------------------------------------------
# MENU PODMAN
# --------------------------------------------

function podman_menu() {
    clear

    echo ' '
    echo -e "$yellow$podman_menu_ascii$end_color"
    echo ' '

    podman_install
}

# --------------------------------------------
# LANCEMENT DE L'INSTALLATION
# --------------------------------------------

function podman_install() {
    echo '🌀 INSTALLATION DE PODMAN...'

    apt install podman -y > /dev/null 2>&1

    for user in $(awk -F: '($3 >= 1000) && ($7 !~ /nologin|false/) {print $1}' /etc/passwd); do
        loginctl enable-linger "$user"
    done

    echo '✅ INSTALLATION TERMINÉE'

    echo '🌀 AJOUT DU REGISTRE DOCKER...'

    sed -i -e "s/# unqualified-search-registries/unqualified-search-registries/g" /etc/containers/registries.conf
    sed -i -e "s/example.com/docker.io/g" /etc/containers/registries.conf
    systemctl restart podman.service

    echo '✅ AJOUT TERMINÉ'

    echo ' '
    read -n1 -s -r -p 'Appuyez sur une touche pour continuer...'
}