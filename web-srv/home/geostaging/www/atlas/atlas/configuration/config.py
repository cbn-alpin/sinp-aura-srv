# -*- coding:utf-8 -*-
# To test syntax of this file use : python3 -m py_compile config.py

#+----------------------------------------------------------------------------+
# Fichier de configuration

# Connexion de l'application à la BDD (avec l'utilisateur `user_pg` renseigné dans le `settings.ini`)
SQLALCHEMY_DATABASE_URI = "postgresql://geonatatlas:<user_pg_pass>@10.0.1.40:5432/gnatlas"


# Ce paramètre avancé permet de configurer la connexion de SQLAlchemy avec la base de données.
# Ne l'utiliser que si vous savez ce que vous faites !
# Les paramètres de configuration de la connexion doivent correspondre à ceux utilisés dans la fonction `create_engine`
# de SQLAlchemy : https://docs.sqlalchemy.org/en/14/core/engines.html#sqlalchemy.create_engine
# Ci-dessous un exemple de paramètre que vous pouvez adapter selon votre serveur et besoins :
SQLALCHEMY_ENGINE_OPTIONS = {
    # En environnement Staging, 2 connexions permanentes par worker suffisent (4 connexions de base au total)
    "pool_size": 2,
    # Marge de 2 connexions temporaires par worker en cas de pic ponctuel
    "max_overflow": 2,
    #Recyclage toutes les 30 minutes au lieu de 30 secondes
    "pool_recycle": 1800,
    # Doit rester inférieur au timeout de Gunicorn (60s)
    "pool_timeout": 30,
    # Élimine les connexions fermées silencieusement côté PostgreSQL
    "pool_pre_ping": True,
    "pool_use_lifo": True,
    "connect_args": {
        "connect_timeout": 10,
        "application_name": "atlas-geostaging",
        "keepalives": 1,
        "keepalives_idle": 30,
        "keepalives_interval": 10,
        "keepalives_count": 5,
    },
}

# URL de l'application depuis la racine du domaine
# ex "/atlas" pour une URL de type http://mon-domaine/atlas OU "" si l'application est accessible à la racine du domaine
URL_APPLICATION = ""

# Configuration de sécurité
SECRET_KEY = '<secret_key>'

# Controle la manière dont le moteur de rendu Jinja2 gère la mise en cache des gabarits HTML
# Si True, recharge automatiquement les gabarits en fonction de la date de dernière modification.
# À utiliser dans les environnements de tests ou pré-production.
# Si False, nécessite de redémarrer le service de l'Atlas pour prendre en compte les modifications
# des gabarits. À privilégier en production.
TEMPLATES_AUTO_RELOAD = True

# Temps en seconde de la durée de mise en cache en mémoire par worker Gunicorn
# Utilisé uniquement pour les webservices de l'API les plus lourds (rang et stats) via le décorateur @cache.cached.
# Redémarrer le service de l'Atlas supprime tout le cache.
CACHE_TIMEOUT = 31536000

# URL d'accès aux photos et autres médias (URL racine). Dans vm_medias est uniquement stocké le nom du fichier. Il est donc necessaire de préciser l'URL d'accès aux médias, pour construire le chemin complet de chaque image.
REMOTE_MEDIAS_URL = "https://gn.biodiversite-aura.net/static/medias/"

# URL de TaxHub : nécessaire pour le redimensionnement des images
TAXHUB_URL = "https://gn.biodiversite-aura.net/api/taxhub"

#+----------------------------------------------------------------------------+
# Personnalisation de l'application

# Nom de la structure
STRUCTURE = "SINP AURA"

# Nom de l'application
NOM_APPLICATION = "Biodiv'AURA Atlas - Staging"

# Afficher ou non les labels dans la barre latérale
AFFICHAGE_LABEL_SIDEBAR = False

# Utiliser et afficher le glossaire (static/custom/glossaire.json)
# Le fichier par défaut est présent dans static/sample/glossaire.json.
GLOSSAIRE = False

# Afficher le lien vers la galerie photo
AFFICHAGE_GALERIE_PHOTO = True

# Activer la génération à la volée des vignettes des images
REDIMENSIONNEMENT_IMAGE = True


#+----------------------------------------------------------------------------+
# Styles et couleurs

# Couleur principale de l'atlas
TEMPLATE_MAIN_COLOR = "#8031A7"
TEMPLATE_SECOND_COLOR = "#CC1FD3"

# 3 couleurs principales des graphiques de type "barre"
# par défaut vaut [TEMPLATE_MAIN_COLOR,TEMPLATE_SECOND_COLOR, "grey" ]
# sur la fiche espèce c'est la première couleur de ce tableau qui est prise
# COLOR_STACKED_BAR_CHARTS = [#53c412, "#1e7e12", "grey"]

