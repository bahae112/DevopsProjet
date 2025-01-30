<<<<<<< HEAD
pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = "myapp_image"
        CONTAINER_NAME = "myapp_container"
        SONARQUBE_SERVER = "http://localhost:9000"
        SONARQUBE_TOKEN = "votre_token_sonar"
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/votre_nom_utilisateur/votre_repo.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t ${DOCKER_IMAGE} .'
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    sh 'docker run -d --name ${CONTAINER_NAME} -p 8000:8000 ${DOCKER_IMAGE}'
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    sh """
                        docker run --rm --network=host sonarsource/sonar-scanner-cli \
                        -Dsonar.projectKey=myapp \
                        -Dsonar.sources=. \
                        -Dsonar.host.url=${SONARQUBE_SERVER} \
                        -Dsonar.login=${SONARQUBE_TOKEN}
                    """
                }
            }
        }

        stage('Publish to GitHub') {
            steps {
                script {
                    sh 'git add .'
                    sh 'git commit -m "Mise à jour après analyse SonarQube"'
                    sh 'git push origin main'
                }
            }
        }
    }
}
=======
pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = "myapp_image"
        CONTAINER_NAME = "myapp_container"
        SONARQUBE_SERVER = "http://localhost:9000"
        SONARQUBE_TOKEN = "votre_token_sonar"
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/votre_nom_utilisateur/votre_repo.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t ${DOCKER_IMAGE} .'
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    sh 'docker run -d --name ${CONTAINER_NAME} -p 8000:8000 ${DOCKER_IMAGE}'
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    sh """
                        docker run --rm --network=host sonarsource/sonar-scanner-cli \
                        -Dsonar.projectKey=myapp \
                        -Dsonar.sources=. \
                        -Dsonar.host.url=${SONARQUBE_SERVER} \
                        -Dsonar.login=${SONARQUBE_TOKEN}
                    """
                }
            }
        }

        stage('Publish to GitHub') {
            steps {
                script {
                    sh 'git add .'
                    sh 'git commit -m "Mise à jour après analyse SonarQube"'
                    sh 'git push origin main'
                }
            }
        }
    }
}
>>>>>>> c7e7e2ee416ee59c9b554ee78ee372e2e3e38a58
