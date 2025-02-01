pipeline {
    agent any

    environment {
        IMAGE_NAME = 'my-image'
        REGISTRY = 'docker.io'
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

        stage('Check if Image Exists') {
            steps {
                script {
                    def imageExists = sh(script: "docker images -q ${IMAGE_NAME}", returnStdout: true).trim()
                    if (imageExists) {
                        echo "Image ${IMAGE_NAME} already exists, skipping build."
                    } else {
                        echo "Image ${IMAGE_NAME} not found, building the image."
                        // Build the image if not found
                        sh "docker build -t ${IMAGE_NAME} -f ${DOCKERFILE_PATH} ."
                        // Save image only after build
                        sh "docker save -o ${IMAGE_NAME}.tar ${IMAGE_NAME}"
                    }
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                echo 'Running Docker container'
                sh "docker run -d --name ${IMAGE_NAME}-container ${IMAGE_NAME}"
            }
        }

        stage('Push to GitHub') {
            steps {
                echo 'Pushing changes to GitHub'
                sh """
                git config --global user.email "your-email@example.com"
                git config --global user.name "Your Name"
                git add .
                git commit -m 'Automated commit from Jenkins'
                git push origin ${BRANCH_NAME}
                """
            }
        }
    }
}
