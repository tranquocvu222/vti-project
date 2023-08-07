pipeline {
    agent any

    stages {
        stage('Checkout source') {
            step {
                checkout scm
            }
        }

        stage('Test') {
            step {
                sh './gradlew test'
            }
        }

        stage('Build') {
             step {
                sh './gradlew test'
                }
        }

        stage('Build Image') {
             step {
                sh 'docker build -t vti-api-project:1 .'
             }
        }

        stage('Push Image') {
            step {
                withDockerRegistry([credentialsId: 'vu-dockerhub']) {
                    sh 'docker tag vti-api-project:1 tranquocvu222/vti-project:1'
                    sh 'docker push tranquocvu222/vti-project:1'
                 }
            }
        }

        stage('Deploy Kubernetes deployment') {
            step {
                sh 'kubectl apply -f deployment.yaml'
            }
        }
    }
}