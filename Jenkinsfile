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
                    // Assurez-vous que l'URL et la branche sont corrects
                    git url: 'https://github.com/monprojet.git', branch: 'main'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    try {
                        // Construction de l'image Docker
                        sh "docker build -t ${DOCKER_IMAGE} ."
                    } catch (Exception e) {
                        error "Image build failed: ${e.getMessage()}"
                    }
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    try {
                        // Exécuter le conteneur Docker en mode détaché
                        sh """
                            docker run -d -p 8080:8080 -p 50000:50000 --name ${CONTAINER_NAME} ${DOCKER_IMAGE}
                        """
                    } catch (Exception e) {
                        error "Docker container run failed: ${e.getMessage()}"
                    }
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
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
            sh """
                docker rm -f ${CONTAINER_NAME} || true
                docker rmi ${DOCKER_IMAGE} || true
            """
        }
        failure {
            echo "Pipeline failed. Check logs for details."
        }
    }
}
