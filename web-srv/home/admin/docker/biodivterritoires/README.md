# Déploiement de BiodivTerritoire à partir du dump

## HowTo

Les scripts SQL nécessaires à l'installation de Biodiv'Territoires sont présent dans le dépôt [sinp-aura-data](https://github.com/cbn-alpin/sinp-aura-data)

## BDD

### Schéma `taxonomie`

- Nouvelles tables dédiées à la gestion des listes rouges:
  - `taxonomie.bib_c_redlist_categories` > Liste des catégories de statuts de liste rouge
  - `taxonomie.bib_c_redlist_source` > Liste des sources de liste rouge
  - `taxonomie.cor_c_redlist_source_area` > Correlation between RedList sources (bib_c_redlist_source) and areas (ref_geo.l_areas) : defines where Red List sources apply.
  - `taxonomie.t_c_redlist` > Liste des sources de statuts de liste rouge

### Schéma `gn_biodivterritory`

- Tables et vues matérialisées dédiées à l'application biodiv-territoires
- **!!! Adaptation a faire dans le fichier 05 sur la liste des area_type à utiliser (INSERT sur la table `gn_biodivterritory.l_areas_type_selection`). notamment les mailles utilisées pour la restitution carto. Pour les EPCI, il faut les ajouter dans le ref_geo si attendu**

### Rafraichissement des données

- Mettre une tache *Cron* pour rafraichir régulièrement les données de:
  - `gn_biodivterritory.mv_general_stats` > Statistiques générales d'intro de la plateforme (pas indispensable si pas utilisée...)
  - `gn_biodivterritory.mv_territory_general_stats` (Données statistiques de synthèse pour chaque territoires).

!! Les types de territoires faisant l'objet d'une synthèse sont à préciser dans la table gn_biodivterritory.l_areas_type_selection.

##  Déploiement docker

Adapter les fichiers `docker-compose.yml` et `.env` du dossier docker et lancer l'application.
