pipeline {
  agent any

  environment {
    DOCKER_IMAGE = "docker.io/sehun1004/project3-spring:latest"
    KUBE_NAMESPACE = "default"
  }

  stages {
    stage('Clone Repository') {
      steps {
        dir('spring-petclinic') {
          git branch: 'main', url: 'https://github.com/sehun100444/spring-petclinic.git'
        }
      }
    }

    stage('Build Spring App') {
      steps {
        dir('spring-petclinic') {
          sh 'mvn clean package -DskipTests'
        }
      }
    }

    stage('Build Docker Image') {
      steps {
        dir('spring-petclinic') {
          sh 'docker build -t $DOCKER_IMAGE .'
        }
      }
    }

    stage('Push Docker Image') {
      steps {
        dir('spring-petclinic') {
          withCredentials([usernamePassword(
            credentialsId: 'project3-dockerhub',
            usernameVariable: 'DOCKER_USERNAME',
            passwordVariable: 'DOCKER_PASSWORD'
          )]) {
            sh '''
              echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
              docker push $DOCKER_IMAGE
            '''
          }
        }
      }
    }

    stage('Deploy to Kubernetes') {
      steps {
        dir('spring-petclinic') {
          sh '''
            kubectl apply -f spring-deployment.yaml
            kubectl apply -f spring-service.yaml
            kubectl apply -f ingress-spring.yaml
          '''
        }
      }
    }
  }
}
