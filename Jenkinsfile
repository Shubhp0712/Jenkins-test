pipeline {
    agent any 

    parameters {
        gitParameter(name: 'BRANCH_NAME', type: 'PT_BRANCH', defaultValue: 'main', branchFilter: 'origin/(.*)', description: 'Select the branch you want from to build dockerfile.', useRepository: 'https://github.com/Shubhp0712/Jenkins-test.git')
    }

    stages {
        stage("Checkout target code") {
            steps {
                git branch: "${params.BRANCH_NAME}" , url: 'https://github.com/Shubhp0712/Jenkins-test.git'
            }
        }
        stage("Build the image") {
            steps {
                sh "docker build -t test:${params.BRANCH_NAME} ."
                echo "docker image built successfully."
            }
        }
        stage("Scanning image") {
            steps {
                echo "Scanning image ..."
                sh """
                    docker run --rm \
                      -v /var/run/docker.sock:/var/run/docker.sock \
                      -v /tmp/trivy-cache:/root/.cache/ \
                      aquasec/trivy:latest image \
                      --severity HIGH,CRITICAL \
                      test:${params.BRANCH_NAME}
                """
            }
        }
        stage("Pushing image") {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'Dockerhub', 
                    usernameVariable: 'DOCKER_USER', 
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh "echo ${DOCKER_PASS} | docker login -u ${DOCKER_USER} --password-stdin"
                    echo "Login Succedded .."
                    sh "docker tag test:${params.BRANCH_NAME} \$DOCKER_USER/test:${params.BRANCH_NAME}"
                    sh "docker push \$DOCKER_USER/test:${params.BRANCH_NAME}"
                    echo "Image pushed to dockerhub successfully."
                    sh "docker logout"
                } 
            }
        }
    }
}