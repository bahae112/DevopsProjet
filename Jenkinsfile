pipeline {
    agent any

    environment {
        WORKDIR = "/mnt/c/ProgramData/Jenkins/.jenkins/workspace/devopsTestSonarDocker/"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/bahae112/DevopsProjet.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t my-docker-image ${WORKDIR}"
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    sh "docker run -w ${WORKDIR} -v ${WORKDIR}:${WORKDIR} my-docker-image"
                }
            }
        }

        stage('Cleanup') {
            steps {
                script {
                    sh "docker system prune -f"
                }
            }
        }
    }
}
