pipeline{
    agent any
    tools{
        maven 'M3'

    }
    
    stages{
        stage('Build & Unit Tests'){}
            steps{
                sh 'mvn clean verify -DskipITs=true'
                junit allowEmptyResults: true,testResults: '**/test-results/*.xml'
                archive 'target/*.jar'

            }
        

      

            
        
        stage("create the infra"){
            steps{
                withCredentials([azureServicePrincipal(credentialsId: 'azure-sp',
                                    subscriptionIdVariable: ' ARM_SUBSCRIPTION_ID',
                                    clientIdVariable: 'ARM_CLIENT_ID',
                                    clientSecretVariable: 'ARM_CLIENT_SECRET',
                                    tenantIdVariable: 'ARM_TENANT_ID')]){
                sh 'terraform init'
                sh 'terraform apply  --auto-approve'
                }
            }
        }
        
        stage("setup the app server"){
                    steps{
                        withCredentials([azureServicePrincipal('azure-sp')]){
                        sh 'az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET -t $AZURE_TENANT_ID'
                        sh 'az vm run-command invoke -g testrg -n testvm --command-id RunShellScript --scripts "sudo apt-get install default-jre -y;\
                            wget https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.73/bin/apache-tomcat-8.5.73.tar.gz; \
                            tar zxvf apache-tomcat-8.5.73.tar.gz; \
                            mv apache-tomcat-8.5.73/ /opt/apache-tomcat-8.5.73; \
                            ln -s /opt/apache-tomcat-8.5.73/ /opt/tomcat8; \
                            /opt/tomcat8/bin/startup.sh"' 
                        }
 
                    }
                }

                

        stage("deploying the app"){
                    steps{
                        echo "deploying the app"
                    }

                }
                    
            
        stage("destroy the infra"){
            steps{
                echo "destroying the azure vm"
            }
        }
        
    }
    
}
