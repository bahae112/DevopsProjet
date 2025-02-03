pipeline {
    agent any
    stages {
        stage('Authenticate gcloud') {
            steps {
                script {
                    // Activer le compte de service
                    sh '''
                    gcloud auth activate-service-account --key-file="/mnt/c/Users/ASUS/Downloads/glass-mantra-447916-d1-03e779bd3e6b - Copie.json"
                    gcloud config set account deploydockerimage@glass-mantra-447916-d1.iam.gserviceaccount.com
                    // Définir le projet
                    gcloud config set project glass-mantra-447916-d1
                    '''
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    // Commande de déploiement
                    sh 'gcloud app deploy'
                }
            }
        }
    }
}
