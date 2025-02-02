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

        stage('Generate Report') {
            steps {
                echo 'Generating SonarQube report'
                script {
                    // Utilisation de Python pour traiter le fichier JSON généré par SonarQube
                    sh """
                    python3 <<EOF
                    import json

                    # Charger le fichier JSON des issues SonarQube
                    with open('target/sonar-report.json', 'r') as f:
                        data = json.load(f)

                    # Création d'un fichier markdown avec les issues
                    with open('sonar_report.md', 'w') as report:
                        report.write('# SonarQube Issues Report\n\n')
                        for issue in data['issues']:
                            report.write(f"- {issue['message']}\n")

                    EOF
                    """
                }
            }
        }

        stage('Push Report to GitHub') {
            steps {
                echo 'Pushing SonarQube report to GitHub'
                sh """
                git config --global user.email "bahaeaouanet2004@gmail.com"
                git config --global user.name "bahae112"
                git add sonar_report.md
                git commit -m 'Add SonarQube issues report'
                git push origin ${BRANCH_NAME}
                """
            }
        }
    }
}
