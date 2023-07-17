pipeline {
    agent any
parameters {
        string(name: 'PERSON', defaultValue: 'Antu Acharjee', description: 'Who should I say hello to?')
        choice(name: 'DEPARTMENT', choices: ['DevOps', 'Java EE', 'iOS', 'Android'], description: 'Pick a department')

    }
    environment {
        BRANCH = "master"
        GIT_REPO = "https://github.com/iamantu93/project.git"
        DOCKER_REGISTRY = "iamantu93/project"
    }
    
    triggers {
        pollSCM('H/2 * * * *') // Polls the SCM every 2 minutes
    }
tools {
    maven 'MAVEN-3.6.3' 
    jdk 'JAVA_11'
    git 'Git-2.39.3'
}
stages {
    stage('git clone') {
        steps {
            echo 'cloning git repository'
            git branch: "${BRANCH}", url: "${GIT_REPO}"

        } 
    }   
    stage('Build stage') {
        steps {
            script {
                echo 'This is build stage'
                sh 'mvn clean package'
                customImage=docker.build("${env.DOCKER_REGISTRY}")
                customImage.push("${env.BUILD_ID}")
            }
        } 
    }
    stage('Clean Up') {
        steps {
            sh "docker rmi -f ${env.DOCKER_REGISTRY}:${env.BUILD_ID}"
        }
    }
    stage('Test stage') {
        steps {
            echo 'This is Test stage'
        } 
    }
    
    stage('Deploy stage') {
        steps {
            echo 'This is deploy stage'
            script {
               kubeconfig(credentialsId: 'kubeconf' ) {
                    sh "sed -i 's/TAG/${env.BUILD_ID}/g' kubernetesdeploy/springdeploy.yml" 
                    sh "/usr/bin/kubectl apply -f kubernetesdeploy/mysqldeploy.yml"
                    sh "/usr/bin/kubectl apply -f kubernetesdeploy/springdeploy.yml"
                }
            }
        } 
    }
    
 }
post { 
    success { 
        cleanWs()
        echo 'Status is green'
        echo "successfully built and deployed by ${PERSON}"
        echo "A proud ${DEPARTMENT} engineer"
    }

    failure{
        cleanWs()
        echo 'Status is red'
    }

    unstable{
        cleanWs()
        echo "Build is unstable"
    }
}
}
