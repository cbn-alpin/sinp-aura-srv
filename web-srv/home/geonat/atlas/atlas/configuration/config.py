# -*- coding:utf-8 -*-

# Mettre l'application en mode debug ou pas
modeDebug = False

# Connexion de l'application à la BDD
# Remplacer user, monpassachanger, IPADRESSE (localhost si la BDD est sur le même serveur que l'application),
# eventuellement le port de la BDD et le nom de la BDD avec l'utilisateur qui a des droits de lecture sur les vues de l'atlas (user_pg dans settings.ini)
database_connection = "postgresql://<user>:<password>@10.0.1.20:5432/gnatlas"

#################################
#################################
### CUSTOMISATION APPLICATION ###
#################################
#################################

# Nom de la structure
STRUCTURE = "SINP AURA"

# Nom de l'application
NOM_APPLICATION = "Atlas - Biodiversité-Auvergne-Rhône-Alpes"

# URL de l'application depuis la racine du domaine
# ex "/atlas" pour une URL: http://mon-domaine/atlas OU "" si l'application est accessible à la racine du domaine
URL_APPLICATION = ""


###########################
###### CARTOGRAPHIE #######
###########################

# Clé IGN si vous utilisez l'API Geoportail pour afficher les fonds cartographiques
#IGNAPIKEY = '***REMOVED***'

# Configuration des cartes (centre du territoire, couches CARTE et ORTHO, échelle par défaut...)
MAP = {
    'LAT_LONG': [43.96387, 6.06216],
    'FIRST_MAP': {
            'url' : '//{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png',
            'attribution' : '&copy OpenStreetMap',
            'tileName' : 'OSM'
    },
    'SECOND_MAP' : {'url' :'//a.tile.opentopomap.org/{z}/{x}/{y}.png',
            'attribution' : '&copy OpenStreetMap-contributors, SRTM | Style: &copy OpenTopoMap (CC-BY-SA)',
            'tileName' : 'OTM'
    },
    #'SECOND_MAP' : {'url' :'https://gpp3-wxs.ign.fr/'+IGNAPIKEY+'/geoportail/wmts?LAYER=ORTHOIMAGERY.ORTHOPHOTOS&EXCEPTIONS=text/xml&FORMAT=image/jpeg&SERVICE=WMTS&VERSION=1.0.0&REQUEST=GetTile&STYLE=normal&TILEMATRIXSET=PM&TILEMATRIX={z}&TILEROW={y}&TILECOL={x}',
    #        'attribution' : '&copy; <a href="http://www.ign.fr/">IGN</a>',
    #        'tileName' : 'Ortho IGN'
    #},
    'ZOOM' : 8,
    # Pas du slider sur les annees d'observations: 1 = pas de 1 an sur le slider
    'STEP': 1,
    # Couleur et épaisseur des limites du territoire
    'BORDERS_COLOR': '#000000',
    'BORDERS_WEIGHT': 3,
    'ENABLE_SLIDER': True
}

# Affichage des observations par maille ou point
# True = maille / False = point
AFFICHAGE_MAILLE = True

# Carte de la page d'accueil: observations des 'x' derniers jours. Bien mettre en anglais et non accordé
NB_DAY_LAST_OBS = '1 year'
# Texte à afficher pour décrire la cartographie des 'dernières observations'
TEXT_LAST_OBS = 'Les observations de l\'année écoulée |'
# Carte de la fiche commune: nombre des 'x' dernières observations affichées
NB_LAST_OBS=500


###########################
###### PAGE ACCUEIL #######
###########################

# Bloc d'introduction presentant l'atlas. Affichage True/False
AFFICHAGE_INTRODUCTION = True

# Afficher le Footer sur toutes les pages (static/custom/templates/footer.html)
AFFICHAGE_FOOTER = True

# Bloc de statistiques globales. Affichage True/False
AFFICHAGE_STAT_GLOBALES = True

# Bloc avec carte et liste des dernières observations. Affichage True/False
AFFICHAGE_DERNIERES_OBS = False

# Bloc avec espèces à voir en ce moment. Affichage True/False
AFFICHAGE_EN_CE_MOMENT = True

# Bloc stats par rangs
AFFICHAGE_RANG_STAT = True
COLONNES_RANG_STAT = 4
RANG_STAT_FR = ['Faune vertébrée', 'Faune invertébrée', 'Plantes', 'Champignons']
RANG_STAT = [{'phylum': ["Chordata"]}, {'phylum': ["Arthropoda", "Mollusca", "Annelida", "Cnidaria", "Platyhelminthes"]}, {'regne': ["Plantae"]}, {'regne': ["Fungi"]}]


############################
####### FICHE ESPECE #######
############################

# Rang taxonomique qui fixe jusqu'à quel taxon remonte la filiation taxonomique (hierarchie dans la fiche d'identite : Famille, Ordre etc... )
LIMIT_RANG_TAXONOMIQUE_HIERARCHIE = 13

# Rang taxonomique qui fixe la limite de l'affichage de la fiche espece ou de la liste
# 35 = ESPECE
# On prend alors tout ce qui est inferieur ou egal a l'espece pour faire des fiches et ce qui est superieur pour les listes
LIMIT_FICHE_LISTE_HIERARCHY = 35

# URL d'accès aux photos et autres médias (URL racine). Par exemple l'url d'accès à Taxhub
# Cette url sera cachée aux utilisateurs de l'atlas
REMOTE_MEDIAS_URL = "https://taxons.biodiversite-aura.fr/"
# Racine du chemin des fichiers médias stockés dans le champ "chemin" de "atlas.vm_medias"
# Seule cette partie de l'url sera visible pour les utilisateurs de l'atlas
REMOTE_MEDIAS_PATH = "static/medias/"

# URL de TaxHub (pour génération à la volée des vignettes des images).
# Si le service Taxhub n'est pas utilisé, commenter la variable
REDIMENSIONNEMENT_IMAGE = True
# si redimmentionnement image = True, indiquer l'URL de taxhub
TAXHUB_URL = "https://taxons.biodiversite-aura.fr"

# Coupe le nom_vernaculaire à la 1ere virgule sur les fiches espèces
SPLIT_NOM_VERN = True

#############################
#### PAGES STATIQUES #####
#############################

# Permet de lister les pages statiques souhaitées et de les afficher dynamiquement dans le menu sidebar
# Les pictos se limitent au Glyphicon proposés par Bootstrap (https://getbootstrap.com/docs/3.3/components/)
STATIC_PAGES = {
    'presentation': {'title': "Présentation", 'picto': 'glyphicon-question-sign', 'order': 0, 'template': 'static/custom/templates/presentation.html'}
}

