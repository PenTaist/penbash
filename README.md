# 🔧 PenBash

## 📌 Description

Ce projet est un script Bash interactif conçu pour automatiser une large gamme de tâches d’administration système sous Linux. Il permet le **déploiement rapide d’outils couramment utilisés** (tels que WordPress, Nextcloud, GLPI, etc.), ainsi que la **gestion fine du système**, incluant les utilisateurs, le réseau, et les mises à jour. Ce script est pensé pour les administrateurs systèmes, étudiants ou professionnels souhaitant gagner du temps tout en conservant le contrôle de leur infrastructure.

---

## 🛠️ Fonctionnalités

### 🚀 Déploiements automatisés

Le script permet l'installation automatique et prête à l'emploi des services suivants :

- **Pile LAMP** (Linux, Apache, MySQL/MariaDB, PHP)
- **WordPress** (avec base de données et configuration Apache)
- **GLPI** (outil de gestion de parc informatique)
- **Podman** (Docker amélioré)
- **CheckMK** (outil de supervision)
- **NextCloud** (solution de cloud personnel)
- **Serveur ZFS** (installation du serveur ZFS et configuration de partages)

---

## 🖼️ Screenshots

![Menu principal](screenshots/main-menu.png)
![Configuration basique](screenshots/base-menu.png)

---

## 💡 Utilisation

### 1. Lancer le script

```bash
chmod +x penba.sh
sudo ./penba.sh
