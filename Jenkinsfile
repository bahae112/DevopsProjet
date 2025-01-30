pipeline {
    agent {
        docker {
            image 'docker:latest'
            args '-v /var/run/docker.sock:/var/run/docker.sock' // Permet d'utiliser Docker dans le conteneur Jenkins
        }
    }

    environment {
        DOCKER_IMAGE = "myapp_image"
        CONTAINER_NAME = "myapp_container"
        SONAR_PROJECT_KEY = "DevopsProjet"
        GIT_REPO = "https://github.com/bahae112/DevopsProjet.git"
        GIT_BRANCH = "main"
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    echo "📥 Clonage du dépôt Git..."
                    git branch: "${GIT_BRANCH}", url: "${GIT_REPO}"
                }
            }
        }

        stage('Build & Run Docker') {
            steps {
                script {
                    echo "🐳 Construction et exécution du conteneur Docker..."
                    try {
                        sh """
                            docker build -t ${DOCKER_IMAGE} .
                            docker run -d --name ${CONTAINER_NAME} -p 8000:8000 ${DOCKER_IMAGE}
                        """
                    } catch (Exception e) {
                        error "❌ Échec du build et de l'exécution de Docker : ${e.getMessage()}"
                    }
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    echo "🔍 Exécution de l'analyse SonarQube..."
                    try {
                        withSonarQubeEnv('sq1') {
                            sh """
                                sonar-scanner \
                                    -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
                                    -Dsonar.sources=. \
                                    -Dsonar.host.url=http://sonarqube:9000 \
                                    -Dsonar.login=admin \
                                    -Dsonar.password=admin
                            """
                        }
                    } catch (Exception e) {
                        error "❌ Échec de l'analyse SonarQube : ${e.getMessage()}"
                    }
                }
            }
        }

        stage('Push to GitHub') {
            steps {
                script {
                    echo "🚀 Envoi des modifications vers GitHub..."
                    try {
                        sh """
                            git add .
                            if ! git diff --cached --quiet; then
                                git commit -m '🔄 Mise à jour après analyse SonarQube'
                                git push origin ${GIT_BRANCH}
                            else
                                echo "Aucune modification détectée, aucun commit nécessaire."
                            fi
                        """
                    } catch (Exception e) {
                        error "❌ Échec du push Git : ${e.getMessage()}"
                    }
                }
            }
        }
    }

    post {
        always {
            script {
                echo "🧹 Nettoyage des ressources Docker..."
                sh """
                    docker stop ${CONTAINER_NAME} || true
                    docker rm -f ${CONTAINER_NAME} || true
                    docker rmi ${DOCKER_IMAGE} || true
                """
            }
        }
        success {
            echo "✅ Pipeline exécuté avec succès !"
        }
        failure {
            echo "❌ Échec du pipeline, consultez les logs pour plus de détails."
        }
    }
}
