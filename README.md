# VTI-project 

# Jenkins Pipeline for Spring Boot Application Deployment

This repository contains a Jenkins pipeline configuration for automating the deployment process of a Spring Boot application using Kubernetes and Docker. The pipeline follows a sequence of stages, each responsible for specific tasks to ensure a smooth and reliable deployment process.

## Pipeline Stages

### 1. Checkout Source
- This stage retrieves the source code from the version control system (e.g., GitHub) to be used in the deployment process.

### 2. Test
- In this stage, the application's unit tests are executed using the Gradle build tool. This ensures that the code is functioning as expected.

### 3. Build
- The application is built using the Gradle build tool, generating the necessary artifacts for deployment.

### 4. Build Image
- The Docker image of the application is created using the provided Dockerfile. This image will be used for running the application in a containerized environment.

### 5. Push Image
- The Docker image is tagged and pushed to a Docker registry. This step ensures that the image is accessible by the Kubernetes cluster during deployment.

### 6. Deploy Kubernetes Deployment
- The Kubernetes deployment configuration (`deployment.yaml`) is applied using the `kubectl` command. This stage ensures that the latest version of the application is deployed in the Kubernetes cluster.

## How to Use

1. **Clone Repository**
    - Clone this repository to your Jenkins server or relevant workspace.

2. **Configure Jenkins**
    - Set up Jenkins with proper credentials to access your version control system (e.g., GitHub) and Docker registry (e.g., Docker Hub).

3. **Create Pipeline**
    - In Jenkins, create a new pipeline job and link it to the cloned repository.

4. **Configure Docker and Kubernetes**
    - Ensure that Docker and Kubernetes are properly set up on the Jenkins server and the target environment.

5. **Configure Dockerhub Credentials**
    - Set up Dockerhub credentials in Jenkins to allow deployment to the Docker cluster.

6. **Configure GithubWebhook for Jenkin pipeline**
   - In your GitHub repository settings, navigate to "Webhooks" and create a new webhook.
   - Set the Payload URL to the Jenkins webhook URL. Make sure that the Jenkins server is accessible from the internet or use a service like ngrok for testing.
   - Choose "application/json" as the Content type.
   - Select the events you want to trigger the webhook: "push".
   - Save the webhook configuration.

7**Run Pipeline**
    - Run the pipeline job in Jenkins. The defined stages will be executed sequentially to deploy your Spring Boot application to the Kubernetes cluster.


