stage('Deploy') {
    steps {
        script {
            sh '''
            cd myapp  # Adapter si nécessaire
            gcloud app deploy --quiet
            '''
        }
    }
}
