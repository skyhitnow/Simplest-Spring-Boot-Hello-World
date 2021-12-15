pipeline{
    agent any
    tools{
        maven 'M3'
        //terraform "terraform"
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
                sh 'export subscription_id="'+$AZURE_SUBSCRIPTION_ID+'"'
                sh 'export client_id="'+$AZURE_CLIENT_ID+'"'
                sh 'export client_secret="'+$AZURE_CLIENT_SECRET+'"'
                sh 'export tenant_id="'+$AZURE_TENANT_ID+'"'
                }
}
            }
        
        stage("create the infra"){
            steps{
                sh 'terraform init'
                sh 'terraform apply  --auto-approve'
            }
        }
        
        stage("setup the app server"){
                    steps{
                        sh 'az vm run-command invoke -g testrg -n testvm --command-id RunShellScript --scripts "sudo apt-get install default-jre -y;\
                            wget https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.73/bin/apache-tomcat-8.5.73.tar.gz; \
                            tar zxvf apache-tomcat-8.5.73.tar.gz; \
                            mv apache-tomcat-8.5.73/ /opt/apache-tomcat-8.5.73; \
                            ln -s /opt/apache-tomcat-8.5.73/ /opt/tomcat8; \
                            /opt/tomcat8/bin/startup.sh"' 

 
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
