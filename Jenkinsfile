pipeline {
    agent any
    stages {
        stage('Checkout Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/TON-UTILISATEUR/TON-REPO.git'
            }
        }
        stage('Authenticate gcloud') {
            steps {
                script {
                    sh '''
                    gcloud auth activate-service-account --key-file="/mnt/c/Users/ASUS/Downloads/glass-mantra-447916-d1-03e779bd3e6b - Copie.json"
                    gcloud config set account deploydockerimage@glass-mantra-447916-d1.iam.gserviceaccount.com
                    gcloud config set project glass-mantra-447916-d1
                    '''
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    sh 'gcloud app deploy --quiet'
                }
            }
        }
    }
}
