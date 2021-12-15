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
         
        stage("azure login"){
            steps{
                withCredentials([azureServicePrincipal('azure-sp')]) {
                sh 'az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET -t $AZURE_TENANT_ID'
                }
}
            }
        
        stage("Deployment"){ 
            stages{
                stage("creating the vm"){
                    steps{

                        sh 'az vm run-command invoke -g testrg -n testvm --command-id RunShellScript --scripts "sudo apt-get install git"'

                        sh 'az vm run-command invoke -g testrg -n testvm --command-id RunShellScript --script-uri "https://github.com/skyhitnow/Simplest-Spring-Boot-Hello-World"'

 
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