# Couleurs des diagrammes circulaires (provenance des données par organismes et groupes taxonomiques - fiche espèce et zonage)
COLOR_PIE_CHARTS = [
    "#981D97",
    "#FBFFB9",
    "#FDD692",
    "#EC7357",
    "#754F44",
    "#FB6376",
    "#B7ADCF",
    "#DEE7E7",
    "#F4FAFF",
    "#383D3B",
    "#7C7C7C",
    "#B5F44A",
    "#D6FF79",
    "#507255",
    "#381D2A",
    "#BA5624",
    "#FFA552",
    "#F7FFE0",
    "#49C6E5",
    "#54DEFD",
    "#0B5563",
    "#54DEFD",
]


#+----------------------------------------------------------------------------+
# Multilingual

# Default language, also used when multilingual is disabled
DEFAULT_LANGUAGE = 'fr'

# Activate multilingual
MULTILINGUAL = False


#+----------------------------------------------------------------------------+
# Cartographie

# Configuration des cartes (centre du territoire, couches CARTE et ORTHO, échelle par défaut...)
MAP = {
    'LAT_LONG': [45.29619, 4.66072],
    'FIRST_MAP': {
            'url' : '//{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png',
            'attribution' : '&copy OpenStreetMap',
            'tileName' : 'OSM'
    },
    'SECOND_MAP' : {'url' : '//data.geopf.fr/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&STYLE=normal&TILEMATRIXSET=PM&TILEMATRIX={z}&TILEROW={y}&TILECOL={x}&LAYER=HR.ORTHOIMAGERY.ORTHOPHOTOS&FORMAT=image/jpeg',
            'attribution' : '&copy IGN',
            'tileName' : 'IGN Ortho'
    },
    'ZOOM' : 7,
    'MIN_ZOOM' : 7,
    'MAX_BOUNDS' : [[44.13,1.48],[46.89,7.41]],
    # Couleur et épaisseur des limites du territoire
    'BORDERS_COLOR': '#000000',
    'BORDERS_WEIGHT': 3,
    'MASK_STYLE': {
        'fill': False,
        'fillColor': '#020202',
        'fillOpacity': 0.3
    },
    'ENABLE_SLIDER': True,
    # Pas du slider sur les annees d'observations: 1 = pas de 1 an sur le slider
    'STEP': 10,
    'ENABLE_SCALE': True
}

COUCHES_SIG = [
    {
        'name': 'Territoire',
        'type': 'geojson',
        'url': 'https://gna.biodiversite-aura.net/custom/maps/territory.json',
        'style': {
            'color': '#000',
            'weight': 3,
            'opacity': 1,
            'fillOpacity': 0,
        },
        'selected': True,
    },
]

# Ajout du plugin Nominatim permettant une recherche d'adresse sur les cartes de la page d'accueil et des fiches territoire
SEARCH_NOMINATIM = True

# Paramètres de recherche du plugin Nominatim
GEOCODING_QUERY_PARAMS = {
    "countrycodes": "FR",
    # Ouest, Nord, Est, Sud avec marge de tolérance (~5 km)
    "viewbox": "2.010,46.850,7.240,44.060",
    # 1 pour chercher uniquement dans la viewbox définie ci-dessus
    "bounded": 1
}

# Affichage des observations par maille ou point
# True = maille / False = point
AFFICHAGE_MAILLE = True

# Personnaliser la couleur du contour des mailles sur la carte.
# Peut prendre une valeur de couleur standardisée ou héxadécimale (ex : "black", "grey", "#333333") : "transparent" par défaut.
COULEUR_CONTOUR_MAILLE = "rgba(221, 221, 221, .6)"

# Carte de la page d'accueil: observations des 'x' derniers jours. Bien mettre en anglais et non accordé
NB_DAY_LAST_OBS = '1 year'
# Texte à afficher pour décrire la cartographie des 'dernières observations'
TEXT_LAST_OBS = 'Les observations de l\'année écoulée |'
# Carte de la fiche commune: nombre des 'x' dernières observations affichées
NB_LAST_OBS=500


#+----------------------------------------------------------------------------+
# Page d'accueil

# Bloc d'introduction presentant l'atlas. Affichage True/False
AFFICHAGE_INTRODUCTION = True

# Afficher le Footer sur toutes les pages (static/custom/templates/footer.html)
AFFICHAGE_FOOTER = True

# Bloc de statistiques globales. Affichage True/False
AFFICHAGE_STAT_GLOBALES = True

