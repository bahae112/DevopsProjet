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
                    -Dsonar.login=${SONAR_AUTH_TOKEN} \
                    -Dsonar.analysis.mode=preview \
                    -Dsonar.report.export.path=target/sonar-report.json
                """
            }
        }

        stage('Validate Report Existence') {
            steps {
                script {
                    if (fileExists("target/sonar-report.json")) {
                        echo "SonarQube report exists, proceeding to generate markdown"
                    } else {
                        echo "SonarQube report does not exist"
                        currentBuild.result = 'FAILURE'
                    }
                }
            }
        }

        stage('Generate Markdown Report') {
            steps {
                echo 'Generating Markdown report from SonarQube issues'
                sh """
                python3 -c '
import json

# Charger le fichier JSON des issues SonarQube
with open("target/sonar-report.json", "r") as f:
    data = json.load(f)

# Création d'un fichier markdown avec les issues
with open("sonar-issues-report.md", "w") as md_file:
    md_file.write("# SonarQube Issues Report\n")
    for issue in data.get("issues", []):
        md_file.write("- **${issue["message"]}** (Severity: ${issue["severity"]})\n")
'
                """
            }
        }

        stage('Push to GitHub') {
            steps {
                echo 'Pushing changes to GitHub'
                sh """
                git config --global user.email "bahaeaouanet2004@gmail.com"
                git config --global user.name "bahae112"
                git add .
                git commit -m 'Automated commit from Jenkins: Added SonarQube issues report'
                git push origin ${BRANCH_NAME}
                """
            }
        }
    }
}
