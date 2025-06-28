# --------------------------------------------
# MENU DE BASE
# --------------------------------------------

function base_menu() {
    while true; do
        clear

        echo ' '
        echo -e "$blue$base_menu_ascii"
        echo ' '
        echo -e "$light_yellow$separator_2"
        echo ' '
        echo -e "$b_yellow$base_menu_cat_1$yellow"
        echo ' '
        echo -e "$base_menu_text_1\t\t$base_menu_text_3"
        echo -e "$base_menu_text_2\t$base_menu_text_4"
        echo ' '
        echo -e "$b_yellow$base_menu_cat_2$yellow"
        echo ' '
        echo -e "$base_menu_text_5\t$base_menu_text_7"
        echo -e "$base_menu_text_6\t\t$base_menu_text_8"
        echo ' '
        echo -e "$light_yellow$separator_2"
        echo -e "$light_red$base_menu_sub_text_1"
        echo -e "$red$base_menu_sub_text_2"
        echo -e "$light_yellow$separator_2$end_color"
        echo ' '

        read -p 'Choissez une option : ' choice

        case $choice in
            0)
                return
                ;;
            1)
                echo 'Mise à jour des packets en cours...'
                
                update

                echo 'Mise à jour terminée !'
                echo ' '

                read -n1 -s -r -p 'Appuyez sur une touche pour continuer...'
                base_menu
                ;;
            2)
                echo 'Installation des packets...'

                install_base_packages

                echo 'Installation terminée !'
                echo ' '

                read -n1 -s -r -p 'Appuyez sur une touche pour continuer...'
                base_menu
                ;;
            3)
                read -p 'Entrez le nouveau nom : ' hostname
                change_hostname $hostname

                read -p 'Redémarrer la machine ? (y/n) : ' reboot_choice

                if [ $reboot_choice == 'y' ]; then
                    reboot
                fi

                echo 'Le nom de la machine as bien été modifié !'

                echo ' '
                read -n1 -s -r -p 'Appuyez sur une touche pour continuer...'

                base_menu
                ;;
            4)
                echo ' '
                ip -c a
                echo ' '
                read -p 'Interface : ' nic
                read -p 'IP : ' ip
                read -p 'Passrelle : ' gateway
                read -p 'DNS 1 : ' dns1
                read -p 'DNS 2 : ' dns2

                echo 'Modification en cours...'

                change_network_infos $nic $ip $gateway $dns1 $dns2

                echo 'Les informations réseau ont bien été mises à jour !'

                echo ' '
                read -n1 -s -r -p 'Appuyez sur une touche pour continuer...'

                base_menu
                ;;
            5)
                read -p 'Mode (add/del) : ' mode

                if [ $mode == 'add' ]; then
                    read -p "Nom d'utilisateur : " username
                    echo -n 'Mot de passe : '
                    password=''

                    while IFS= read -r -s -n1 char; do
                        if [[ $char == $'\0' || $char == "" ]]; then
                            echo
                            break
                        fi

                        if [[ $char == $'\177' ]]; then
                            if [ -n "$password" ]; then
                                password=${password::-1}
                                echo -ne "\b \b"
                            fi
                        else
                            password+="$char"
                            echo -n "*"
                        fi
                    done

                    echo "Création de l'utilisateur..."

                    add_user $username $password

                    echo "L'utilisateur as été crée avec succes !"
                    echo ' '
                    read -n1 -s -r -p 'Appuyez sur une touche pour continuer...'
                else
                    read -p "Nom d'utilisateur : " username

                    echo "Suppression de l'utilisateur..."

                    del_user $username

                    echo "L'utilisateur as bien été supprimé !"
                    echo ' '
                    read -n1 -s -r -p 'Appuyez sur une touche pour continuer...'
                fi

                base_menu
                ;;
            6)
                read -p 'Mode (add/del) : ' mode

                if [ $mode == 'add' ]; then
                    read -p 'Nom du groupe : ' group_name

                    echo 'Ajout du groupe en cours...'

                    add_group $group_name

                    echo 'Le groupe as été crée avec succes !'
                    echo ' '
                    read -n1 -s -r -p 'Appuyez sur une touche pour continuer...'
                else
                    read -p 'Nom du groupe : ' group_name

                    echo 'Suppression du groupe en cours...'

                    del_group $group_name

                    echo 'Le groupe as bien été supprimé !'
                    echo ' '
                    read -n1 -s -r -p 'Appuyez sur une touche pour continuer...'
                fi

                base_menu
                ;;
            7)
                read -p 'Mode (add/del) : ' mode

                if [ $mode == 'add' ]; then
                    read -p "Nom d'utilisateur : " username
                    read -p 'NOPASSWD ? (y/n) : ' nopasswd

                    echo "Ajout de l'utilisateur aux sudoers..."

                    add_sudo_user $username $nopasswd

                    echo "L'utilisateur fait maintenant partis des sudoers !"
                    echo ' '
                    read -n1 -s -r -p 'Appuyez sur une touche pour continuer...'
                else
                    read -p "Nom d'utilisateur : " username

                    echo "Suppression de l'utilisateur des sudoers..."

                    del_sudo_user $username

                    echo "L'utilisateur ne fait plus partis sudoers !"
                    echo ' '
                    read -n1 -s -r -p 'Appuyez sur une touche pour continuer...'
                fi

                base_menu
                ;;
            8)
                read -p 'Mode (add/del) : ' mode

                if [ $mode == 'add' ]; then
                    read -p 'Nom du groupe : ' group_name
                    read -p 'NOPASSWD ? (y/n) : ' nopasswd

                    echo 'Ajout du groupe aux sudoers...'

                    add_sudo_group $group_name $nopasswd

                    echo 'Le groupe fait maintenant partis des sudoers !'
                    echo ' '
                    read -n1 -s -r -p 'Appuyez sur une touche pour continuer...'
                else
                    read -p 'Nom du groupe : ' group_name

                    echo 'Suppression du groupe des sudoers...'

                    del_sudo_group $group_name

                    echo 'Le groupe ne fait plus partis sudoers !'
                    echo ' '
                    read -n1 -s -r -p 'Appuyez sur une touche pour continuer...'
                fi

                base_menu
                ;;
            *)
                echo -e "${bg_red}Arrêt du script...$end_color"
                echo ' '
                exit 1
                ;;
        esac
    done
}

