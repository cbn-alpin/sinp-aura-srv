# Docker

## Synchronisation serveur
### Synchroniser un dossier Docker

Pour transférer uniquement un dossier contenant les fichiers Docker d'un domaine
sur le serveur, utiliser `rsync` en testant avec l'option `--dry-run` (à supprimer quand tout est ok):

```shell
# Exemple pour analytics.biodiversite-aura.net
cd analytics
rsync -av --copy-unsafe-links ./ admin@web-aura-sinp:~/docker/analytics/ --dry-run
```

### Synchroniser l'ensemble des dossiers Docker

Pour synchroniser ces fichiers avec le serveur utiliser `rsync` :
 - Se placer à la racine du dépôt
 - Lancer la commande `rsync` suivante, ici pour *web-srv* et le dossier *docker* avec l'option `--dry-run` (à supprimer quand tout est ok):

```shell
rsync -av ./web-srv/docker/ admin@web-aura-sinp:/home/admin/docker/ --dry-run
```

## Commandes utiles avec les images Docker

### InfluxDb
#### Récupérer le fichier de configuration par défaut

```shell
docker run --rm influxdb:1.7.9 influxd config > web-srv/monitor.silene.eu/influxdb/influxdb.sample.conf
```

### Telegraf
#### Récupérer le fichier de configuration par défaut

```shell
docker run --rm telegraf:1.13.0 telegraf config | \
  tee web-srv/monitor.silene.eu/telegraf/telegraf.sample.conf > /dev/null
```

### Portainer
#### Brcypter le mot de passe admin

```shell
 htpasswd -bnBC 10 "" <mot-de-passe-admin> | tr -d ':\n'
```
