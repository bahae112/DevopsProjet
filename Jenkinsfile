pipeline {
    agent {
        docker { image 'docker:latest' }
    }

    environment {
        DOCKER_IMAGE = "django_app"
        CONTAINER_NAME = "django_container"
        GIT_REPO = "https://github.com/bahae112/DevopsProjet.git"
        DJANGO_PORT = "8000"
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    git "${GIT_REPO}"
                }
            }
        }

        stage('Build & Run Docker') {
            steps {
                script {
                    try {
                        sh """
                            docker build -t ${DOCKER_IMAGE} .
                            docker run -d --name ${CONTAINER_NAME} -p ${DJANGO_PORT}:8000 ${DOCKER_IMAGE}
                        """
                    } catch (Exception e) {
                        error "Build and Docker run failed: ${e.getMessage()}"
                    }
                }
            }
        }

        stage('Migrations & Collect Static') {
            steps {
                script {
                    try {
                        sh """
                            docker exec ${CONTAINER_NAME} python manage.py migrate
                            docker exec ${CONTAINER_NAME} python manage.py collectstatic --noinput
                        """
                    } catch (Exception e) {
                        error "Database migration or static files collection failed: ${e.getMessage()}"
                    }
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    try {
                        withSonarQubeEnv('sq1') {
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
                            git diff --cached --quiet || git commit -m "Update after SonarQube analysis"
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
                docker stop ${CONTAINER_NAME} || true
                docker rm ${CONTAINER_NAME} || true
                docker rmi ${DOCKER_IMAGE} || true
            """
        }
        failure {
            echo "Pipeline failed. Check logs for details."
        }
    }
}
