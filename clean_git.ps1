# Supprimer les fichiers .apk et le dossier build de l'historique git
java -jar .\bfg-1.15.0.jar --delete-files "*.apk" --delete-folders build

# Nettoyage des refs Git
git reflog expire --expire=now --all
git gc --prune=now --aggressive

# Push forcé
git push origin main --force
