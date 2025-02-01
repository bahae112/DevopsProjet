pipeline {
    agent any  // Agent Jenkins sur Windows

    environment {
        IMAGE_NAME      = 'my-image'
        DOCKERFILE_PATH = 'Dockerfile'
        GIT_URL         = 'https://github.com/bahae112/DevopsProjet.git'
        BRANCH_NAME     = 'main'
        CONTAINER_NAME  = 'my-container'
        HOST_PORT       = '9090'
        CONTAINER_PORT  = '8000'
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Clonage du repository'
                git branch: "${BRANCH_NAME}", url: "${GIT_URL}"
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Construction de l\'image Docker via WSL'
                // La commande s'exécute dans l'environnement Linux de WSL2
                bat "wsl docker build -t ${IMAGE_NAME} -f ${DOCKERFILE_PATH} ."
            }
        }

        stage('Save Docker Image Locally') {
            steps {
                echo 'Sauvegarde de l\'image Docker en local via WSL'
                bat "wsl docker save -o ${IMAGE_NAME}.tar ${IMAGE_NAME}"
            }
        }

        stage('Create Container') {
            steps {
                echo 'Création et lancement du conteneur Docker via WSL'
                // Suppression éventuelle d'un conteneur existant portant le même nom
                bat "wsl docker rm -f ${CONTAINER_NAME} || echo 'Aucun conteneur existant à supprimer'"
                // Lancer le conteneur en mode détaché en mappant le port 9090 de l'hôte sur le port 8000 du conteneur
                bat "wsl docker run -d -p ${HOST_PORT}:${CONTAINER_PORT} --name ${CONTAINER_NAME} ${IMAGE_NAME}"
            }
        }
    }
    
    post {
        always {
            echo "Nettoyage de l'environnement de build"
        }
    }
}
