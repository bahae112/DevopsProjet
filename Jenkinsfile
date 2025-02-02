pipeline {
    agent any

    environment {
        IMAGE_NAME = 'my-image'
        REGISTRY = 'docker.io'
        DOCKERFILE_PATH = 'Dockerfile'
        GIT_URL = 'https://github.com/bahae112/DevopsProjet.git'
        BRANCH_NAME = 'main' // Spécifiez ici la branche correcte
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

        stage('Update README with SonarQube Report') {
            steps {
                echo 'Updating README.md with SonarQube issues'
                script {
                    // Télécharger le rapport SonarQube au format JSON
                    sh """
                    curl -u ${SONAR_AUTH_TOKEN}: \
                    "${SONAR_HOST_URL}/api/issues/search?componentKeys=my-project&resolved=false" -o sonar_report.json
                    """

                    // Extraire les issues et mettre à jour le README.md
                    sh '''
                    echo "# SonarQube Analysis Report" > temp_README.md
                    echo "## Issues Summary" >> temp_README.md
                    echo "" >> temp_README.md

                    grep -o '"message":"[^"]*"' sonar_report.json | awk -F':' '{print "- " $2}' >> temp_README.md

                    cat README.md >> temp_README.md
                    mv temp_README.md README.md
                    '''
                }
            }
        }

        stage('Push to GitHub') {
            steps {
                echo 'Pushing README.md update to GitHub'
                sh '''
                git config --global user.email "bahaeaouanet2004@gmail.com"
                git config --global user.name "bahae112"

                pwd
                ls -la

                cd $(git rev-parse --show-toplevel)

                git add README.md
                git commit -m "Automated update of README.md with SonarQube report"
                git push origin ${BRANCH_NAME}
                '''
            }
        }
    }
}
