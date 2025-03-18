pipeline {
    agent any
    
    tools {
        maven "M3"
        jdk "JDK17"
    }
    
    environment {
        DOCKERHUB_CREADENTIALS = credentials('dockerCredential')
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

        
        
        stage('SSH Publish') {
            steps {
                echo 'SSH Publish'
                sshPublisher(publishers: [sshPublisherDesc(configName: 'target', 
                transfers: [sshTransfer(cleanRemote: false, excludes: '',
                execCommand: '''docker rm -f $(docker ps -aq)
                                docker rmi $(docker images -q)
                                docker run -d -p 8080:8080 --name spring-petclinic sehun1004/spring-petclinic:latest
                                ''', 
                execTimeout: 120000, flatten: false, makeEmptyDirs: false, 
                noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '', 
                remoteDirectorySDF: false, removePrefix: 'target', sourceFiles: 'target/*.jar')], 
                usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])

            }
        }
    }
}
