# 🔧 Script Bash de Déploiement et d’Administration Système

## 📌 Description

Ce projet est un script Bash interactif conçu pour automatiser une large gamme de tâches d’administration système sous Linux. Il permet le **déploiement rapide d’outils couramment utilisés** (tels que WordPress, Nextcloud, GLPI, etc.), ainsi que la **gestion fine du système**, incluant les utilisateurs, le réseau, et les mises à jour. Ce script est pensé pour les administrateurs systèmes, étudiants ou professionnels souhaitant gagner du temps tout en conservant le contrôle de leur infrastructure.

---

## 🛠️ Fonctionnalités

### 🚀 Déploiements automatisés

Le script permet l'installation automatique et prête à l'emploi des services suivants :

- **Pile LAMP** (Linux, Apache, MySQL/MariaDB, PHP)
- **WordPress** (avec base de données et configuration Apache)
- **GLPI** (outil de gestion de parc informatique)
- **Docker** (avec installation de Docker et Docker Compose)
- **CheckMK** (outil de supervision)
- **NextCloud** (solution de cloud personnel)
- **Serveur ZFS** (installation de ZFS et configuration de partages)

---

### 📋 Menu Principal

Interface interactive simple et intuitive permettant de naviguer entre les différentes fonctionnalités :

- **Mises à jour** du système
- **Modification du nom d’hôte** (hostname)

---

### 👥 Gestion des utilisateurs et groupes

Fonctionnalités pour faciliter l'administration des comptes utilisateurs :

- **Ajout / suppression** d’utilisateurs
- **Ajout / suppression** de groupes
- **Modification des mots de passe**
- **Ajout / suppression des droits sudo** (avec ou sans mot de passe grâce à `NOPASSWD`)

---

### 🌐 Configuration réseau

Personnalisation facile des paramètres réseau via menu :

- **Adresse IP statique**
- **Passerelle (gateway)**
- **Serveurs DNS**
- **Serveur DHCP**

---

## 💡 Utilisation

### 1. Lancer le script

```bash
chmod +x admin-tools.sh
sudo ./admin-tools.sh
