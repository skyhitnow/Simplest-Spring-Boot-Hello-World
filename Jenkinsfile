pipeline{
    agent any
    tools{
        maven 'M3'
    }
    stages{
        stage('Build & Unit Tests'){
            steps{
                sh 'mvn clean verify -DskipITs=true'
                junit allowEmptyResults: true,testResults: '**/test-results/*.xml'
                archive 'target/*.jar'

            }
        }
         
        stage("Deployment"){ 
            steps{ 
            withCredentials([azureServicePrincipal('azure-sp')]){  
            stages{
                stage("creating the vm"){
                    steps{
                        echo "creating the vm"
                    }
                }

                stage("setting up application server"){
                    steps{
                        echo "setting up app server "
                    }
                }

                stage("deploying the app"){
                    steps{
                        echo "deploying the app"
                    }

                }
                    
            }
            }
        }
        } 
    }
}