pipeline {

  agent any

  environment {
     DOCKER_ID = credentials('docker-hub-credentials-id')
     USERNAME = "${DOCKER_ID_USR}"
     PASSWORD = "${DOCKER_ID_PSW}"
     BUILD_NUMBER = "${env.BUILD_NUMBER}"
  }

  stages {

    stage('Unit Test') {
      steps {
          nodejs('Node-16.15.1') {
              sh 'echo "### Install packages ####"'
              sh 'yarn --cwd ./react-calculator install'
              sh 'echo "#### Run Unit Test ####"'
              sh 'yarn --cwd ./react-calculator test a --watchAll=false'
         }
      }
    }

    stage('Application build') {
      steps {
          nodejs('Node-16.15.1') {
              sh 'echo "#### Run Build ####"'
              sh 'yarn --cwd ./react-calculator build'
         }
      }
    }
   stage('Build and Push Docker image') {
     steps {
       sh 'docker build -t $USERNAME/nginx-react-calculator:$BUILD_NUMBER .'
       sh 'docker login -u $USERNAME -p $PASSWORD'
       sh 'docker push $USERNAME/nginx-react-calculator:$BUILD_NUMBER'
     }
   }
   stage('Production') {
     steps {

     }
   }
  post {
    success {
        slackSend  color: "good", channel: "#réalisation-du-projet-devops", message: "Build succeeds - ${env.JOB_NAME} ${env.BUILD_NUMBER}"
    }
    failure {
        slackSend color: "danger", channel: "#réalisation-du-projet-devops", message: "Build fails - ${env.JOB_NAME} ${env.BUILD_NUMBER}"
    }
  }
}