# Bloc avec carte de toutes les observations du territoire
# On ne peut pas afficher la carte des dernières observations et cette carte en même temps : les deux paramètres ne peuvent donc pas être à True
AFFICHAGE_TERRITOIRE_OBS= False

# Bloc avec carte et liste des dernières observations. Affichage True/False
AFFICHAGE_DERNIERES_OBS = False

# Carte de la page d'accueil: observations des 'x' derniers jours. Bien mettre en anglais et non accordé
NB_DAY_LAST_OBS = '180'

# Texte à afficher pour décrire la cartographie des 'dernières observations'
TEXT_LAST_OBS = 'Les observations des 6 derniers mois |'

# Bloc avec espèces à voir en ce moment. Affichage True/False
AFFICHAGE_EN_CE_MOMENT = True

# Bloc des logos des partenaires
AFFICHAGE_LOGOS_HOME = False

# Bloc des nouvelles espèces
AFFICHAGE_NOUVELLES_ESPECES = False

# Bloc stats par rangs
AFFICHAGE_RANG_STAT = True
COLONNES_RANG_STAT = 4
RANG_STAT_FR = ['Faune vertébrée', 'Faune invertébrée', 'Plantes', 'Champignons']
RANG_STAT = [{'phylum': ["Chordata"]}, {'phylum': ["Arthropoda", "Mollusca", "Annelida", "Cnidaria", "Platyhelminthes"]}, {'regne': ["Plantae"]}, {'regne': ["Fungi"]}]

# Afficher le lien "données personnelles" dans le footer
AFFICHAGE_RGPD = True

# Liste des applications dont "orejime" controle la dépose de cookie
OREJIME_APPS = [
    {
        "name": "script-matomo", # ce nom devra être réutilisé dans la balise script (attribut `data-name`) du fichier `footer.html` où le script d'analyse des cookies sera integré
        "title": "Matomo",
        "cookies": [
            "_pk_ref",
            "_pk_cvar",
            "_pk_id",
            "_pk_ses",
            "mtm_consent",
            "mtm_consent_removed",
            "mtm_cookie_consent",
            "matomo_ignore",
            "matomo_sessid",
            "_pk_hsr"
        ],
        "purposes": ["analytics"],
        "required": False,
        "optOut": False,
        "default": True,
        "onlyOnce": True,
    }
]

# Traductions orejime (voir la doc cookie et RGPD pour comment le remplir)
OREJIME_TRANSLATIONS = {
    "fr": {
        "purposes": {
            "analytics": "Analyse",
            "security": "Sécurité"
        }
    }
}


#+----------------------------------------------------------------------------+
# Fiche espèce

# Afficher le graphique des altitudes. Affichage True/False
AFFICHAGE_GRAPH_ALTITUDES = True

# Afficher le graphique de la phénologie. Affichage True/False
AFFICHAGE_GRAPH_PHENOLOGIE = True

# Affiche ou non la barre "tout le terrtoire" sur les graphiques
# du nombre d'espèce des fiches zonages
AFFICHAGE_TOUT_TERRITOIRE_GRAPH = False

# Rang taxonomique qui fixe jusqu'à quel taxon remonte la filiation taxonomique (hierarchie dans la fiche d'identite : Famille, Ordre etc... )
LIMIT_RANG_TAXONOMIQUE_HIERARCHIE = 13

# Rang taxonomique qui fixe la limite de l'affichage de la fiche espece ou de la liste
# 35 = ESPECE
# On prend alors tout ce qui est inferieur ou egal a l'espece pour faire des fiches et ce qui est superieur pour les listes
LIMIT_FICHE_LISTE_HIERARCHY = 35

# Coupe le nom_vernaculaire à la 1ere virgule sur les fiches espèces
SPLIT_NOM_VERN = True

# Innformations espèces
# Un onglet sera affiché dans le bloc "Informations espèces" de la fiche espèce
# pour chaque code d'attribut indiqué dans la liste ci-dessous.
# L'onglet n'est affiché que s'il possède du contenu.
# L'ordre des onglets correspond à l'ordre des codes dans la liste.
TAXHUB_DISPLAYED_ATTR=['sinp_description', 'sinp_ecology', 'sinp_uses']

# Classes d'alitude
ALTITUDE_RANGES = [0,500,1000,1500,2000,2500,3000,3500,4000]

# Afficher les statuts des taxons (basés sur la BDC statuts). Affichage True/False
AFFICHAGE_STATUTS = True

