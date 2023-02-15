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
    stage('Pre-production') {
     steps {
        sh 'echo "### Deploying the web app in pre-production###"'
        sh '''
            # we launch the docker run command only if the react-calculator-pre-prod container is not running
            if [ ! "$(docker ps | grep -w react-calculator-pre-prod )" ]; then

               docker run --name react-calculator-pre-prod --rm -p 8081:80 --ip=172.17.0.3 \
               -d $USERNAME/nginx-react-calculator:$BUILD_NUMBER

               echo "Web app successfully deployed in pre-production. You may see it on localhost:8081"
            else
               docker stop react-calculator-pre-prod
               docker run --name react-calculator-pre-prod --rm -p 8081:80 --ip=172.17.0.3 \
               -d $USERNAME/nginx-react-calculator:$BUILD_NUMBER

               echo "Web app successfully deployed in pre-production. You may see it on localhost:8081"
            fi
          '''
      }
     }
     stage('Production') {
          steps {
             sh 'echo "### Deploying the web app in production###"'
             sh '''
                 # we launch the docker run command only if the react-calculator-prod container is not running
                 if [ ! "$(docker ps | grep -w react-calculator-prod )" ]; then

                    docker run --name react-calculator-prod --rm -p 8082:80 --ip=172.17.0.2 \
                    -d $USERNAME/nginx-react-calculator:$BUILD_NUMBER

                    echo "Web app successfully deployed in production. You may see it on localhost:8082"
                 else
                    docker stop react-calculator-prod
                    docker run --name react-calculator-prod --rm -p 8082:80 --ip=172.17.0.2 \
                    -d $USERNAME/nginx-react-calculator:$BUILD_NUMBER

                    echo "Web app successfully deployed in production. You may see it on localhost:8082"
                 fi
               '''
          }
     }
   stage('Monitoring') {
    steps {
      sh 'echo "### Launching the nginx-prometheus-exporter container###" '
      sh '''
          if [ ! "$(docker ps | grep -w nginx-exporter )" ]; then
            docker run --rm -p 9113:9113 -d --name nginx-exporter nginx/nginx-prometheus-exporter \
            -nginx.scrape-uri http://172.17.0.2:80/metrics
          else
            docker stop nginx-exporter
            docker run --rm -p 9113:9113 -d --name nginx-exporter nginx/nginx-prometheus-exporter \
            -nginx.scrape-uri http://172.17.0.2:80/metrics
            echo "nginx-exporter is already running"
          fi
        '''
      sh 'echo "### Launching prometheus and grafana for monitoring ###" '
      sh 'docker-compose -f ./monitoring/docker-compose.yml up -d'
    }
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
