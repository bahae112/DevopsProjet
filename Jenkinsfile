pipeline {
    agent any

    environment {
        PROJECT_ID = 'glass-mantra-447916-d1' // Remplacez par votre ID projet GCP
        IMAGE_NAME = 'my-image'
        IMAGE_TAG = 'latest'
        GCR_HOSTNAME = 'gcr.io'
        SERVICE_NAME = 'gcloudJenkins' // Nom de votre service Cloud Run
        REGION = 'us-central1' // Région de déploiement
        JSON_KEY = credentials('gcloudJenkins') // Clé de service GCP stockée dans Jenkins
    }

    stages {
        stage('Authentification à Google Cloud') {
            steps {
                echo 'Authentification en cours...'
                sh '''
                echo $JSON_KEY > gcloud-key.json
                gcloud auth activate-service-account --key-file=gcloud-key.json
                gcloud config set project $PROJECT_ID
                '''
            }
        }

        stage('Push Docker Image to GCR') {
            steps {
                echo 'Push de l’image Docker vers Google Container Registry (GCR)...'
                sh '''
                gcloud auth configure-docker
                docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${GCR_HOSTNAME}/${PROJECT_ID}/${IMAGE_NAME}:${IMAGE_TAG}
                docker push ${GCR_HOSTNAME}/${PROJECT_ID}/${IMAGE_NAME}:${IMAGE_TAG}
                '''
            }
        }

        stage('Déploiement sur Google Cloud Run') {
            steps {
                echo 'Déploiement de l’image sur Google Cloud Run...'
                sh '''
                gcloud run deploy $SERVICE_NAME \
                    --image ${GCR_HOSTNAME}/${PROJECT_ID}/${IMAGE_NAME}:${IMAGE_TAG} \
                    --platform managed \
                    --region $REGION \
                    --allow-unauthenticated
                '''
            }
        }
    }

    post {
        success {
            echo 'Déploiement réussi sur Google Cloud Run ! 🎉'
        }
        failure {
            echo 'Échec du déploiement ❌'
        }
    }
}
