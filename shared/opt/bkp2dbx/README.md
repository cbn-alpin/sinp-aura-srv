# Bkp2dbx - Backup to Dropbox

Ensemble de scripts et ressources permettant de réaliser une sauvegarde périodique de fichiers 
et/ou dossiers présents sur une machine vers un compte Dropbox.

## Installation

- Lancer le script d'installation : `./setup.sh`
- Il permet de :
  - Télécharger la dernière version du script bash [Dropbox-Uploader](https://github.com/andreafabrizi/Dropbox-Uploader).
  - Installer le fichier **bkp2dbx.cron** dans **/etc/cron.d/**
- Pour créer le fichier de configuration **/home/$USER/.dropbox_uploader**, deux solutions :
  - lancer le script manuellement une première fois. Cela permet d'être guidé par un assistant pour le créer.
  - si vous savez comment créer un app token Dropbox, créer manuellement le fichier, il doit contenir seulement : `OAUTH_ACCESS_TOKEN=<votre-app-token>`


## Utilisation
- Le script `bkp2dbx.sh` créer une archive tar.gz des fichiers à sauvegardé et l'envoi sur Dropbox.
- Le script `sync2dbx.sh` envoie les fichiers à sauvegarder sur Dropbox et supprime sur Dropbox
les fichiers qui n'existe plus en local. La suppression des fichiers sur Dropbox n'a lieu que
s'il reste au moins un fichier sur Dropbox après la suppression.
- Une fois installé, vous pouvez ajouter des entrées dans **/etc/cron.d/bkp2dbx**.
- Pensez à créer un fichier de config distinct par utilisateur.
