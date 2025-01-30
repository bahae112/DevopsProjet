pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'my-django-app' // Nom de l'image Docker
        DOCKER_REGISTRY = 'docker.io'  // Registry Docker
        GIT_REPO = 'https://github.com/bahae112/DevopsProjet.git'  // Référentiel GitHub
        BRANCH_NAME = 'main'           // Branche Git à utiliser
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Cloning the repository...'
                git url: "${GIT_REPO}", branch: "${BRANCH_NAME}"
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo 'Building the Docker image...'
                    // Construire l'image Docker
                    sh 'docker build -t ${DOCKER_IMAGE} .'
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    echo 'Running Docker container...'
                    // Lancer le conteneur Docker
                    sh 'docker run -d -p 8000:8000 ${DOCKER_IMAGE}'
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                echo 'Running SonarQube analysis...'
                // Exécuter l'analyse SonarQube (si nécessaire)
                // Assurez-vous d'avoir une configuration SonarQube dans Jenkins
                sh 'mvn sonar:sonar'
            }
        }

        stage('Push Docker Image to Registry') {
            steps {
                script {
                    echo 'Pushing the Docker image to registry...'
                    // Pousser l'image Docker vers un registry
                    sh 'docker tag ${DOCKER_IMAGE} ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:latest'
                    sh 'docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:latest'
                }
            }
        }

        stage('Push to GitHub') {
            steps {
                script {
                    echo 'Pushing changes to GitHub...'
                    // Pousser les modifications sur GitHub
                    sh 'git add .'
                    sh 'git commit -m "Automated changes after build"'
                    sh 'git push origin ${BRANCH_NAME}'
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up...'
            // Nettoyage après l'exécution (par exemple, supprimer les conteneurs Docker)
            sh 'docker ps -q | xargs docker stop'
            sh 'docker ps -a -q | xargs docker rm'
        }

        success {
            echo 'Build and deployment succeeded!'
        }

        failure {
            echo 'Build or deployment failed.'
        }
    }
}
