pipeline {
    agent any

    environment {
        IMAGE_NAME = 'my-image'
        REGISTRY = 'my-registry'
        DOCKERFILE_PATH = 'Dockerfile'
        GIT_URL = 'https://github.com/bahae112/DevopsProjet.git'
        BRANCH_NAME = 'main'  // Spécifiez ici la branche correcte
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Cloning repository'
                git branch: "${BRANCH_NAME}", url: "${GIT_URL}"
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image'
                bat "docker build -t ${IMAGE_NAME} -f ${DOCKERFILE_PATH} ."
            }
        }

        stage('Save Docker Image Locally') {
            steps {
                echo 'Saving Docker image locally'
                bat "docker save -o ${IMAGE_NAME}.tar ${IMAGE_NAME}"
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    // Utilise le nom de l'installation SonarQube que tu as configurée (par exemple, 'sq1')
                    scannerHome = tool name: 'sq1', type: 'SonarQubeScanner'
                    withSonarQubeEnv('sq1') {
                        // Exécute le scanner SonarQube
                        bat "${scannerHome}/bin/sonar-scanner"
                    }
                }
            }
        }


        stage('Push Docker Image to Registry') {
            steps {
                echo 'Pushing Docker image to registry'
                bat "docker push ${REGISTRY}/${IMAGE_NAME}"
            }
        }

        stage('Push to GitHub') {
            steps {
                echo 'Pushing changes to GitHub'
                bat "git push origin ${BRANCH_NAME}"
            }
        }
    }
}
