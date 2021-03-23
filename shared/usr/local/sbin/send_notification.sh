#!/bin/bash
# Script notifiant les connexions au serveur
echo "Connexion sur $(hostname) le $(date +%Y-%m-%d) à $(date +%H:%M)"
echo "Utilisateur: $USER"
echo
finger
