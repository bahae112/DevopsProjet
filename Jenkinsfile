pipeline {
    agent any

    environment {
        IMAGE_NAME = 'my-image'
        REGISTRY = 'docker.io'
        DOCKERFILE_PATH = 'Dockerfile'
        GIT_URL = 'https://github.com/bahae112/DevopsProjet.git'
        BRANCH_NAME = 'main'
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

        stage('Generate Markdown Report in README.md') {
            steps {
                echo 'Generating SonarQube Markdown report in README.md'
                script {
                    sh """
                    echo "📊 **SonarQube Analysis Report**" > README.md
                    echo "---" >> README.md
                    echo "### 📝 Issues Summary" >> README.md
                    echo "" >> README.md

                    # Récupérer le rapport JSON complet
                    curl -s -u ${SONAR_AUTH_TOKEN}: \
                    "${SONAR_HOST_URL}/api/issues/search?componentKeys=my-project&resolved=false" -o sonar_report.json

                    # Ajouter le nombre total d'issues
                    TOTAL_ISSUES=\$(grep -o '"total": *[0-9]*' sonar_report.json | head -1 | awk '{print \$2}')
                    echo "**Total Issues: \${TOTAL_ISSUES}**" >> README.md
                    echo "" >> README.md

                    # Extraire les messages d'erreur et formater
                    echo "### 🔍 Detected Issues" >> README.md
                    grep -o '"message": *"[^"]*"' sonar_report.json | sed 's/"message": "//' | while read line; do
                        echo "- **\${line}**" >> README.md
                    done

                    # Ajouter les niveaux de sévérité
                    echo "" >> README.md
                    echo "### 🚨 Severity Levels" >> README.md
                    grep -o '"severity": *"[^"]*"' sonar_report.json | sed 's/"severity": "//' | while read severity; do
                        echo "- 🔴 **\${severity}**" >> README.md
                    done

                    # Afficher le contenu brut de l'API (formaté)
                    echo "" >> README.md
                    echo "### 📜 Raw JSON Report" >> README.md
                    echo "```json" >> README.md
                    cat sonar_report.json | jq . >> README.md || cat sonar_report.json >> README.md
                    echo "```" >> README.md
                    """
                }
            }
        }

        stage('Push to GitHub') {
            steps {
                echo 'Pushing modified README.md to GitHub'
                withCredentials([string(credentialsId: 'GITHUB_TOKEN', variable: 'TOKEN')]) {
                    sh """
                    git config --global user.email "bahaeaouanet2004@gmail.com"
                    git config --global user.name "bahae112"

                    git remote set-url origin https://bahae112:${TOKEN}@github.com/bahae112/DevopsProjet.git
                    git add README.md
                    git commit -m 'Automated commit from Jenkins with formatted SonarQube report'
                    git push origin ${BRANCH_NAME}
                    """
                }
            }
        }
    }
}
