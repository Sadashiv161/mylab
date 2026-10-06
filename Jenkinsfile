pipeline {

    agent any

    environment {
        DOCKER_IMAGE = 'sadashivbhatt/linux-gui-lab'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {

                    def timestamp = new Date().format(
                        'ddMMyy-HHmmss',
                        TimeZone.getTimeZone('Asia/Kolkata')
                    )

                    env.IMAGE_TAG = timestamp

                    sh """
                        docker build \
                          -t ${DOCKER_IMAGE}:${IMAGE_TAG} \
                          -t ${DOCKER_IMAGE}:latest \
                          .
                    """
                }
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub',
                        usernameVariable: 'DOCKER_USERNAME',
                        passwordVariable: 'DOCKER_PASSWORD'
                    )
                ]) {
                    sh '''
                        echo "$DOCKER_PASSWORD" | \
                        docker login \
                        -u "$DOCKER_USERNAME" \
                        --password-stdin
                    '''
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                sh '''
                    docker push ${DOCKER_IMAGE}:${IMAGE_TAG}
                    docker push ${DOCKER_IMAGE}:latest
                '''
            }
        }

        stage('Cleanup') {
            steps {
                sh '''
                    docker logout || true

                    docker rmi \
                      ${DOCKER_IMAGE}:${IMAGE_TAG} \
                      ${DOCKER_IMAGE}:latest || true
                '''
            }
        }
    }

    post {
        success {
            echo "Docker image pushed successfully:"
            echo "${DOCKER_IMAGE}:${IMAGE_TAG}"
            echo "${DOCKER_IMAGE}:latest"
        }

        failure {
            echo "Docker build/push failed."
        }
    }
}
