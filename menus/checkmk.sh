# --------------------------------------------
# DÉPENDANCES
# --------------------------------------------

source env/checkmk.env

# --------------------------------------------
# MENU CHECKMK
# --------------------------------------------

function checkmk_menu() {
    clear

    echo ' '
    echo -e "$green$checkmk_menu_ascii$end_color"
    echo ' '

    checkmk_install
}

# --------------------------------------------
# LANCEMENT DE L'INSTALLATION
# --------------------------------------------

function checkmk_install() {
    echo "🌀 TÉLÉCHARGEMENT DE CHECKMK v$VERSION..."

    apt install -y gpg wget > /dev/null 2>&1
    cd /tmp
    wget https://download.checkmk.com/checkmk/$VERSION/check-mk-raw-${VERSION}_0.bookworm_amd64.deb > /dev/null 2>&1
    wget https://download.checkmk.com/checkmk/Check_MK-pubkey.gpg > /dev/null 2>&1

    echo '✅ TÉlÉCHARGEMENT TERMINÉ'

    echo "🌀 INSTALLATION DE CHECKMK v$VERSION..."

    gpg --import Check_MK-pubkey.gpg > /dev/null 2>&1
    apt install ./check-mk-raw-${VERSION}_0.bookworm_amd64.deb -y > /dev/null 2>&1

    echo '✅ INSTALLATION TERMINÉE'
    
    echo "🌀 CRÉATION DU SITE..."

    apt install expect -y > /dev/null 2>&1

    omd create supervision > /dev/null 2>&1

    expect -c "
        set timeout 10
        spawn omd su supervision
        expect {OMD[supervision]:~\$}
        send \"cmk-passwd cmkadmin\r\"
        expect \"New password:\"
        send \"$ADMIN_PASSWORD\r\"
        expect \"Re-type new password:\"
        send \"$ADMIN_PASSWORD\r\"
        expect {OMD[supervision]:~\$}
        send \"exit\r\"
        expect eof
    " > /dev/null 2>&1

    systemctl enable omd.service
    systemctl start omd.service

    echo '✅ CRÉAION TERMINÉE'
    echo ' '
    echo -e "${b_white}Nom d'utilisateur : ${b_blue}cmkadmin${end_color}"
    echo -e "${b_white}Mot de passe : ${b_blue}cmkadmin${end_color}"

    echo ' '
    read -n1 -s -r -p 'Appuyez sur une touche pour continuer...'
}