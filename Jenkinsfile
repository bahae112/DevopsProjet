pipeline {
    agent any

    environment {
        GIT_URL = 'https://github.com/bahae112/DevopsProjet.git'
        BRANCH_NAME = 'main'
        SONARQUBE_SERVER = 'http://localhost:9000'  // URL de ton serveur SonarQube
        SONARQUBE_SCANNER_HOME = '/usr/local/sonar-scanner'  // Chemin du SonarQube Scanner local
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Clonage du repository depuis GitHub'
                git branch: "${BRANCH_NAME}", url: "${GIT_URL}"
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    // Lancer l'analyse SonarQube localement
                    withSonarQubeEnv('sonarqube') {
                        bat """
                        ${SONARQUBE_SCANNER_HOME}/bin/sonar-scanner \
                        -Dsonar.sources=. \
                        -Dsonar.host.url=${SONARQUBE_SERVER} \
                        -Dsonar.login=${SONARQUBE_TOKEN}
                        """
                    }
                }
            }
        }

        stage('Push to GitHub') {
            steps {
                echo 'Poussée des changements vers GitHub'
                bat "git push origin ${BRANCH_NAME}"
            }
        }
    }

    post {
        always {
            echo "Nettoyage de l'environnement de build"
        }
    }
}
