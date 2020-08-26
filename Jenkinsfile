pipeline {
    agent any
    environment {
        DOCKER_IMAGE_NAME = "ptran32/nodejs-express-app"
    }
    
    options {
    skipDefaultCheckout(true)
    }

    stages {
        stage('Clean Workspace') {
            steps {
            deleteDir()
            }
        }
        stage('Git Clone Source') {
            steps {
                git url: 'https://github.com/ptran32/nodejs-express-app.git'
            }
        }

        stage('Test and Build Docker Image') {
            steps {
                script {
                    env.GIT_COMMIT_REV = sh (script: 'git log -n 1 --pretty=format:"%h"', returnStdout: true)
                    customImage = docker.build("${DOCKER_IMAGE_NAME}:${GIT_COMMIT_REV}-${env.BUILD_NUMBER}")
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub_creds') {
                        customImage.push("${GIT_COMMIT_REV}-${env.BUILD_NUMBER}")
                        customImage.push("latest")
                    }
                }
            }
        }
    }
}
