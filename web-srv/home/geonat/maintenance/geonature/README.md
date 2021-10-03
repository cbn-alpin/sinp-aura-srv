# Maintenance

## Maintenance longue

Pour basculer le site Biodiv'AURA Expert en maintenance longue,
renommer le fichier `maintenance.disable` en `maintenance.enable`.
```
mv ~/www/maintenance/geonature/maintenance.disable ~/www/maintenance/geonature/maintenance.enable
```

Ce fichier doit simplement exister et avoir le bon nom. Il peut être vide.

## Maintenance courte

Le site bacule automatiquement en maintenance courte lorsque le dossier `dist`
contenant les fichiers du site générés par Angular n'existe pas.

La compilation de GeoNature via Angular supprime automatiquement ce dossier
en début de compilation et le régénère à la fin.

## Forcer l'accès au site

Dans le cas d'une maintenance longue, vous pouvez souhaiter accéder au site pour
visualiser le résultat de votre travail de maintenance.

### Via IP
Certaines IP fixes comme celle du serveur ou celles des postes des administrateurs
peuvent être ajouté dans `/etc/nginx/sites-available/geonature.conf`
afin de ne pas afficher la page maintenance.

Les navigateurs présentant ces IP continueront d'accéder normalement au site.

### Via Cookie
Il est aussi possible de court-circuiter la page de maintenance en ajoutant un
cookie nommé `maintenance_disable` au domaine de Biodiv'AURA Expert.

Vous pouvez passer par le "*DevTools*" de votre navigateur.

Ce cookie doit contenir un UUID spécifique. Si l'UUID coincide avec celui
indiqué dans le fichier `/etc/nginx/sites-available/geonature.conf` la 
maintenance est désactivée.
