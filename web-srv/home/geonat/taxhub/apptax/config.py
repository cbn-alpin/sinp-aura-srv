'''
TaxHub global settings file
'''
DEBUG=False

# Log level
# To enable SQLAlchemy logging, uncomment the lines below.
#import logging
#logging.basicConfig()
#logging.getLogger('sqlalchemy.engine').setLevel(logging.INFO)

# Database settings
SQLALCHEMY_DATABASE_URI = "postgresql://geonatadmin:<password>@10.0.1.20:5432/geonature2db"
SQLALCHEMY_TRACK_MODIFICATIONS = False

# APPLICATION_ROOT = '/'
# Set this to 'https' if you use encryption
PREFERRED_URL_SCHEME = 'https'

SESSION_TYPE = 'filesystem'
SECRET_KEY = '<super-secret-key>'
COOKIE_EXPIRATION = 3600
COOKIE_AUTORENEW = True

# File
UPLOAD_FOLDER = 'medias'

# Authentification crypting method (hash or md5)
PASS_METHOD='hash'
