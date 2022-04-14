# Database settings
SQLALCHEMY_DATABASE_URI = "postgresql://geonatadmin:<password>@10.0.1.20:5432/geonature2db"
SQLALCHEMY_TRACK_MODIFICATIONS = False
URL_APPLICATION ='https://gestion.biodiversite-aura.fr'

SECRET_KEY = '<super-secret-key>'

# Authentification crypting method (hash or md5)
PASS_METHOD = 'hash'

# Choose if you also want to fill MD5 passwords (lower security)
# Only useful if you have old application that use MD5 passwords
FILL_MD5_PASS = False

COOKIE_EXPIRATION = 3600
COOKIE_AUTORENEW = True

# SERVER
PORT = 5001
DEBUG = False

ACTIVATE_API = True
ACTIVATE_APP = True
