#!/bin/bash

# --------------------------------------------
# DÉPENDANCES
# --------------------------------------------

source env/colors.env
source env/menus_styles.env

# --------------------------------------------
# MENU PRINCIPAL
# --------------------------------------------

function main_menu() {
    while true; do
        clear

        echo ' '
        echo -e "$purple$main_menu_ascii"
        echo ' '
        echo -e "$light_green$separator_1"
        echo ' '
        echo -e "$green$main_menu_text_1\t\t$main_menu_text_5"
        echo -e "$green$main_menu_text_2\t\t$main_menu_text_6"
        echo -e "$green$main_menu_text_3\t\t$main_menu_text_7"
        echo -e "$green$main_menu_text_4\t\t\t$main_menu_text_8"
        echo ' '
        echo -e "$light_green$separator_1"
        echo -e "$red$main_menu_sub_text_1"
        echo -e "$light_green$separator_1$end_color"
        echo ' '

        read -p 'Choissez une option : ' choice

        case $choice in
            1)
                source menus/base.sh
                base_menu
                ;;
            2)
                source menus/lamp.sh
                lamp_menu
                ;;
            3)
                source menus/wordpress.sh
                wordpress_menu
                ;;
            4)
                source menus/glpi.sh
                glpi_menu
                ;;
            5)
                source menus/podman.sh
                podman_menu
                ;;
            6)
                source menus/checkmk.sh
                checkmk_menu
                ;;
            7)
                source menus/nextcloud.sh
                nextcloud_menu
                ;;
            8)
                source menus/nfs.sh
                nfs_menu
                ;;
            *)
                echo -e "${bg_red}Arrêt du script...$end_color"
                echo ' '
                exit 1
                ;;
        esac
    done
}

main_menu