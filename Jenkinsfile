pipeline {
    agent any
    
    environment {
        BRANCH = "master"
        GIT_REPO = "https://github.com/iamantu93/project.git"
        DOCKER_REGISTRY = "iamantu93/project"
        JAVA_HOME = "/usr/lib/jvm/java-11-openjdk-11.0.25.0.9-7.el9.x86_64"
        PATH = "${JAVA_HOME}/bin:${env.PATH}"
    }
    stages {
        stage('Build stage') {
            steps {
                script {
                    echo 'This is maven build stage'
                    sh 'mvn --version'
                    sh 'java --version'
                    sh 'sudo alternatives --set java /usr/lib/jvm/java-11-openjdk-11.0.25.0.9-7.el9.x86_64/bin/java'
                    sh 'mvn clean package  -Dmaven.test.skip=true'

                }
            } 
        }
        stage('Docker build and push stage') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_REGISTRY}:${BUILD_ID} ."  // Use ${DOCKER_REGISTRY} and ${BUILD_ID} directly
                    sh "docker push ${DOCKER_REGISTRY}:${BUILD_ID}"
                }
            }
            
        }
        
        stage('Clean Up') {
            steps {
                sh "docker rmi -f ${DOCKER_REGISTRY}:${BUILD_ID}"
            }
        }

        stage('Deploy') {
            steps {
                echo 'This is deploy stage'
                script {
                    sh "sed -i 's|\\(iamantu93/project:\\)[0-9]\\+|\\1${BUILD_ID}|' kubernetesdeploy/springdeploy.yml"
                    sh 'kubectl  --kubeconfig /var/lib/jenkins/.kubeconfig apply -f kubernetesdeploy/springdeploy.yml'

                }
            } 
        }
    }
    
    post { 
        success { 
            cleanWs()
            echo 'Status is green'
        }
        failure {
            cleanWs()
            echo 'Status is red'
        }
        unstable {
            cleanWs()
            echo "Build is unstable"
        }
    }
}
