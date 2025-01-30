pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "myapp_image"
        CONTAINER_NAME = "myapp_container"
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    // Cloner le dépôt Git
                    git 'https://github.com/bahae112/DevopsProjet.git'
                }
            }
        }

        stage('Build & Run Docker') {
            steps {
                script {
                    // Construire l'image Docker et lancer le container
                    try {
                        sh """
                            docker build -t ${DOCKER_IMAGE} .
                            docker run -d --name ${CONTAINER_NAME} -p 8000:8000 ${DOCKER_IMAGE}
                        """
                    } catch (Exception e) {
                        error "Build and Docker run failed: ${e.getMessage()}"
                    }
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    // Exécution de l'analyse SonarQube
                    try {
                        withSonarQubeEnv(installationName: 'sq1') {
                            sh 'sonar-scanner'
                        }
                    } catch (Exception e) {
                        error "SonarQube analysis failed: ${e.getMessage()}"
                    }
                }
            }
        }

        stage('Push to GitHub') {
            steps {
                script {
                    // Effectuer le push vers GitHub après analyse SonarQube
                    try {
                        sh """
                            git add .
                            git diff --cached --quiet || git commit -m "Mise à jour après analyse SonarQube"
                            git push origin main
                        """
                    } catch (Exception e) {
                        error "Git push failed: ${e.getMessage()}"
                    }
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline executed successfully!"
        }
        failure {
            echo "Pipeline failed. Check logs for details."
        }
    }
}