# --------------------------------------------
# Mise à jour des packets
# --------------------------------------------

function update() {
    apt update > /dev/null 2>&1
    apt upgrade -y > /dev/null 2>&1
}

# --------------------------------------------
# Installation des packets de base
# --------------------------------------------

function install_base_packages() {
    apt install git curl wget zip unzip sudo jq screen htop net-tools zsh expect -y > /dev/null 2>&1
}

# --------------------------------------------
# Modification du nom de la machine
# --------------------------------------------

function change_hostname() {
    old_hostname=$(hostname)
    new_hostname=$1

    echo "$new_hostname" > /etc/hostname
    sed -i "s/$old_hostname/$new_hostname/g" /etc/hosts
}

# --------------------------------------------
# Ajout d'un utilisateur
# --------------------------------------------

function add_user() {
    username=$1
    password=$2

    useradd -m -s /bin/bash $username >/dev/null 2>&1
    echo "$username:$password" | chpasswd >/dev/null 2>&1
}

# --------------------------------------------
# Suppression d'un utilisateur
# --------------------------------------------

function del_user() {
    username=$1

    userdel -r $username >/dev/null 2>&1
}

# --------------------------------------------
# Ajout d'un groupe
# --------------------------------------------

function add_group() {
    $group_name=$1

    groupadd $group_name >/dev/null 2>&1
}

# --------------------------------------------
# Suppression d'un groupe
# --------------------------------------------

function del_group() {
    group_name=$1

    groupdel $group_name >/dev/null 2>&1
}

# --------------------------------------------
# Ajout d'un utilisateur aux sudoers
# --------------------------------------------

function add_sudo_user() {
    username=$1
    nopasswd=$2

    if [ $nopasswd == 'y' ]; then
        echo "$username ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers
    else
        echo "$username ALL=(ALL:ALL) ALL" >> /etc/sudoers
    fi
}

# --------------------------------------------
# Suppression d'un utilisateur des sudoers
# --------------------------------------------

function del_sudo_user() {
    username=$1

    sed -i "s/$username ALL=(ALL:ALL) NOPASSWD:ALL/ /g" /etc/sudoers
    sed -i "s/$username ALL=(ALL:ALL) ALL/ /g" /etc/sudoers
}

# --------------------------------------------
# Ajout d'un groupe aux sudoers
# --------------------------------------------

function add_sudo_group() {
    group_name=$1
    nopasswd=$2

    if [ $nopasswd == 'y' ]; then
        echo "%$group_name ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers
    else
        echo "%$group_name ALL=(ALL:ALL) ALL" >> /etc/sudoers
    fi
}

# --------------------------------------------
# Suppression d'un groupe des sudoers
# --------------------------------------------

function del_sudo_group() {
    group_name=$1

    sed -i "s/%$group_name ALL=(ALL:ALL) NOPASSWD:ALL/ /g" /etc/sudoers
    sed -i "s/%$group_name ALL=(ALL:ALL) ALL/ /g" /etc/sudoers
}

# --------------------------------------------
# Modifier les informations réseau
# --------------------------------------------

function change_network_infos() {
    nic=$1
    ip=$2
    gateway=$3
    dns1=$4
    dns2=$5

    sed -i "s/allow-hotplug $nic/#allow-hotplug $nic/g" /etc/network/interfaces
    sed -i "s/iface $nic inet dhcp/#iface $nic inet dhcp/g" /etc/network/interfaces

    echo -e "allow-hotplug $nic\niface $nic inet static\n\taddress $ip\n\tgateway $gateway\n\tdns-nameservers $dns1" > /etc/network/interfaces.d/$nic
    echo "nameserver $dns1" >> /etc/resolv.conf
    echo "nameserver $dns2" >> /etc/resolv.conf

    systemctl restart networking.service
}