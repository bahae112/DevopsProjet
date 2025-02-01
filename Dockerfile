# Utiliser une image Python
FROM python:3.9

# Definir le repertoire de travail
WORKDIR /app

# Copier les fichiers necessaires
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

COPY . .

# Exposer le port de Django (par defaut : 8000)
EXPOSE 8000

# Lancer le serveur Django
CMD ["sh", "-c", "python myapp/manage.py migrate && python myapp/manage.py runserver 0.0.0.0:8000"]
