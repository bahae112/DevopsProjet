pipeline {
    agent {
        docker { image 'docker:latest' }
    }

    environment {
        DOCKER_IMAGE = "myapp_image"
        CONTAINER_NAME = "myapp_container"
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    git 'https://github.com/bahae112/DevopsProjet.git'
                }
            }
        }

        stage('Build & Run Docker') {
            steps {
                script {
                    try {
                        // Construire l'image Docker et lancer le container
                        sh """
                            docker build -t ${DOCKER_IMAGE} .
                            docker run -d -t -w 'C:/ProgramData/Jenkins/.jenkins/workspace/devopsTestSonarDocker/' -v 'C:/ProgramData/Jenkins/.jenkins/workspace/devopsTestSonarDocker/:/devopsTestSonarDocker/' -v 'C:/ProgramData/Jenkins/.jenkins/workspace/devopsTestSonarDocker@tmp/:/devopsTestSonarDocker@tmp/' ${DOCKER_IMAGE}
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
