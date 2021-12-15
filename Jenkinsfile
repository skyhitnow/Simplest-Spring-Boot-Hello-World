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
        

      

            
        
        stage("create the infra"){
            steps{
                withCredentials([azureServicePrincipal(credentialsId: 'azure-sp',
                                    subscriptionIdVariable: 'ARM_SUBSCRIPTION_ID',
                                    clientIdVariable: 'ARM_CLIENT_ID',
                                    clientSecretVariable: 'ARM_CLIENT_SECRET',
                                    tenantIdVariable: 'ARM_TENANT_ID')]){
                                        echo "test"
                //sh 'terraform init'
                //sh 'terraform apply  --auto-approve'
                }
            }
        }
        
        stage("setup the app server"){
                    steps{
                        withCredentials([azureServicePrincipal('azure-sp')]){
                        sh 'az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET -t $AZURE_TENANT_ID'
                        //sh 'az vm run-command invoke -g testrg -n testvm --command-id RunShellScript --scripts "sudo apt-get install git -y"' 
                        //sh 'az vm run-command invoke -g testrg -n testvm --command-id RunShellScript --scripts "git clone https://github.com/skyhitnow/Simplest-Spring-Boot-Hello-World /opt/hello" ' 
                        //sh 'az vm run-command invoke -g testrg -n testvm --command-id RunShellScript --scripts "sudo chmod +x /opt/hello/deploy.sh && /opt/hello/deploy.sh"'
                        }
 
                    }
                }

                

        stage("deploying the app"){
                    steps{
                         withCredentials([azureServicePrincipal('azure-sp')]){
                        sh 'az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET -t $AZURE_TENANT_ID'
                        sh 'az vm show -d -g testrg -n testvm --query publicIps -o tsv'
                        sh 'az ssh config --resource-group testrg --vm-name testvm --file ./sshconfig'
                        sh 'az ssh config --ip `az vm show -d -g testrg -n testvm --query publicIps -o tsv` --file ./sshconfig'
                        sh  'az config set extension.use_dynamic_install=yes_without_prompt'
                        sh 'scp -F ./sshconfig target/example.smallest-0.0.1-SNAPSHOT.war blake@`az vm show -d -g testrg -n testvm --query publicIps -o tsv`:/opt/tomcat8/webapps/'
                        }

                        
                    }

                }
                    
            
        stage("destroy the infra"){
            steps{
                withCredentials([azureServicePrincipal(credentialsId: 'azure-sp',
                                    subscriptionIdVariable: 'ARM_SUBSCRIPTION_ID',
                                    clientIdVariable: 'ARM_CLIENT_ID',
                                    clientSecretVariable: 'ARM_CLIENT_SECRET',
                                    tenantIdVariable: 'ARM_TENANT_ID')]){
                echo "test"
                sh 'terraform destroy --auto-approve'
                }
            }
        }
        
    }
    
}
