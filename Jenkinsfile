pipeline {
    agent any
    environment {
        //be sure to replace "willbla" with your own Docker Hub username
        DOCKER_IMAGE_NAME = "ptran32/nodejs-express-app"
    }
    
    options {
    skipDefaultCheckout(true)
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            when {
                branch 'master'
            }
            steps {
                script {
                    env.GIT_COMMIT_REV = sh (script: 'git log -n 1 --pretty=format:"%h"', returnStdout: true)

                    def app = docker.build("${DOCKER_IMAGE_NAME}:${GIT_COMMIT_REV}")
                }
            }
        }
        stage('Run Tests') {
            when {
                branch 'master'
            }
            steps {
                script {
                    app.inside {
                        sh 'npm test'
                    }
                }
            }
        }        
        stage('Push Docker Image') {
            when {
                branch 'master'
            }
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub_creds') {
                        app.push("${env.BUILD_NUMBER}")
                        app.push("latest")
                    }
                }
            }
        }
    }
}

