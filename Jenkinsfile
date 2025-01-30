pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                script {
                    sh 'git status'  // Affiche l'état du dépôt
                    sh 'git branch -a'  // Affiche toutes les branches disponibles
                }
            }
        }
    }
}
