pipeline {

  agent none

  stages {
    stage('Test') {
             agent {
               label 'build_node'
             }
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
         agent {
            label 'build_node'
         }
        steps {
            nodejs('Node-16.15.1') {
              sh 'echo "#### Run Build ####"'
              sh 'yarn --cwd ./react-calculator build'
            }
        }
    }
    stage('Transfer Build to the app node') {
        agent {
            label 'build_node'
        }
        steps {
            script {
                withCredentials([sshUserPrivateKey(credentialsId: 'id_rsa', keyFileVariable: 'PRIVATE_KEY_FILE')]) {
                    def remote = [:];
                    remote.name = 'app_node';
                    remote.host = '172.16.0.3';
                    remote.allowAnyHosts = true;
                    remote.user = 'vagrant';
                    remote.identityFile = PRIVATE_KEY_FILE;
                    //Transfer the build directory from the build node to the app node
                    sshPut remote: remote, from: './react-calculator/build', into: '/home/vagrant/'
                }
            }
        }
    }
    stage('Deployment') {
        agent  {
           label 'app_node'
        }
        steps {
            sh 'echo "### Deploy the web app on nginx docker container ###"'
            sh '''
                 # we launch the docker run command only if the react-calculator container is not running
                 if [ ! "$(docker ps | grep -w react-calculator )" ]; then
                    docker run --name react-calculator --rm -v /home/vagrant/build:/usr/share/nginx/html:ro -p 80:80 -d nginx
                    echo "Web app successfully deployed. You may see it on localhost:8081"
                 else
                    echo "Web app refreshed and already deployed. You may see it on localhost:8081"
                 fi
               '''
        }
    }
  }
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
  }
}
