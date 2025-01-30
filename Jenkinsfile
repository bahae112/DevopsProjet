
pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'myapp_image'
        DOCKER_TAG = 'latest'
        DOCKER_REGISTRY = 'dockerhub'
        GITHUB_REPO = 'https://github.com/bahae112/DevopsProjet.git'
    }
    stages {
        stage('Checkout Repository') {
            steps {
                script {
                    // Vérification du code source depuis le dépôt Git
                    try {
                        git url: GITHUB_REPO
                    } catch (Exception e) {
                        error "Couldn't find any revision to build. Verify the repository and branch configuration for this job. ${e.getMessage()}"
                    }
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    try {
                        // Construire l'image Docker en utilisant PowerShell
                        powershell '''
                            docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                        '''
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
                        // Lancer le conteneur Docker
                        bat '''
                            docker run -d -p 8080:8080 -p 50000:50000 --name jenkins-container ${DOCKER_IMAGE}:${DOCKER_TAG}
                        '''
                    } catch (Exception e) {
                        error "Failed to run Docker container: ${e.getMessage()}"
                    }
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    try {
                        // Effectuer l'analyse SonarQube
                        bat '''
                            sonar-scanner
                        '''
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
                        // Push vers GitHub après l'analyse SonarQube
                        bat '''
                            git add .
                            git commit -m "Updated changes after Docker build and SonarQube analysis"
                            git push origin main
                        '''
                    } catch (Exception e) {
                        error "GitHub push failed: ${e.getMessage()}"
                    }
                }
            }
        }

    }

    post {
        always {
            echo 'Pipeline execution completed.'
        }
        success {
            echo 'Pipeline succeeded.'
        }
        failure {
            echo 'Pipeline failed.'
        }
    }
}
