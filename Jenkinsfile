pipeline {

  agent {
       label 'app_node'
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
    stage('Build') {
        steps {
            nodejs('Node-16.15.1') {
              sh 'echo "#### Run Build ####"'
              sh 'yarn --cwd ./react-calculator build'
            }
        }
    }
    stage('Pre-deployment') {
        steps {
            sh 'echo "### Deploy the web app on nginx docker container ###"'
            sh '''
                 # we launch the docker run command only if the react-calculator container is not running
                 BUILD_PATH="/home/vagrant/workspace/react-calculator-pipeline"
                 if [ ! "$(docker ps | grep -w react-calculator )" ]; then
                    docker run --name react-calculator --rm -v $BUILD_PATH/react-calculator/build:/usr/share/nginx/html:ro -p 80:80 -d nginx
                    echo "Web app successfully deployed. You may see it on localhost:8081"
                 else
                    echo "Web app refreshed and already deployed. You may see it on localhost:8081"
                 fi
               '''
        }
    }
  }
  /*
  post {
    always {
        slackSend channel: "#réalisation-du-projet-devops", message: "Build report - ${env.JOB_NAME} ${env.BUILD_NUMBER} - BUILD STATUS ${currentBuild.currentResult}"
    }
    success {
        slackSend  color: "good", channel: "#réalisation-du-projet-devops", message: "Build succeeds - ${env.JOB_NAME} ${env.BUILD_NUMBER}"
    }
    failure {
        slackSend color: "danger", channel: "#réalisation-du-projet-devops", message: "Build fails - ${env.JOB_NAME} ${env.BUILD_NUMBER}"
    }
  }*/
}
