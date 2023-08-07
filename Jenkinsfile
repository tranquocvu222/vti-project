pipeline {
    agent any

    stages {
        stage('Checkout source') {
            steps {
                checkout scm
            }
        }

        stage('Test') {
            steps {
                sh './gradlew test'
            }
        }

        stage('Build') {
             steps {
                sh './gradlew build'
             }
        }

        stage('Build Image') {
             steps {
                sh 'docker build -t vti-api-project:1 .'
             }
        }

        stage('Push Image') {
            steps {
                withDockerRegistry([credentialsId: 'vu-dockerhub', url: 'https://index.docker.io/v1/']) {
                    sh 'docker tag vti-api-project:1 tranquocvu222/vti-project:1'
                    sh 'docker push tranquocvu222/vti-project:1'
                 }
            }
        }

        stage('Deploy Kubernetes deployment') {
            steps {
                sh 'kubectl apply -f deployment.yaml'
            }
        }
    }
}