# sinp-aura-srv
Scripts et fichiers de configuration utilisés pour la mise en place du SINP AURA.
Scripts : nginx, docker, bash...

## Documentation de l'installation des serveurs
Voir la documentation sur le Wiki SINP du CBNA : https://sinp-wiki.cbn-alpin.fr

## Synchronisation locale vers serveur

### Fichiers de l'Atlas
Utiliser `rsync`. Exemple pour synchroniser les images personnalisables depuis le dossier `/home/geonat/www/atlas` :

```shell
rsync -av --size-only ./static/custom/images/ geonat@web-aura-sinp:/home/geonat/www/atlas/static/custom/images/
```
Cette commande utilise l'option --size-only pour baser le transfert seulement sur les différences de tailles des fichiers sans prendre en compte les métadonnées.
