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

stages {
      
    stage('Build stage') {
        steps {
            script {
                echo 'This is build stage'
                sh 'mvn clean package'
                sh 'docker build -t ${env.DOCKER_REGISTRY}:${env.BUILD_ID}'
                sh 'docker push ${env.DOCKER_REGISTRY}:${env.BUILD_ID}'
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
    
    stage('Updating manifest in git') {
        steps {
            echo 'This is deploy stage'
            script {
                sh "sed -i 's|\(image: iamantu93/project:\)[0-9]\+|\1'"${env.BUILD_ID}"'|' kubernetesdeploy/springdeploy.yml"
                sh "git add ."
                sh "git commit -m 'Updated build is ${env.BUILD_ID} ' "
                 withCredentials(credentialsId: 'iamantu93') {
                    sh "git push origin master"
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
