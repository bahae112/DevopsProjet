pipeline {
    agent any

    environment {
        IMAGE_NAME = 'my-image'
        REGISTRY = 'docker.io'
        DOCKERFILE_PATH = 'Dockerfile'
        GIT_URL = 'https://github.com/bahae112/DevopsProjet.git'
        BRANCH_NAME = 'main'  // Spécifiez ici la branche correcte
        SONAR_HOST_URL = "http://localhost:9000"
        SONAR_AUTH_TOKEN = credentials('sonarqube')
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Cloning repository'
                git branch: "${BRANCH_NAME}", url: "${GIT_URL}"
            }
        }

        stage('Run SonarQube Analysis') {
            steps {
                echo 'Running SonarQube analysis'
                sh """
                docker run --rm \
                    --network=host \
                    -e SONAR_HOST_URL=${SONAR_HOST_URL} \
                    -e SONAR_LOGIN=${SONAR_AUTH_TOKEN} \
                    sonarsource/sonar-scanner-cli \
                    -Dsonar.projectKey=my-project \
                    -Dsonar.sources=. \
                    -Dsonar.host.url=${SONAR_HOST_URL} \
                    -Dsonar.login=${SONAR_AUTH_TOKEN}
                """
            }
        }

        stage('Generate Markdown Report') {
            steps {
                echo 'Generating SonarQube Markdown report'
                script {
                    // Télécharger le rapport SonarQube au format JSON
                    sh """
                    curl -u ${SONAR_AUTH_TOKEN}: \
                    "${SONAR_HOST_URL}/api/issues/search?componentKeys=my-project&resolved=false" -o sonar_report.json
                    """
                    
                    // Générer un fichier Markdown à partir du rapport JSON sans caractères spéciaux
                    sh '''
                    echo "# SonarQube Analysis Report" > sonar_report.md
                    echo "## Issues Summary" >> sonar_report.md
                    echo "" >> sonar_report.md

                    # Ajouter les informations des issues dans le fichier Markdown
                    jq -r '.issues[] | "- \(.message) - Severity: \(.severity) - Line: \(.line)"' sonar_report.json | \
                    sed 's/[^a-zA-Z0-9 ]//g' >> sonar_report.md  # Supprimer les caractères spéciaux
                    '''
                }
            }
        }

        stage('Push to GitHub') {
            steps {
                echo 'Pushing Markdown report to GitHub'
                sh """
                git config --global user.email "bahaeaouanet2004@gmail.com"
                git config --global user.name "bahae112"
                git add sonar_report.md  // Ajouter le fichier Markdown au commit
                git commit -m 'Automated commit from Jenkins with SonarQube markdown report'
                git push origin ${BRANCH_NAME}
                """
            }
        }
    }
}
