# -*- coding:utf-8 -*-

# Connexion de l'application à la BDD
# Remplacer user, monpassachanger, IPADRESSE (localhost si la BDD est sur le même serveur que l'application),
# eventuellement le port de la BDD et le nom de la BDD avec l'utilisateur qui a des droits de lecture sur les vues de l'atlas (user_pg dans settings.ini)
SQLALCHEMY_DATABASE_URI = "postgresql://geonatatlas:<password>@0.0.0.0:5432/gnatlas"


# Ce paramètre permet de configurer la connexion de SQLAlchemy avec la base de données
# Les paramètres de configuration de la connexion doivent correspondre à ceux utilisé dans la fonction `create_engine`
# de SQLAlchemy : https://docs.sqlalchemy.org/en/14/core/engines.html#sqlalchemy.create_engine
SQLALCHEMY_ENGINE_OPTIONS = {
    "pool_recycle": 30,
    "pool_size": 35,
    "pool_timeout": 30,
    "pool_pre_ping": True,
    "pool_use_lifo": True,
    "connect_args": {
        "connect_timeout": 10,
        "application_name": "preprod-atlas-v2",
        "keepalives": 1,
        "keepalives_idle": 30,
        "keepalives_interval": 10,
        "keepalives_count": 5,
    },
}

# -------------------------------------------------------------------------------
# CUSTOMISATION APPLICATION

# Nom de la structure
STRUCTURE = "SINP AURA"

# Nom de l'application
NOM_APPLICATION = "Biodiv'AURA Atlas v2 - Pré-Prod"

# URL de l'application depuis la racine du domaine
# ex "/atlas" pour une URL: http://mon-domaine/atlas OU "" si l'application est accessible à la racine du domaine
#URL_APPLICATION = "https://atlas.biodiversite-auvergne-rhone-alpes.fr"
URL_APPLICATION = ""

# URL de taxhub
TAXHUB_URL = "https://taxons.biodiversite-aura.fr"

# Racine du chemin des fichiers médias stockés dans le champ "chemin" de "atlas.vm_medias"
# Seule cette partie de l'url sera visible pour les utilisateurs de l'atlas
REMOTE_MEDIAS_PATH = "static/medias/"

SECRET_KEY = '<secret-key>'

# Temps en seconde de la durée du cache
# utilisé pour les statistiques de la page d'accueil (stats global et rang taxonomique)
# à synchroniser avec le raffraichissement des VM
CACHE_TIMEOUT = 31536000

# -------------------------------------------------------------------------------
# Multilingual

# Default language, also used when multilingual is disabled
DEFAULT_LANGUAGE = 'fr'

# Activate multilingual
MULTILINGUAL = False

# Available languages
# Don't delete, even if you disable MULTILINGUAL
# You need to add your own default language (DEFAULT_LANGUAGE) here if it's not present
# Check documentation to add another language
LANGUAGES = {
    'en': {
        'name' : 'English',
        'flag_icon' : 'flag-icon-gb',
        'months' : ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
        },
    'fr': {
        'name' : 'Français',
        'flag_icon' : 'flag-icon-fr',
        'months' : ['Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin', 'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Decembre']
        },
    'it': {
        'name' : 'Italiano',
        'flag_icon' : 'flag-icon-it',
        'months' : ['Gennaio', 'Febbraio', 'Marzo', 'Aprile', 'Maggio', 'Giugno', 'Luglio', 'Agosto', 'Settembre', 'Ottobre', 'Novembre', 'Dicembre']
        }
}

# -------------------------------------------------------------------------------
# CARTOGRAPHIE

# Configuration des cartes (centre du territoire, couches CARTE et ORTHO, échelle par défaut...)
MAP = {
    'LAT_LONG': [45.29619, 4.66072],
    'FIRST_MAP': {
            'url' : '//{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png',
            'attribution' : '&copy OpenStreetMap',
            'tileName' : 'OSM'
    },
    'SECOND_MAP' : {
        'url' : '//data.geopf.fr/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&STYLE=normal&TILEMATRIXSET=PM&TILEMATRIX={z}&TILEROW={y}&TILECOL={x}&LAYER=HR.ORTHOIMAGERY.ORTHOPHOTOS&FORMAT=image/jpeg',
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
        "fill": False,
        "fillColor": '#020202',
        "fillOpacity": 0.3
    },
    'ENABLE_SLIDER': True,
    # Pas du slider sur les annees d'observations: 1 = pas de 1 an sur le slider
    'STEP': 10,
    'ENABLE_SCALE': True
}

# Affichage des observations par maille ou point
# True = maille / False = point
AFFICHAGE_MAILLE = False