# Configure quels statuts sont affichés et dans quel ordre.
# - il est possible de définir plusieurs filtres pour un groupe (pour grouper les listes rouges et les marqueurs znieff d'une même zone par exemple).
# - 'label' du groupe sera affiché devant l'ensemble des statuts de ce groupe. 'label' est optionnel.
# - les valeurs des propriétés `cd_type_statut` et `cd_sig` correspondent aux valeurs présentes dans la BDD `atlas.vm_bdc_statut`.
GROUPES_STATUTS = [
    {
        "label": "Monde",
        "filters": [
            {"cd_type_statut": "LRM", "cd_sig": "WORLD"}
        ]
    },
    {
        "label": "Europe",
        "filters": [
            {"cd_type_statut": "LRE", "cd_sig": "EUROPE"}
        ]
    },
    {
        "label": "France métropolitaine",
        "filters": [
            {"cd_type_statut": "LRN", "cd_sig": "TERFXFR"}
        ]
    },
    {
        "label": "Région",
        "filters": [
            {"cd_type_statut": "LRR", "cd_sig": "INSEER84"}
        ]
    },
    {
        "filters": [
            {"cd_type_statut": "ZDET", "cd_sig": "INSEED01"},
            {"cd_type_statut": "ZDET", "cd_sig": "INSEED03"},
            {"cd_type_statut": "ZDET", "cd_sig": "INSEED07"},
            {"cd_type_statut": "ZDET", "cd_sig": "INSEED15"},
            {"cd_type_statut": "ZDET", "cd_sig": "INSEED26"},
            {"cd_type_statut": "ZDET", "cd_sig": "INSEED38"},
            {"cd_type_statut": "ZDET", "cd_sig": "INSEED42"},
            {"cd_type_statut": "ZDET", "cd_sig": "INSEED43"},
            {"cd_type_statut": "ZDET", "cd_sig": "INSEED63"},
            {"cd_type_statut": "ZDET", "cd_sig": "INSEED69"},
            {"cd_type_statut": "ZDET", "cd_sig": "INSEED73"},
            {"cd_type_statut": "ZDET", "cd_sig": "INSEED74"},
        ]
    }
]

# Shows the names of the observers in the species sheets
DISPLAY_OBSERVERS = True


#+----------------------------------------------------------------------------+
# Fiche oragnismes

# Enable organism module : organism sheet + organism participation on species sheet
ORGANISM_MODULE = False


#+----------------------------------------------------------------------------+
# Fiches territoires et rang taxonomique

# Nombre d'éléments récupérés par page dans les listes de taxons
ITEMS_PER_PAGE = 50

## Permet d'afficher ou non les colonnes Protection et/ou Patrimonialité/Enjeux dans les listes de taxons

# Afficher le picto "protégé" sur les fiches espèces et les listes de taxons. Afficher les graphiques d'espèces protégées
PROTECTION = True

# Afficher les statistiques des espèces menacées
AFFICHAGE_MENACE = True

# Afficher la colonne "Patrimonialité" dans les listes de taxons (basé sur l'attribut TaxHub "patrimonial") et la customiser
# Pour masquer cette colonne, passer uniquement le paramètre à "False"
DISPLAY_PATRIMONIALITE = False

# Liste des types de territoire pour les fiches territoires ("code_area" dans "ref_geo.bib_area_type")
# ex : TYPE_TERRITOIRE_SHEET = ['COM', 'EPCI']
# Attention, si vous ajoutez des nouveaux zonages dans la BDD, veillez à remplir le champs "size_hierarchy" de la table "ref_geo.bib_areas_type".
# Ce champ sert au calcul de l'affichage ou non des observations sensibles sur des niveaux de zonage plus petits que leur géométrie de floutage
TYPE_TERRITOIRE_SHEET = ['COM', 'DEP', 'PNR', 'SINP']

# Types de zonage à afficher dans la liste des zonages parents dans la fiche territoire (à la fin de la barre de statistiques)
AREA_PARENTS_TYPE = ['DEP']

# Affiche ou non la barre "tout le territoire" sur les graphiques
# du nombre d'espèces des fiches territoire
AFFICHAGE_TOUT_TERRITOIRE_GRAPH = False

# Affichage de l'onglet "Présentation générale" dans les fiches territoires
AFFICHAGE_TAB_AREA_GENERAL_PRESENTATION = False

# Affichage du message concernant la sensibilité dans la page territoire
DISPLAY_ZONING_PAGE_SENSIBILITY_MESSAGE = True


#+----------------------------------------------------------------------------+
# Pages statiques

# Permet de lister les pages statiques souhaitées et de les afficher dynamiquement dans le menu sidebar
# Les pictos se limitent au Glyphicon proposés par Bootstrap (https://getbootstrap.com/docs/3.3/components/)
STATIC_PAGES = {
    'presentation': {
        'title': "Présentation",
        'picto': 'fa-question-circle',
        'order': 0,
        'template': 'static/custom/templates/presentation.html'
    }
}
