pipeline {
    agent any
    stages {
        stage('Authenticate gcloud') {
            steps {
                sh 'gcloud --version'  // Vérifier si gcloud est installé et fonctionne
                sh 'gcloud auth list'  // Afficher les comptes authentifiés
                sh 'gcloud config list'  // Afficher la configuration de gcloud
            }
        }
        stage('Deploy') {
            steps {
                // Ajoutez ici votre commande gcloud pour déployer
                sh 'gcloud app deploy'
            }
        }
    }
}
