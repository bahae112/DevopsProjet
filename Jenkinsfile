pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "myapp_image"
        CONTAINER_NAME = "myapp_container"
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/bahae112/DevopsProjet.git'
            }
        }

        stage('Build & Run Docker') {
            steps {
                script {
                    sh """
                        docker build -t ${DOCKER_IMAGE} .
                        docker run -d --name ${CONTAINER_NAME} -p 8000:8000 ${DOCKER_IMAGE}
                    """
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    withSonarQubeEnv(installationName: 'sq1') {
                        sh 'sonar-scanner'
                    }
                }
            }
        }

        stage('Push to GitHub') {
            steps {
                script {
                    sh """
                        git add .
                        git diff --cached --quiet || git commit -m "Mise à jour après analyse SonarQube"
                        git push origin main
                    """
                }
            }
        }
    }
}
