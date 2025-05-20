pipeline {
    agent any
    
    tools {
        maven "M3"
        jdk "JDK21"
    }
    
    environment {
        DOCKERHUB_CREADENTIALS = credentials('dockerCredential')
        REGION = "ap-northeast-2"
        AWS_CREDENTIALS_NAME = "AWSCredentials"
    }
    
    stages {
        stage('Git Clone'){
            steps{
                echo 'Git Clone'
                git url:'https://github.com/sehun100444/spring-petclinic.git',
                    branch: 'main'
            }
            post {
                success{
                    echo 'Git Clone Success'
                }
                failure {
                    echo 'Git Clone Fail'
                }
            }
        }
        
        
        stage('Maven Build') {
            steps {
                echo 'Maven Build'
                sh 'mvn -Dmaven.test.failure.ignore=true clean package'
            }
        }

        // Docker Image 생성
        stage('Docker Image Build') {
            steps{
                echo 'Docker Image Build'
                dir("${env.WORKSPACE}") {
                    sh '''
                        docker build -t spring-petclinic:$BUILD_NUMBER .
                        docker tag spring-petclinic:$BUILD_NUMBER sehun1004/spring-petclinic:latest
                        '''
                }
            }
        }

        // Docker image Push
        stage('Docker Image Push') {
            steps {
                sh '''
                echo $DOCKERHUB_CREADENTIALS_PSW | docker login -u $DOCKERHUB_CREADENTIALS_USR --password-stdin
                docker push sehun1004/spring-petclinic:latest
                '''
            }
        }

        // Remove Docker Image
        stage('Remove Docker Image') {
            steps {
            sh '''
            docker rmi sehun1004/spring-petclinic:latest
            docker rmi spring-petclinic:$BUILD_NUMBER
            '''
            }
        }
    }
}