# Si affichage en mailles, il est possible de surcharger certains elements dans le selecteur de couche.
# Doc : https://leafletjs.com/reference.html#path-option
AFFICHAGE_COUCHES_MAP = {
    "M1": {
        "label": "Mailles 1 km",
        "selected": True,
        "fillOpacity": 0.4,
        "fillOpacityHover": 0.4,
        "weight": 1,
        "weightHover": 2,
        "strokeOpacity": 0.75,
        "strokeColor": "black",
        "strokeColorHover": "green",
    },
    "M2": {
        "label": "Mailles 2 km",
        "selected": True,
        "fillOpacity": 0.4,
        "fillOpacityHover": 0.4,
        "weight": 1,
        "weightHover": 2,
        "strokeOpacity": 0.75,
        "strokeColor": "black",
        "strokeColorHover": "pink",
    },
    "M5": {
        "label": "Mailles 5Km",
        "selected": True,
        "fillOpacity": 0.6,
        "fillOpacityHover": 0.5,
        "weight": 1,
        "weightHover": 2,
        "strokeOpacity": 1,
        "strokeColor": "white",
        "strokeColorHover": "purple",
    },
    "M10": {
        "label": "Mailles 10Km",
        "selected": True,
        "fillOpacity": 0.6,
        "fillOpacityHover": 0.5,
        "weight": 1,
        "weightHover": 2,
        "strokeOpacity": 1,
        "strokeColor": "white",
        "strokeColorHover": "purple",
    },
    "COM": {
        "label": "Communes",
        "selected": True,
        "fillOpacity": 0.5,
    },
}

# Ouvrir le widget par défaut de legende.
DEFAULT_LEGEND_DISPLAY = False


# -------------------------------------------------------------------------------
# PAGE ACCUEIL

# Bloc d'introduction presentant l'atlas. Affichage True/False
AFFICHAGE_INTRODUCTION = True

# Afficher le Footer sur toutes les pages (static/custom/templates/footer.html)
AFFICHAGE_FOOTER = True

# Bloc de statistiques globales. Affichage True/False
AFFICHAGE_STAT_GLOBALES = True

# Affiche une carte de tous les taxons du territoire
AFFICHAGE_TERRITOIRE_OBS = False

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
AFFICHAGE_NOUVELLES_ESPECES = True

# Bloc stats par rangs
AFFICHAGE_RANG_STAT = True
COLONNES_RANG_STAT = 4
RANG_STAT_FR = ['Faune vertébrée', 'Faune invertébrée', 'Plantes', 'Champignons']
RANG_STAT = [{'phylum': ["Chordata"]}, {'phylum': ["Arthropoda", "Mollusca", "Annelida", "Cnidaria", "Platyhelminthes"]}, {'regne': ["Plantae"]}, {'regne': ["Fungi"]}]

# Afficher le lien "données personnelles" dans le footer
AFFICHAGE_RGPD = True

# Liste des application dont "orejime" controle la dépose de cookie
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

# traduction orejime (voir la doc cookie et RGPD pour comment le remplir)
OREJIME_TRANSLATIONS = {}


# -------------------------------------------------------------------------------
# FICHE ESPECE

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

# URL de TaxHub (pour génération à la volée des vignettes des images).
# Si le service Taxhub n'est pas utilisé, commenter la variable
REDIMENSIONNEMENT_IMAGE = True

# Coupe le nom_vernaculaire à la 1ere virgule sur les fiches espèces
SPLIT_NOM_VERN = True

# Id des attribus descriptifs des taxons de la table vm_cor_taxon_attribut
TAXHUB_DISPLAYED_ATTR = ['sinp_description', 'sinp_ecology', 'sinp_uses']

# Rangs d'altitude pour le graphique de répartition altitudinale
ALTITUDE_RANGES = [0,250,500,750,1000,1500,2000,2500,3000,3500,4000]

# Afficher les statuts de conservation. Affichage True/False
AFFICHAGE_STATUTS = True

# Afficher le nom des observateurs sur la fiche espèce
DISPLAY_OBSERVERS = True


# -------------------------------------------------------------------------------
# FICHE ORGANISME

# Activer le module organisme : fiche organisme + encart participation
# sur fiche espèce et territoire.
ORGANISM_MODULE = True


# -------------------------------------------------------------------------------
# FICHE "AREA" ET RANG TAXONOMIQUE

# Permet d'afficher ou non les colonnes Protection et/ou Patrimonialité/Enjeux dans les listes de taxons
# Se basent sur les champs "atlas.vm_taxons.protection_stricte"` (oui/non) et "atlas.vm_taxons.patrimonial"

# Afficher ou non la colonne Protection dans les listes de taxons (basé sur le champs "protection_stricte")
PROTECTION = True

# Afficher ou non la colonne Patrimonialité dans les listes de taxons (basé sur le champs "patrimonial") et la customiser
# Pour masquer cette colonne, passer uniquement le paramètre à "False"
DISPLAY_PATRIMONIALITE = False

# Pour customiser l'affichage de cette colonne (label affiché, valeurs du champs et leur affichage) :
PATRIMONIALITE = {
    "label": "Patrimoniale",
    "label_pluriel": "Patrimoniales",
    "config": {
        "oui": {"icon": "custom/images/logo_patrimonial.png", "text": "Ce taxon est patrimonial"}
    },
}

# Carte de la fiche commune: nombre des 'x' dernières observations affichées
NB_LAST_OBS=500

# Liste des type de territoire pour les fichies territoires (code bib_area_type)
# ex : TYPE_TERRITOIRE_SHEET = ['COM', 'EPCI']
TYPE_TERRITOIRE_SHEET = ['COM', 'PNR', 'DEP', 'SINP']

# Affichage de l'onglet "Présentation générale" dans les fiches territoires
AFFICHAGE_TAB_AREA_GENERAL_PRESENTATION = False


# -------------------------------------------------------------------------------
# PAGES STATIQUES

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
